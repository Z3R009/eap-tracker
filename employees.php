<?php
declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require __DIR__ . '/inc/ledger.php';
require_login();

$pdo = db();
$error = '';
$statuses = ['enrolled' => 'Enrolled', 'not_enrolled' => 'Not enrolled', 'scholarship' => 'On scholarship program', 'transferred' => 'Transferred'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    check_csrf();
    $id = (int)($_POST['id'] ?? 0);
    $name = trim((string)preg_replace('/\s+/', ' ', (string)($_POST['name'] ?? '')));
    $division = strtoupper(trim((string)($_POST['division'] ?? '')));
    $status = (string)($_POST['status'] ?? 'enrolled');
    $start = trim((string)($_POST['start_on'] ?? ''));
    $remarks = trim((string)($_POST['remarks'] ?? ''));
    $active = isset($_POST['active']) ? 1 : 0;
    try {
        if ($name === '') {
            throw new ApiError('Enter the employee name.');
        }
        if (!isset($statuses[$status])) {
            throw new ApiError('Choose a status.');
        }
        if ($start !== '') {
            valid_date($start, 'the start date');
        }
        $st = $pdo->prepare('SELECT COUNT(*) FROM employees WHERE LOWER(name) = LOWER(?) AND id <> ?');
        $st->execute([$name, $id]);
        if ($st->fetchColumn()) {
            throw new ApiError("$name is already in the list.");
        }
        if ($id) {
            $pdo->prepare('UPDATE employees SET name=?, division=?, status=?, start_on=?, remarks=?, active=? WHERE id=?')
                ->execute([$name, $division, $status, $start ?: null, $remarks ?: null, $active, $id]);
            log_action('employee_updated', $name);
        } else {
            $pdo->prepare('INSERT INTO employees (name, division, status, start_on, remarks, active) VALUES (?,?,?,?,?,?)')
                ->execute([$name, $division, $status, $start ?: null, $remarks ?: null, 1]);
            log_action('employee_added', $name);
        }
        $_SESSION['flash'] = 'Saved ' . $name . '.';
        redirect('employees.php');
    } catch (ApiError $e) {
        $error = $e->getMessage();
    }
}

$editing = null;
if (isset($_GET['edit'])) {
    $st = $pdo->prepare('SELECT * FROM employees WHERE id = ?');
    $st->execute([(int)$_GET['edit']]);
    $editing = $st->fetch() ?: null;
}
$showAll = isset($_GET['all']);
$list = sorted_employees($showAll ? '1=1' : 'active = 1');
$divisions = $pdo->query("SELECT DISTINCT division FROM employees WHERE division <> '' ORDER BY division")->fetchAll(PDO::FETCH_COLUMN);
$flash = $_SESSION['flash'] ?? '';
unset($_SESSION['flash']);

page_header('Employees', 'employees');
?>
<main class="page">
  <div class="pagehead">
    <h1>Employees</h1>
    <span class="muted"><?= count($list) ?> shown. The same list is used in every ledger tab.</span>
    <span class="spacer"></span>
    <a href="employees.php?<?= $showAll ? '' : 'all=1' ?>"><?= $showAll ? 'Hide inactive' : 'Show inactive too' ?></a>
  </div>
  <?php if ($flash): ?><p class="ok-msg"><?= h($flash) ?></p><?php endif; ?>
  <?php if ($error): ?><p class="err" role="alert"><?= h($error) ?></p><?php endif; ?>

  <form method="post" class="formrow">
    <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
    <input type="hidden" name="id" value="<?= (int)($editing['id'] ?? 0) ?>">
    <label style="flex:2;min-width:220px"><?= $editing ? 'Edit name' : 'New employee' ?>
      <input name="name" required maxlength="120" value="<?= h($editing['name'] ?? '') ?>" placeholder="Dela Cruz, Juan A.">
    </label>
    <label>Division <input name="division" list="divs" maxlength="30" value="<?= h($editing['division'] ?? '') ?>" style="width:120px"></label>
    <datalist id="divs"><?php foreach ($divisions as $d): ?><option value="<?= h($d) ?>"><?php endforeach; ?></datalist>
    <label>Status
      <select name="status"><?php foreach ($statuses as $k => $v): ?><option value="<?= $k ?>" <?= ($editing['status'] ?? 'enrolled') === $k ? 'selected' : '' ?>><?= h($v) ?></option><?php endforeach; ?></select>
    </label>
    <label>Started on <input type="date" name="start_on" value="<?= h($editing['start_on'] ?? '') ?>"></label>
    <label style="flex:1;min-width:160px">Remarks <input name="remarks" maxlength="255" value="<?= h($editing['remarks'] ?? '') ?>" placeholder="Optional"></label>
    <?php if ($editing): ?>
      <label style="flex-direction:row;align-items:center;gap:6px"><input type="checkbox" name="active" <?= $editing['active'] ? 'checked' : '' ?>> Active</label>
    <?php endif; ?>
    <button class="primary"><?= $editing ? 'Save changes' : 'Add employee' ?></button>
    <?php if ($editing): ?><a href="employees.php">Cancel</a><?php endif; ?>
  </form>

  <table class="list">
    <tr><th>Name</th><th>Division</th><th>Status</th><th>Started</th><th>Remarks</th><th></th></tr>
    <?php foreach ($list as $e): ?>
      <tr<?= $e['active'] ? '' : ' style="opacity:.55"' ?>>
        <td><?= h($e['name']) ?></td><td><?= h($e['division']) ?></td>
        <td><?= h($statuses[$e['status']] ?? $e['status']) ?></td>
        <td><?= h(fmt_date($e['start_on'])) ?></td><td><?= h($e['remarks']) ?></td>
        <td><a href="employees.php?edit=<?= (int)$e['id'] ?>">Edit</a></td>
      </tr>
    <?php endforeach; ?>
  </table>
</main>
<?php page_footer();
