<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require __DIR__ . '/inc/ledger.php';

header('Content-Type: application/json; charset=utf-8');

function json_out(array $data, int $code = 200): void
{
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

if (!current_user()) {
    json_out(['error' => 'Your session expired. Sign in again.'], 401);
}

$action = (string)($_GET['action'] ?? '');
$fundId = (int)($_GET['fund'] ?? 0);
$in = [];
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    check_csrf(true);
    $in = json_decode((string)file_get_contents('php://input'), true) ?: [];
}

function fund_must_exist(int $fundId): void
{
    $st = db()->prepare('SELECT COUNT(*) FROM funds WHERE id = ? AND active = 1');
    $st->execute([$fundId]);
    if (!$st->fetchColumn()) {
        throw new ApiError('That tab does not exist.');
    }
}

try {
    $pdo = db();
    $uid = current_user()['id'];

    switch ($action) {
        case 'state':
            json_out(build_state($fundId));

        case 'collect_today':
            fund_must_exist($fundId);
            $today = (string)($in['date'] ?? '') !== '' ? valid_date((string)$in['date'], 'the collection') : date('Y-m-d');
            if ($today > date('Y-m-d')) {
                throw new ApiError('A collection date cannot be in the future.');
            }
            $st = $pdo->prepare('SELECT id FROM collections WHERE fund_id = ? AND collected_on = ? ORDER BY id');
            $st->execute([$fundId, $today]);
            $id = 0;
            foreach ($st->fetchAll(PDO::FETCH_COLUMN) as $cid) {
                $c = collection_by_id((int)$cid);
                if ($c && !$c['locked']) {
                    $id = (int)$cid;
                    break;
                }
            }
            if (!$id) {
                $pdo->prepare('INSERT INTO collections (fund_id, collected_on, color, created_by) VALUES (?, ?, ?, ?)')
                    ->execute([$fundId, $today, pick_color($fundId, $today), $uid]);
                $id = (int)$pdo->lastInsertId();
                log_action('collection_created', "Collection #$id on $today (tab $fundId)");
            }
            if ($today === date('Y-m-d')) {
                $_SESSION['active'][$fundId] = $id;
            }
            json_out(['ok' => true, 'collection_id' => $id]);

        case 'set_active':
            fund_must_exist($fundId);
            $id = (int)($in['collection_id'] ?? 0);
            if ($id) {
                $c = collection_by_id($id);
                if (!$c || $c['fund_id'] !== $fundId || $c['locked']) {
                    throw new ApiError('That collection is not open for recording.');
                }
            }
            $_SESSION['active'][$fundId] = $id;
            json_out(['ok' => true]);

        case 'save_payment':
            fund_must_exist($fundId);
            $empId = (int)($in['employee_id'] ?? 0);
            $perId = (int)($in['period_id'] ?? 0);
            $mode = (string)($in['mode'] ?? 'cash');
            $amount = round((float)($in['amount'] ?? 0), 2);
            $note = trim((string)($in['note'] ?? ''));
            $colId = (int)($in['collection_id'] ?? 0);

            if (!in_array($mode, MODES_ALL, true)) {
                throw new ApiError('Choose how this was paid.');
            }
            if ($amount < 0) {
                throw new ApiError('The amount cannot be negative.');
            }
            $st = $pdo->prepare('SELECT label FROM periods WHERE id = ? AND fund_id = ?');
            $st->execute([$perId, $fundId]);
            $perLabel = $st->fetchColumn();
            $st = $pdo->prepare('SELECT name FROM employees WHERE id = ? AND active = 1');
            $st->execute([$empId]);
            $empName = $st->fetchColumn();
            if ($perLabel === false || $empName === false) {
                throw new ApiError('That employee or column was not found.');
            }

            if (in_array($mode, MODES_COLLECTED, true)) {
                if ($amount <= 0) {
                    throw new ApiError('Enter an amount greater than zero.');
                }
                if (!$colId) {
                    throw new ApiError('Press Collect today first, or pick a collection.');
                }
                $col = collection_by_id($colId);
                if (!$col || $col['fund_id'] !== $fundId) {
                    throw new ApiError('That collection is not in this tab.');
                }
                if ($col['locked']) {
                    throw new ApiError('That collection is already fully remitted. Delete its remittance to change it.');
                }
            } else {
                $colId = 0;
                if ($mode === 'exempt') {
                    $amount = 0;
                }
            }

            $st = $pdo->prepare('SELECT id, collection_id FROM payments WHERE employee_id = ? AND period_id = ?');
            $st->execute([$empId, $perId]);
            $ex = $st->fetch();
            if ($ex && $ex['collection_id']) {
                $old = collection_by_id((int)$ex['collection_id']);
                if ($old && $old['locked']) {
                    throw new ApiError('This payment is in a remitted collection. Delete the remittance first to change it.');
                }
            }
            $colVal = $colId ?: null;
            if ($ex) {
                $pdo->prepare('UPDATE payments SET amount = ?, mode = ?, collection_id = ?, note = ? WHERE id = ?')
                    ->execute([$amount, $mode, $colVal, $note ?: null, $ex['id']]);
                log_action('payment_updated', "$empName, $perLabel: " . money($amount) . " $mode");
            } else {
                $pdo->prepare('INSERT INTO payments (employee_id, period_id, collection_id, amount, mode, note, created_by)
                               VALUES (?, ?, ?, ?, ?, ?, ?)')
                    ->execute([$empId, $perId, $colVal, $amount, $mode, $note ?: null, $uid]);
                log_action('payment_added', "$empName, $perLabel: " . money($amount) . " $mode");
            }
            json_out(['ok' => true]);

        case 'delete_payment':
            $id = (int)($in['payment_id'] ?? 0);
            $st = $pdo->prepare('SELECT p.id, p.collection_id, p.amount, e.name, pr.label
                                 FROM payments p JOIN employees e ON e.id = p.employee_id
                                 JOIN periods pr ON pr.id = p.period_id WHERE p.id = ?');
            $st->execute([$id]);
            $p = $st->fetch();
            if (!$p) {
                throw new ApiError('That payment was already removed.');
            }
            if ($p['collection_id']) {
                $c = collection_by_id((int)$p['collection_id']);
                if ($c && $c['locked']) {
                    throw new ApiError('This payment is in a remitted collection. Delete the remittance first to change it.');
                }
            }
            $pdo->prepare('DELETE FROM payments WHERE id = ?')->execute([$id]);
            log_action('payment_deleted', "{$p['name']}, {$p['label']}: " . money($p['amount']));
            json_out(['ok' => true]);

        case 'remit':
            add_remittance(
                (int)($in['collection_id'] ?? 0),
                (string)($in['remitted_on'] ?? ''),
                (float)($in['amount'] ?? 0),
                (string)($in['mode'] ?? 'cash'),
                (string)($in['reference'] ?? ''),
                (int)$uid
            );
            json_out(['ok' => true]);

        case 'release':
            add_release(
                (int)($in['collection_id'] ?? 0),
                (string)($in['released_on'] ?? ''),
                (float)($in['amount'] ?? 0),
                (string)($in['note'] ?? ''),
                (int)$uid
            );
            json_out(['ok' => true]);

        case 'set_collection_color':
            fund_must_exist($fundId);
            $id = (int)($in['collection_id'] ?? 0);
            $color = strtolower(trim((string)($in['color'] ?? '')));
            if (!preg_match('/^#[0-9a-f]{6}$/', $color)) {
                throw new ApiError('Choose a valid color.');
            }
            $c = collection_by_id($id);
            if (!$c || (int)$c['fund_id'] !== $fundId) {
                throw new ApiError('That collection does not belong to this tab.');
            }
            $pdo->prepare('UPDATE collections SET color = ? WHERE id = ?')->execute([$color, $id]);
            log_action('collection_color_changed', "Collection #$id color changed to $color");
            json_out(['ok' => true]);

        case 'delete_collection':
            $id = (int)($in['collection_id'] ?? 0);
            $c = collection_by_id($id);
            if (!$c) {
                throw new ApiError('That collection was already removed.');
            }
            if ($c['entries'] > 0 || $c['remitted'] > 0) {
                throw new ApiError('Only an empty collection can be deleted.');
            }
            $pdo->prepare('DELETE FROM collections WHERE id = ?')->execute([$id]);
            foreach (($_SESSION['active'] ?? []) as $f => $a) {
                if ((int)$a === $id) {
                    $_SESSION['active'][$f] = 0;
                }
            }
            log_action('collection_deleted', "Collection #$id on {$c['collected_on']}");
            json_out(['ok' => true]);

        case 'add_period':
            fund_must_exist($fundId);
            $label = trim((string)($in['label'] ?? ''));
            $due = trim((string)($in['due_on'] ?? ''));
            $ben = (int)($in['beneficiary_id'] ?? 0);
            if ($ben) {
                $chk = $pdo->prepare('SELECT COUNT(*) FROM employees WHERE id = ?');
                $chk->execute([$ben]);
                if (!$chk->fetchColumn()) {
                    throw new ApiError('That employee was not found.');
                }
            }
            if ($label === '' || mb_strlen($label) > 40) {
                throw new ApiError('Enter a column name of up to 40 characters.');
            }
            if ($due !== '') {
                valid_date($due, 'the due date');
            }
            $st = $pdo->prepare('SELECT COALESCE(MAX(sort_no), 0) + 1 FROM periods WHERE fund_id = ?');
            $st->execute([$fundId]);
            $sort = (int)$st->fetchColumn();
            try {
                $pdo->prepare('INSERT INTO periods (fund_id, label, due_on, beneficiary_id, sort_no) VALUES (?, ?, ?, ?, ?)')
                    ->execute([$fundId, $label, $due ?: null, $ben ?: null, $sort]);
            } catch (PDOException $e) {
                if ((int)$e->errorInfo[1] === 1062) {
                    throw new ApiError("A column named \"$label\" already exists in this tab.");
                }
                throw $e;
            }
            log_action('column_added', "$label (tab $fundId)");
            json_out(['ok' => true]);

        case 'edit_period':
            fund_must_exist($fundId);
            $pid = (int)($in['period_id'] ?? 0);
            $label = trim((string)($in['label'] ?? ''));
            $due = trim((string)($in['due_on'] ?? ''));
            $ben = (int)($in['beneficiary_id'] ?? 0);
            if ($label === '' || mb_strlen($label) > 40) {
                throw new ApiError('Enter a column name of up to 40 characters.');
            }
            if ($due !== '') {
                valid_date($due, 'the due date');
            }
            $chk = $pdo->prepare('SELECT COUNT(*) FROM periods WHERE id = ? AND fund_id = ?');
            $chk->execute([$pid, $fundId]);
            if (!$chk->fetchColumn()) {
                throw new ApiError('That column was not found.');
            }
            if ($ben) {
                $chk = $pdo->prepare('SELECT COUNT(*) FROM employees WHERE id = ?');
                $chk->execute([$ben]);
                if (!$chk->fetchColumn()) {
                    throw new ApiError('That employee was not found.');
                }
            }
            try {
                $pdo->prepare('UPDATE periods SET label = ?, due_on = ?, beneficiary_id = ? WHERE id = ?')
                    ->execute([$label, $due ?: null, $ben ?: null, $pid]);
            } catch (PDOException $e) {
                if ((int)$e->errorInfo[1] === 1062) {
                    throw new ApiError("A column named \"$label\" already exists in this tab.");
                }
                throw $e;
            }
            log_action('column_edited', "$label (tab $fundId)");
            json_out(['ok' => true]);

        case 'new_year':
            if (!is_admin()) {
                throw new ApiError('Only an admin can start a new year.');
            }
            $year = (int)($in['year'] ?? 0);
            $monthly = round((float)($in['monthly_amount'] ?? 0), 2);
            $mand = round((float)($in['mandatory_amount'] ?? 0), 2);
            if ($year < 2000 || $year > 2100) {
                throw new ApiError('Enter a year between 2000 and 2100.');
            }
            if ($monthly <= 0 || $mand <= 0) {
                throw new ApiError('Enter an amount greater than zero for both tabs.');
            }
            $names = [(string)$year, $year . ' Mandatory'];
            $chk = $pdo->prepare('SELECT COUNT(*) FROM funds WHERE name IN (?, ?)');
            $chk->execute($names);
            if ($chk->fetchColumn()) {
                throw new ApiError("The tabs for $year already exist.");
            }
            $repeatOk = true;
            try {
                ensure_tab_columns();
            } catch (ApiError $e) {
                $repeatOk = false;
            }
            $pdo->beginTransaction();
            try {
                $sort = (int)$pdo->query('SELECT COALESCE(MAX(sort_no), 0) FROM funds')->fetchColumn();
                $ins = $pdo->prepare('INSERT INTO funds (name, default_amount, sort_no) VALUES (?, ?, ?)');
                $ins->execute([$names[0], $monthly, $sort + 1]);
                $newFund = (int)$pdo->lastInsertId();
                $ins->execute([$names[1], $mand, $sort + 2]);
                $pi = $pdo->prepare('INSERT INTO periods (fund_id, label, due_on, sort_no) VALUES (?, ?, ?, ?)');
                foreach (['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] as $i => $m) {
                    $pi->execute([$newFund, $m, sprintf('%04d-%02d-01', $year, $i + 1), $i + 1]);
                }
                if ($repeatOk) {
                    copy_yearly_tabs($year, $sort + 2);
                }
                $pdo->commit();
            } catch (Throwable $e) {
                $pdo->rollBack();
                throw $e;
            }
            log_action('new_year', "Created the tabs for $year");
            json_out(['ok' => true, 'fund_id' => $newFund]);

        case 'add_tab':
            if (!is_admin()) {
                throw new ApiError('Only an admin can add a tab.');
            }
            ensure_tab_columns();
            $label = trim((string)preg_replace('/\s+/', ' ', (string)($in['label'] ?? '')));
            $year = (int)($in['year'] ?? 0);
            $amount = round((float)($in['amount'] ?? 0), 2);
            $kind = ($in['columns'] ?? 'none') === 'months' ? 'months' : 'cases';
            $repeat = !empty($in['repeat']) ? 1 : 0;
            if ($label === '' || mb_strlen($label) > 50) {
                throw new ApiError('Enter a tab name of up to 50 characters.');
            }
            if ($year !== 0 && ($year < 2000 || $year > 2100)) {
                throw new ApiError('Enter a year between 2000 and 2100, or leave it empty.');
            }
            if ($amount <= 0) {
                throw new ApiError('Enter an amount greater than zero.');
            }
            if ($kind === 'months' && !$year) {
                throw new ApiError('Jan to Dec columns need a year.');
            }
            if ($repeat && !$year) {
                throw new ApiError('A tab that repeats every year needs a year.');
            }
            $name = $year ? $year . ' ' . $label : $label;
            $chk = $pdo->prepare('SELECT COUNT(*) FROM funds WHERE name = ?');
            $chk->execute([$name]);
            if ($chk->fetchColumn()) {
                throw new ApiError("A tab named \"$name\" already exists.");
            }
            $pdo->beginTransaction();
            try {
                $sort = (int)$pdo->query('SELECT COALESCE(MAX(sort_no), 0) FROM funds')->fetchColumn();
                $pdo->prepare('INSERT INTO funds (name, label, year, kind, repeat_yearly, default_amount, sort_no) VALUES (?, ?, ?, ?, ?, ?, ?)')
                    ->execute([$name, $label, $year ?: null, $kind, $repeat, $amount, $sort + 1]);
                $newFund = (int)$pdo->lastInsertId();
                if ($kind === 'months') {
                    $pi = $pdo->prepare('INSERT INTO periods (fund_id, label, due_on, sort_no) VALUES (?, ?, ?, ?)');
                    foreach (MONTH_LABELS as $i => $m) {
                        $pi->execute([$newFund, $m, sprintf('%04d-%02d-01', $year, $i + 1), $i + 1]);
                    }
                }
                $pdo->commit();
            } catch (Throwable $e) {
                $pdo->rollBack();
                throw $e;
            }
            log_action('tab_added', $name . ($repeat ? ' (repeats every year)' : ''));
            json_out(['ok' => true, 'fund_id' => $newFund]);

        case 'add_employee':
            $name = trim(preg_replace('/\s+/', ' ', (string)($in['name'] ?? '')));
            $division = strtoupper(trim((string)($in['division'] ?? '')));
            $status = (string)($in['status'] ?? 'enrolled');
            $start = trim((string)($in['start_on'] ?? ''));
            if ($start !== '') {
                valid_date($start, 'the start date');
            }
            if ($name === '' || mb_strlen($name) > 120) {
                throw new ApiError('Enter the employee name, like "Dela Cruz, Juan A."');
            }
            if (!in_array($status, ['enrolled', 'not_enrolled', 'scholarship', 'transferred'], true)) {
                throw new ApiError('Choose a status.');
            }
            $st = $pdo->prepare('SELECT COUNT(*) FROM employees WHERE LOWER(name) = LOWER(?)');
            $st->execute([$name]);
            if ($st->fetchColumn()) {
                throw new ApiError("$name is already in the list.");
            }
            $pdo->prepare('INSERT INTO employees (name, division, status, start_on) VALUES (?, ?, ?, ?)')
                ->execute([$name, $division, $status, $start ?: null]);
            log_action('employee_added', $name);
            json_out(['ok' => true]);

        default:
            throw new ApiError('Unknown action.');
    }
} catch (ApiError $e) {
    json_out(['error' => $e->getMessage()], 422);
} catch (Throwable $e) {
    error_log('EAP tracker: ' . $e);
    json_out(['error' => cfg('debug') ? $e->getMessage() : 'Something went wrong on the server. Try again.'], 500);
}
