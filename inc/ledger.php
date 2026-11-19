<?php

declare(strict_types=1);

const MODES_COLLECTED = ['cash', 'fund_transfer'];
const MODES_ALL = ['cash', 'fund_transfer', 'direct', 'care_of', 'exempt'];
const PALETTE = ['#378ADD', '#D4537E', '#639922', '#BA7517', '#E24B4A', '#1D9E75', '#7F77DD', '#D85A30'];

class ApiError extends RuntimeException {}

function status_of(float $collected, float $remitted): string
{
    if ($remitted <= 0) {
        return 'open';
    }
    return ($remitted + 0.004) < $collected ? 'partial' : 'remitted';
}

/** Every collection of a fund with totals, remitted amount, status and age. */
function collections_for_fund(int $fundId): array
{
    $pdo = db();
    $st = $pdo->prepare(
        'SELECT c.id, c.fund_id, c.collected_on, c.color, c.note, c.created_by,
                COALESCE(SUM(p.amount), 0) AS collected, COUNT(p.id) AS entries
         FROM collections c LEFT JOIN payments p ON p.collection_id = c.id
         WHERE c.fund_id = ? GROUP BY c.id ORDER BY c.collected_on, c.id'
    );
    $st->execute([$fundId]);
    $rows = $st->fetchAll();
    if (!$rows) {
        return [];
    }
    $in = implode(',', array_map('intval', array_column($rows, 'id')));
    $rem = $pdo->query("SELECT collection_id, SUM(amount) FROM remittances WHERE collection_id IN ($in) GROUP BY collection_id")
        ->fetchAll(PDO::FETCH_KEY_PAIR);
    $today = new DateTimeImmutable('today');
    foreach ($rows as &$r) {
        $r['id'] = (int)$r['id'];
        $r['fund_id'] = (int)$r['fund_id'];
        $r['collected'] = (float)$r['collected'];
        $r['entries'] = (int)$r['entries'];
        $r['remitted'] = (float)($rem[$r['id']] ?? 0);
        $r['status'] = status_of($r['collected'], $r['remitted']);
        $r['locked'] = $r['status'] === 'remitted';
        $r['age_days'] = $r['locked'] ? null
            : (int)$today->diff(new DateTimeImmutable($r['collected_on']))->format('%a');
    }
    return $rows;
}

function collection_by_id(int $id): ?array
{
    $st = db()->prepare('SELECT fund_id FROM collections WHERE id = ?');
    $st->execute([$id]);
    $fund = $st->fetchColumn();
    if ($fund === false) {
        return null;
    }
    foreach (collections_for_fund((int)$fund) as $c) {
        if ($c['id'] === $id) {
            return $c;
        }
    }
    return null;
}

/** Same date in another tab keeps the same color; otherwise the first color not used recently. */
function pick_color(int $fundId, string $date): string
{
    $pdo = db();
    $st = $pdo->prepare('SELECT color FROM collections WHERE collected_on = ? LIMIT 1');
    $st->execute([$date]);
    if ($c = $st->fetchColumn()) {
        return $c;
    }
    $st = $pdo->prepare('SELECT color FROM collections WHERE fund_id = ? ORDER BY collected_on DESC, id DESC LIMIT 6');
    $st->execute([$fundId]);
    $used = $st->fetchAll(PDO::FETCH_COLUMN);
    foreach (PALETTE as $c) {
        if (!in_array($c, $used, true)) {
            return $c;
        }
    }
    return PALETTE[count($used) % count(PALETTE)];
}

function funds_list(): array
{
    return db()->query('SELECT id, name, default_amount FROM funds WHERE active = 1 ORDER BY sort_no, id')->fetchAll();
}

function sorted_employees(string $where = 'active = 1'): array
{
    $emps = db()->query("SELECT id, name, division, status, start_on, remarks, active FROM employees WHERE $where")->fetchAll();
    $order = array_flip((array)cfg('division_order'));
    $rank = fn($d) => $d === '' ? 1000 : ($order[$d] ?? 500);
    usort($emps, fn($a, $b) => [$rank($a['division']), $a['division'], mb_strtolower($a['name'])]
        <=> [$rank($b['division']), $b['division'], mb_strtolower($b['name'])]);
    foreach ($emps as &$e) {
        $e['id'] = (int)$e['id'];
    }
    return $emps;
}

function build_state(int $fundId): array
{
    $pdo = db();
    $funds = funds_list();
    $fund = null;
    foreach ($funds as $f) {
        if ((int)$f['id'] === $fundId) {
            $fund = $f;
        }
    }
    if (!$fund) {
        throw new ApiError('That tab does not exist.');
    }
    $st = $pdo->prepare('SELECT id, label, due_on, beneficiary_id FROM periods WHERE fund_id = ? ORDER BY sort_no, id');
    $st->execute([$fundId]);
    $periods = $st->fetchAll();
    foreach ($periods as &$p) {
        $p['id'] = (int)$p['id'];
        $p['beneficiary_id'] = $p['beneficiary_id'] === null ? null : (int)$p['beneficiary_id'];
    }

    $st = $pdo->prepare(
        'SELECT p.id, p.employee_id, p.period_id, p.collection_id, p.amount, p.mode, p.note
         FROM payments p JOIN periods pr ON pr.id = p.period_id WHERE pr.fund_id = ?'
    );
    $st->execute([$fundId]);
    $payments = $st->fetchAll();
    foreach ($payments as &$p) {
        $p['id'] = (int)$p['id'];
        $p['employee_id'] = (int)$p['employee_id'];
        $p['period_id'] = (int)$p['period_id'];
        $p['collection_id'] = $p['collection_id'] === null ? null : (int)$p['collection_id'];
        $p['amount'] = (float)$p['amount'];
    }

    $collections = collections_for_fund($fundId);
    $active = (int)($_SESSION['active'][$fundId] ?? 0);
    $ok = false;
    foreach ($collections as $c) {
        if ($c['id'] === $active && !$c['locked']) {
            $ok = true;
        }
    }
    if (!$ok) {
        $active = 0;
    }

    return [
        'fund'           => ['id' => (int)$fund['id'], 'name' => $fund['name']],
        'default_amount' => (float)$fund['default_amount'],
        'today'          => date('Y-m-d'),
        'periods'        => $periods,
        'employees'      => sorted_employees(),
        'payments'       => $payments,
        'collections'    => $collections,
        'active'         => $active,
        'is_admin'       => is_admin(),
    ];
}


function valid_date(string $v, string $what): string
{
    $d = DateTime::createFromFormat('Y-m-d', $v);
    if (!$d || $d->format('Y-m-d') !== $v) {
        throw new ApiError("Enter a valid date for $what.");
    }
    return $v;
}

/** Records money handed over for a collection. Partial amounts are fine. */
function add_remittance(int $collectionId, string $date, float $amount, string $mode, string $reference, int $uid): void
{
    $c = collection_by_id($collectionId);
    if (!$c) {
        throw new ApiError('That collection was not found.');
    }
    valid_date($date, 'the remittance');
    $amount = round($amount, 2);
    if (!in_array($mode, ['cash', 'fund_transfer', 'care_of'], true)) {
        throw new ApiError('Choose how it was remitted.');
    }
    $left = round($c['collected'] - $c['remitted'], 2);
    if ($amount <= 0) {
        throw new ApiError('Enter the amount you remitted.');
    }
    if ($amount > $left + 0.004) {
        throw new ApiError('That is more than the ' . money($left) . ' still to remit for this collection.');
    }
    db()->prepare('INSERT INTO remittances (collection_id, remitted_on, amount, mode, reference, created_by) VALUES (?, ?, ?, ?, ?, ?)')
        ->execute([$collectionId, $date, $amount, $mode, trim($reference) ?: null, $uid ?: null]);
    log_action('remitted', "Collection #$collectionId: " . money($amount) . " $mode on $date");
}


const MONTH_LABELS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/** Adds the columns that "Add tab" needs to the funds table the first time they are used. */
function ensure_tab_columns(): void
{
    $pdo = db();
    if ($pdo->query("SHOW COLUMNS FROM funds LIKE 'repeat_yearly'")->fetch()) {
        return;
    }
    try {
        $pdo->exec("ALTER TABLE funds
            ADD COLUMN label VARCHAR(60) NULL AFTER name,
            ADD COLUMN year SMALLINT NULL AFTER label,
            ADD COLUMN kind ENUM('months','cases') NOT NULL DEFAULT 'cases' AFTER year,
            ADD COLUMN repeat_yearly TINYINT(1) NOT NULL DEFAULT 0 AFTER kind");
    } catch (PDOException $e) {
        error_log('EAP tracker ensure_tab_columns: ' . $e->getMessage());
        throw new ApiError('The database needs a small update first. Run migrate_tabs.sql once, then try again.');
    }
}

/** Creates the new year's copy of every tab that was marked "repeat every year". Returns how many were made. */
function copy_yearly_tabs(int $year, int $sort): int
{
    $pdo = db();
    $rows = $pdo->query(
        'SELECT f.label, f.default_amount, f.kind
         FROM funds f
         JOIN (SELECT label, MAX(year) AS y FROM funds
               WHERE repeat_yearly = 1 AND label IS NOT NULL AND year IS NOT NULL AND year < ' . (int)$year . '
               GROUP BY label) m ON m.label = f.label AND m.y = f.year
         WHERE f.repeat_yearly = 1'
    )->fetchAll();
    $exists = $pdo->prepare('SELECT COUNT(*) FROM funds WHERE name = ?');
    $ins = $pdo->prepare('INSERT INTO funds (name, label, year, kind, repeat_yearly, default_amount, sort_no) VALUES (?, ?, ?, ?, 1, ?, ?)');
    $pi = $pdo->prepare('INSERT INTO periods (fund_id, label, due_on, sort_no) VALUES (?, ?, ?, ?)');
    $made = 0;
    foreach ($rows as $r) {
        $name = $year . ' ' . $r['label'];
        $exists->execute([$name]);
        if ($exists->fetchColumn()) {
            continue;
        }
        $ins->execute([$name, $r['label'], $year, $r['kind'], $r['default_amount'], ++$sort]);
        if ($r['kind'] === 'months') {
            $fid = (int)$pdo->lastInsertId();
            foreach (MONTH_LABELS as $i => $m) {
                $pi->execute([$fid, $m, sprintf('%04d-%02d-01', $year, $i + 1), $i + 1]);
            }
        }
        $made++;
    }
    return $made;
}
