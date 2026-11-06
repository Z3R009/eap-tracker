<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require __DIR__ . '/inc/ledger.php';
require_login();

$pdo = db();
$id = (int)($_GET['id'] ?? 0);
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  check_csrf();
  $id = (int)($_POST['id'] ?? $id);
  try {
    $do = (string)($_POST['do'] ?? '');
    if ($do === 'remit') {
      add_remittance($id, (string)$_POST['remitted_on'], (float)$_POST['amount'], (string)$_POST['mode'], (string)$_POST['reference'], (int)current_user()['id']);
      $_SESSION['flash'] = 'Remittance saved.';
    } elseif ($do === 'delete_remit') {
      if (!is_admin()) {
        throw new ApiError('Only an admin can delete a remittance.');
      }
      $pdo->prepare('DELETE FROM remittances WHERE id = ? AND collection_id = ?')->execute([(int)$_POST['remit_id'], $id]);
      log_action('remittance_deleted', "Collection #$id, remittance #" . (int)$_POST['remit_id']);
      $_SESSION['flash'] = 'Remittance deleted. The collection is open for changes again.';
    } elseif ($do === 'note') {
      $pdo->prepare('UPDATE collections SET note = ? WHERE id = ?')->execute([trim((string)$_POST['note']) ?: null, $id]);
      $_SESSION['flash'] = 'Note saved.';
    }
    redirect('collection.php?id=' . $id);
  } catch (ApiError $e) {
    $error = $e->getMessage();
  }
}

$c = collection_by_id($id);
if (!$c) {
  http_response_code(404);
  page_header('Not found', 'ledger');
  echo '<main class="page"><h1>Collection not found</h1><p><a href="index.php">Back to the ledger</a></p></main>';
  page_footer();
  exit;
}
$fund = $pdo->query('SELECT name FROM funds WHERE id = ' . (int)$c['fund_id'])->fetchColumn();
$st = $pdo->prepare(
  'SELECT p.amount, p.mode, p.note, p.created_at, e.name, e.division, pr.label, u.full_name AS by_name
     FROM payments p JOIN employees e ON e.id = p.employee_id JOIN periods pr ON pr.id = p.period_id
     LEFT JOIN users u ON u.id = p.created_by WHERE p.collection_id = ?
     ORDER BY e.division, e.name, pr.sort_no'
);
$st->execute([$id]);
$payments = $st->fetchAll();
$st = $pdo->prepare('SELECT r.*, u.full_name AS by_name FROM remittances r LEFT JOIN users u ON u.id = r.created_by WHERE r.collection_id = ? ORDER BY r.remitted_on, r.id');
$st->execute([$id]);
$remits = $st->fetchAll();
$st = $pdo->prepare(
  'SELECT pr.label, b.name AS beneficiary, COUNT(*) AS n, SUM(p.amount) AS total
     FROM payments p JOIN periods pr ON pr.id = p.period_id LEFT JOIN employees b ON b.id = pr.beneficiary_id
     WHERE p.collection_id = ? GROUP BY pr.id, pr.label, b.name, pr.sort_no ORDER BY pr.sort_no, pr.id'
);
$st->execute([$id]);
$byColumn = $st->fetchAll();
$left = round($c['collected'] - $c['remitted'], 2);
$modeLabel = ['cash' => 'Cash', 'fund_transfer' => 'Fund transfer', 'care_of' => 'Care of another office'];
$flash = $_SESSION['flash'] ?? '';
unset($_SESSION['flash']);

page_header('Collection ' . fmt_date($c['collected_on']), 'ledger');
?>
<main class="page">
  <p class="noprint"><a href="index.php?fund=<?= (int)$c['fund_id'] ?>">Back to the ledger</a></p>
  <div class="pagehead">
    <span class="swatch on" style="--h:<?= h($c['color']) ?>"></span>
    <h1><?= h($fund) ?>, collected <?= h(fmt_date($c['collected_on'])) ?></h1>
    <span class="badge <?= h($c['status']) ?>"><?= ['open' => 'Open', 'partial' => 'Partial', 'remitted' => 'Remitted'][$c['status']] ?></span>
    <span class="spacer"></span>
    <button class="noprint" onclick="window.print()">Print slip</button>
  </div>
  <?php if ($flash): ?><p class="ok-msg"><?= h($flash) ?></p><?php endif; ?>
  <?php if ($error): ?><p class="err" role="alert"><?= h($error) ?></p><?php endif; ?>

  <div class="summary">
    <div class="card"><span>Collected (<?= (int)$c['entries'] ?> payments)</span><b><?= h(money($c['collected'])) ?></b></div>
    <div class="card"><span>Remitted</span><b><?= h(money($c['remitted'])) ?></b></div>
    <div class="card <?= $left > 0 ? 'hot' : '' ?>"><span>Still to remit</span><b><?= h(money(max($left, 0))) ?></b></div>
  </div>

  <form method="post" class="formrow noprint">
    <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
    <input type="hidden" name="id" value="<?= $id ?>">
    <input type="hidden" name="do" value="note">
    <label style="flex:1">Note for this collection
      <input name="note" maxlength="255" value="<?= h($c['note']) ?>" placeholder="For example: collected at the Friday meeting">
    </label>
    <button>Save note</button>
  </form>

  <h2>Amount to hand over, by column</h2>
  <table class="list">
    <tr>
      <th>Column</th>
      <th>For</th>
      <th class="r">Payments</th>
      <th class="r">Amount</th>
    </tr>
    <?php foreach ($byColumn as $b): ?>
      <tr>
        <td><?= h($b['label']) ?></td>
        <td><?= h($b['beneficiary']) ?></td>
        <td class="r"><?= (int)$b['n'] ?></td>
        <td class="r"><?= h(money($b['total'])) ?></td>
      </tr>
    <?php endforeach; ?>
    <?php if (!$byColumn): ?><tr>
        <td colspan="4" class="muted">No payments in this collection yet.</td>
      </tr>
    <?php else: ?><tr>
        <td colspan="3"><b>Total</b></td>
        <td class="r"><b><?= h(money($c['collected'])) ?></b></td>
      </tr><?php endif; ?>
  </table>

  <h2>Remittances</h2>
  <table class="list">
    <tr>
      <th>Date</th>
      <th class="r">Amount</th>
      <th>How</th>
      <th>Reference</th>
      <th>Recorded by</th>
      <th class="noprint"></th>
    </tr>
    <?php foreach ($remits as $r): ?>
      <tr>
        <td><?= h(fmt_date($r['remitted_on'])) ?></td>
        <td class="r"><?= h(money($r['amount'])) ?></td>
        <td><?= h($modeLabel[$r['mode']] ?? $r['mode']) ?></td>
        <td><?= h($r['reference']) ?></td>
        <td><?= h($r['by_name']) ?></td>
        <td class="noprint">
          <?php if (is_admin()): ?>
            <form method="post" onsubmit="return confirm('Delete this remittance? The collection will open for changes again.')">
              <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
              <input type="hidden" name="id" value="<?= $id ?>">
              <input type="hidden" name="do" value="delete_remit">
              <input type="hidden" name="remit_id" value="<?= (int)$r['id'] ?>">
              <button class="link">Delete</button>
            </form>
          <?php endif; ?>
        </td>
      </tr>
    <?php endforeach; ?>
    <?php if (!$remits): ?><tr>
        <td colspan="6" class="muted">Nothing remitted yet.</td>
      </tr><?php endif; ?>
  </table>

  <?php if ($left > 0): ?>
    <form method="post" class="formrow noprint" style="margin-top:12px">
      <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
      <input type="hidden" name="id" value="<?= $id ?>">
      <input type="hidden" name="do" value="remit">
      <label>Date remitted <input type="date" name="remitted_on" value="<?= date('Y-m-d') ?>" required></label>
      <label>Amount <input type="number" name="amount" step="0.01" min="0.01" max="<?= h($left) ?>" value="<?= h($left) ?>" required></label>
      <label>How
        <select name="mode">
          <option value="cash">Cash</option>
          <option value="fund_transfer">Fund transfer</option>
          <option value="care_of">Care of another office</option>
        </select>
      </label>
      <label>Reference <input name="reference" maxlength="100" placeholder="Optional"></label>
      <button class="primary">Save remittance</button>
    </form>
  <?php endif; ?>

  <h2>Payments in this collection</h2>
  <table class="list">
    <tr>
      <th>Employee</th>
      <th>Division</th>
      <th>For</th>
      <th class="r">Amount</th>
      <th>How</th>
      <th>Note</th>
      <th>Recorded by</th>
    </tr>
    <?php foreach ($payments as $p): ?>
      <tr>
        <td><?= h($p['name']) ?></td>
        <td><?= h($p['division']) ?></td>
        <td><?= h($p['label']) ?></td>
        <td class="r"><?= h(money($p['amount'])) ?></td>
        <td><?= $p['mode'] === 'fund_transfer' ? 'Fund transfer' : 'Cash' ?></td>
        <td><?= h($p['note']) ?></td>
        <td><?= h($p['by_name']) ?></td>
      </tr>
    <?php endforeach; ?>
    <?php if (!$payments): ?><tr>
        <td colspan="7" class="muted">No payments recorded in this collection.</td>
      </tr><?php endif; ?>
  </table>
</main>
<?php page_footer();
