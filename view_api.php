<?php

declare(strict_types=1);
// Read-only data for the public page (view.php). No login needed, so it is deliberately narrow:
// it only ever returns one person's colored boxes, never notes, remarks, totals of other people
// or remittance details, and every visitor is rate limited.
require __DIR__ . '/inc/bootstrap.php';
require __DIR__ . '/inc/ledger.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');
header('X-Robots-Tag: noindex, nofollow');

function out(array $data, int $code = 200): void
{
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

/** False when this visitor (by IP address) has used up their allowance for the period. */
function allow(string $bucket, int $limit, int $seconds): bool
{
    try {
        $pdo = db();
        $pdo->exec('CREATE TABLE IF NOT EXISTS public_hits (
            id INT AUTO_INCREMENT PRIMARY KEY,
            bucket VARCHAR(20) NOT NULL,
            ip VARCHAR(45) NOT NULL,
            hit_at DATETIME NOT NULL,
            KEY idx_hits (bucket, ip, hit_at)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        $ip = substr((string)($_SERVER['REMOTE_ADDR'] ?? '0'), 0, 45);
        if (random_int(1, 50) === 1) {
            $pdo->prepare('DELETE FROM public_hits WHERE hit_at < ?')->execute([date('Y-m-d H:i:s', time() - 7200)]);
        }
        $st = $pdo->prepare('SELECT COUNT(*) FROM public_hits WHERE bucket = ? AND ip = ? AND hit_at >= ?');
        $st->execute([$bucket, $ip, date('Y-m-d H:i:s', time() - $seconds)]);
        if ((int)$st->fetchColumn() >= $limit) {
            return false;
        }
        $pdo->prepare('INSERT INTO public_hits (bucket, ip, hit_at) VALUES (?, ?, ?)')->execute([$bucket, $ip, date('Y-m-d H:i:s')]);
    } catch (PDOException $e) {
        error_log('EAP tracker public throttle: ' . $e->getMessage());
    }
    return true;
}

try {
    if (cfg('public_view') === false) {
        out(['error' => 'Public viewing is turned off.'], 403);
    }
    $pdo = db();
    $code = trim((string)(cfg('public_code') ?? ''));
    $staff = current_user() !== null;
    $action = (string)($_GET['action'] ?? '');

    if ($action === 'unlock') {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            out(['error' => 'Use the form on the page.'], 405);
        }
        check_csrf(true);
        if (!allow('unlock', 8, 600)) {
            out(['error' => 'Too many tries. Wait a few minutes and try again.'], 429);
        }
        $in = json_decode((string)file_get_contents('php://input'), true) ?: [];
        if ($code !== '' && hash_equals($code, trim((string)($in['code'] ?? '')))) {
            $_SESSION['pub_ok'] = true;
            out(['ok' => true]);
        }
        out(['error' => 'That code is not right.'], 403);
    }

    if ($code !== '' && !$staff && empty($_SESSION['pub_ok'])) {
        out(['need_code' => true, 'error' => 'Enter the access code first.'], 401);
    }
    if (!allow('view', 60, 60)) {
        out(['error' => 'Too many searches. Wait a minute and try again.'], 429);
    }

    if ($action === 'search') {
        $q = trim((string)preg_replace('/\s+/', ' ', (string)($_GET['q'] ?? '')));
        if (mb_strlen($q) < 2) {
            out(['results' => []]);
        }
        $where = [];
        $args = [];
        foreach (array_slice(explode(' ', $q), 0, 5) as $w) {
            $where[] = 'name LIKE ?';
            $args[] = '%' . addcslashes($w, '%_\\') . '%';
        }
        $st = $pdo->prepare('SELECT id, name, division FROM employees WHERE active = 1 AND ' . implode(' AND ', $where) . ' ORDER BY name LIMIT 9');
        $st->execute($args);
        $rows = $st->fetchAll();
        $more = count($rows) > 8;
        $rows = array_slice($rows, 0, 8);
        foreach ($rows as &$r) {
            $r['id'] = (int)$r['id'];
        }
        out(['results' => $rows, 'more' => $more]);
    }

    if ($action === 'record') {
        $st = $pdo->prepare('SELECT id, name, division, status, start_on FROM employees WHERE id = ? AND active = 1');
        $st->execute([(int)($_GET['id'] ?? 0)]);
        $emp = $st->fetch();
        if (!$emp) {
            out(['error' => 'That name was not found.'], 404);
        }
        $today = date('Y-m-d');
        $funds = [];
        foreach (funds_list() as $f) {
            $fid = (int)$f['id'];
            $st = $pdo->prepare('SELECT id, label, due_on, beneficiary_id FROM periods WHERE fund_id = ? ORDER BY sort_no, id');
            $st->execute([$fid]);
            $periods = $st->fetchAll();
            $st = $pdo->prepare(
                'SELECT p.period_id, p.collection_id, p.amount, p.mode, c.color, c.collected_on
                 FROM payments p JOIN periods pr ON pr.id = p.period_id
                 LEFT JOIN collections c ON c.id = p.collection_id
                 WHERE p.employee_id = ? AND pr.fund_id = ?'
            );
            $st->execute([(int)$emp['id'], $fid]);
            $by = [];
            foreach ($st->fetchAll() as $r) {
                $by[(int)$r['period_id']] = $r;
            }
            $cells = [];
            $legend = [];
            $total = 0.0;
            $show = false;
            foreach ($periods as $p) {
                $r = $by[(int)$p['id']] ?? null;
                $cell = ['label' => $p['label']];
                if ($r && $r['collection_id']) {
                    $cell += ['state' => 'paid', 'amount' => (float)$r['amount'], 'color' => $r['color'], 'date' => $r['collected_on'], 'mode' => $r['mode']];
                    $total += (float)$r['amount'];
                    $legend[$r['collected_on'] . '|' . $r['color']] = ['date' => $r['collected_on'], 'color' => $r['color']];
                    $show = true;
                } elseif ($r) {
                    $cell += ['state' => $r['mode'], 'amount' => (float)$r['amount']];
                    $show = true;
                } elseif ((int)$p['beneficiary_id'] === (int)$emp['id']) {
                    $cell['state'] = 'own';
                    $show = true;
                } else {
                    $due = $emp['status'] === 'enrolled'
                        && (!$p['due_on'] || $p['due_on'] <= $today)
                        && !($emp['start_on'] && $p['due_on'] && substr($p['due_on'], 0, 7) < substr($emp['start_on'], 0, 7));
                    $cell['state'] = $due ? 'due' : 'empty';
                    $show = $show || $due;
                }
                $cells[] = $cell;
            }
            if (!$periods || !$show) {
                continue;
            }
            ksort($legend);
            $funds[] = ['name' => $f['name'], 'cells' => $cells, 'total' => $total, 'legend' => array_values($legend)];
        }
        $upd = $pdo->query('SELECT MAX(updated_at) FROM payments')->fetchColumn();
        out([
            'employee' => ['name' => $emp['name'], 'division' => $emp['division'], 'status' => $emp['status']],
            'funds'    => $funds,
            'updated'  => $upd ? substr((string)$upd, 0, 10) : null,
        ]);
    }

    out(['error' => 'Unknown request.'], 400);
} catch (Throwable $e) {
    error_log('EAP tracker public: ' . $e);
    out(['error' => cfg('debug') ? $e->getMessage() : 'Something went wrong. Try again in a moment.'], 500);
}
