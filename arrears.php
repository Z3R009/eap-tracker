<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require __DIR__ . '/inc/ledger.php';
require_login();

$pdo = db();
$funds = funds_list();
$fundId = (int)($_GET['fund'] ?? ($funds[0]['id'] ?? 0));
$fund = null;
foreach ($funds as $f) {
  if ((int)$f['id'] === $fundId) {
    $fund = $f;
  }
}
if (!$fund && $funds) {
  $fund = $funds[0];
  $fundId = (int)$fund['id'];
}
$today = date('Y-m-d');

$rows = [];
$total = 0.0;
if ($fund) {
  $st = $pdo->prepare('SELECT id, label, due_on, beneficiary_id FROM periods WHERE fund_id = ? AND (due_on IS NULL OR due_on <= ?) ORDER BY sort_no, id');
  $st->execute([$fundId, $today]);
  $periods = $st->fetchAll();
  $st = $pdo->prepare('SELECT p.employee_id, p.period_id FROM payments p JOIN periods pr ON pr.id = p.period_id WHERE pr.fund_id = ?');
  $st->execute([$fundId]);
  $paid = [];
  foreach ($st->fetchAll() as $p) {
    $paid[$p['employee_id'] . ':' . $p['period_id']] = true;
  }
  foreach (sorted_employees("active = 1 AND status = 'enrolled'") as $e) {
    $miss = [];
    foreach ($periods as $p) {
      if ((int)$p['beneficiary_id'] === (int)$e['id']) {
        continue;
      }
      if ($e['start_on'] && $p['due_on'] && substr($p['due_on'], 0, 7) < substr($e['start_on'], 0, 7)) {
        continue;
      }
      if (!isset($paid[$e['id'] . ':' . $p['id']])) {
        $miss[] = $p['label'];
      }
    }
    if ($miss) {
      $owed = count($miss) * (float)$fund['default_amount'];
      $rows[] = ['name' => $e['name'], 'division' => $e['division'], 'miss' => $miss, 'owed' => $owed];
      $total += $owed;
    }
  }
  usort($rows, fn($a, $b) => [count($b['miss']), $a['division'], $a['name']] <=> [count($a['miss']), $b['division'], $b['name']]);
}

page_header('Who still owes', 'arrears');
?>
<main class="page">
  <nav class="tabs noprint">
    <?php foreach ($funds as $f): ?>
      <a class="tab" href="arrears.php?fund=<?= (int)$f['id'] ?>" <?= (int)$f['id'] === $fundId ? 'aria-selected="true"' : '' ?>><?= h($f['name']) ?></a>
    <?php endforeach; ?>
  </nav>
  <div class="pagehead">
    <h1>Who still owes, <?= h($fund['name'] ?? '') ?></h1>
    <span class="spacer"></span>
    <button class="noprint" onclick="window.print()">Print list</button>
  </div>
  <p class="muted">Enrolled employees with due columns that have no payment yet, as of <?= h(fmt_date($today)) ?>. The amount uses the usual <?= h(money($fund['default_amount'] ?? 0)) ?> per column, so treat it as an estimate.</p>
  <?php if ($rows): ?>
    <div class="toolbar noprint">
      <input type="search" id="q" placeholder="Find an employee" aria-label="Find an employee" autocomplete="off">
      <span class="hint" id="count"></span>
    </div>
  <?php endif; ?>
  <table class="list" id="owe">
    <tr>
      <th>Employee</th>
      <th>Division</th>
      <th>Unpaid</th>
      <th class="r">Estimated amount</th>
    </tr>
    <?php foreach ($rows as $r): ?>
      <tr class="orow" data-name="<?= h(mb_strtolower($r['name'] . ' ' . $r['division'])) ?>" data-owed="<?= h($r['owed']) ?>">
        <td><?= h($r['name']) ?></td>
        <td><?= h($r['division']) ?></td>
        <td><?= count($r['miss']) ?>: <?= h(implode(', ', $r['miss'])) ?></td>
        <td class="r"><?= h(money($r['owed'])) ?></td>
      </tr>
    <?php endforeach; ?>
    <?php if (!$rows): ?><tr>
        <td colspan="4" class="muted">Everyone enrolled is up to date.</td>
      </tr>
    <?php else: ?>
      <tr id="nomatch" hidden>
        <td colspan="4" class="muted">No one on this list matches.</td>
      </tr>
      <tr class="tot">
        <td colspan="3"><b id="totalLabel">Total</b></td>
        <td class="r"><b id="totalCell"><?= h(money($total)) ?></b></td>
      </tr>
    <?php endif; ?>
  </table>
</main>
<?php if ($rows): ?>
  <script>
    (function() {
      var q = document.getElementById('q'),
        rows = [].slice.call(document.querySelectorAll('tr.orow'));
      var count = document.getElementById('count'),
        total = document.getElementById('totalCell');
      var label = document.getElementById('totalLabel'),
        none = document.getElementById('nomatch');
      var all = total.textContent;

      function peso(n) {
        return '\u20B1' + n.toLocaleString('en-US', {
          minimumFractionDigits: n % 1 ? 2 : 0,
          maximumFractionDigits: 2
        });
      }

      function filter() {
        var t = q.value.trim().toLowerCase(),
          shown = 0,
          sum = 0;
        rows.forEach(function(r) {
          var show = !t || r.dataset.name.indexOf(t) !== -1;
          r.hidden = !show;
          if (show) {
            shown++;
            sum += parseFloat(r.dataset.owed);
          }
        });
        count.textContent = t ? 'Showing ' + shown + ' of ' + rows.length : rows.length + ' employees';
        total.textContent = t ? peso(sum) : all;
        label.textContent = t ? 'Total of the ' + shown + ' shown' : 'Total';
        none.hidden = shown !== 0;
      }
      q.addEventListener('input', filter);
      filter();
    })();
  </script>
<?php endif; ?>
<?php page_footer();
