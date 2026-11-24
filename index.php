<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require __DIR__ . '/inc/ledger.php';
if (!current_user()) {
  redirect(cfg('public_view') === false ? 'login.php' : 'view.php');
}

$funds = funds_list();
if (!$funds) {
  page_header('Ledger', 'ledger');
  echo '<main class="page"><p>No tabs yet. Import schema.sql to create them.</p></main>';
  page_footer();
  exit;
}
$fundId = (int)($_GET['fund'] ?? $funds[0]['id']);
if (!in_array($fundId, array_map('intval', array_column($funds, 'id')), true)) {
  $fundId = (int)$funds[0]['id'];
}
$nextYear = (int)date('Y');
$latest = 0;
$amounts = [];
foreach ($funds as $f) {
  if (preg_match('/^(\d{4})( Mandatory)?$/', $f['name'], $m)) {
    $latest = max($latest, (int)$m[1]);
    $amounts[$f['name']] = (float)$f['default_amount'];
  }
}
if ($latest) {
  $nextYear = $latest + 1;
}
$monthlyAmt = $amounts[(string)$latest] ?? 50;
$mandatoryAmt = $amounts[$latest . ' Mandatory'] ?? 100;
$divisions = db()->query("SELECT DISTINCT division FROM employees WHERE division <> '' ORDER BY division")->fetchAll(PDO::FETCH_COLUMN);

page_header('Ledger', 'ledger');
?>
<main class="page wide">
  <nav class="tabs" role="tablist" aria-label="Ledger tabs">
    <?php foreach ($funds as $f): ?>
      <a role="tab" class="tab" href="index.php?fund=<?= (int)$f['id'] ?>"
        <?= (int)$f['id'] === $fundId ? 'aria-selected="true"' : '' ?>><?= h($f['name']) ?></a>
    <?php endforeach; ?>
  </nav>

  <section class="summary" id="summary" aria-live="polite"></section>

  <section class="toolbar">
    <button class="primary" id="btnToday">Collect today</button>
    <label class="inline">Collection
      <span class="swatch" id="activeSwatch"></span>
      <select id="activeCol"></select>
      <small class="muted" id="activeHint"></small>
    </label>
    <label class="inline"><input type="checkbox" id="quick"> Tap a cell to pay the usual amount</label>
    <span class="spacer"></span>
    <input type="search" id="search" placeholder="Find an employee" aria-label="Find an employee">

    <?php if (is_admin()): ?>
      <button id="btnAddEmp">Add employee</button>
      <button id="btnAddPeriod">Add column</button>
      <button id="btnNewYear">New year</button>
      <button id="btnAddTab">Add tab</button>
    <?php endif; ?>
  </section>

  <div class="gridwrap">
    <table class="grid" id="grid" aria-label="Payments"></table>
  </div>
  <p class="hint" id="hint"></p>

  <section>
    <h2>Collections</h2>
    <div id="legend" class="legend"></div>
  </section>
</main>

<dialog id="payDlg">
  <form id="payForm" class="stack">
    <h3 id="payTitle"></h3>
    <p class="muted" id="payMeta"></p>
    <label id="amtRow">Amount <input type="number" name="amount" step="0.01" min="0" inputmode="decimal"></label>
    <label>Paid by
      <select name="mode">
        <option value="cash">Cash</option>
        <option value="fund_transfer">Fund transfer</option>
        <option value="direct">Paid directly to the recipient</option>
        <option value="care_of">Paid care of another office</option>
        <option value="exempt">Exempt, does not have to pay</option>
      </select>
    </label>
    <label id="colRow">Collection <select name="collection_id"></select></label>
    <label id="newDateRow" hidden>Collection date <input type="date" name="new_date"></label>
    <label>Note <input name="note" maxlength="255" placeholder="Optional"></label>
    <p class="err" id="payErr" role="alert"></p>
    <div class="actions">
      <button type="button" class="danger" id="payDelete">Delete payment</button>
      <span class="spacer"></span>
      <button type="button" data-close>Cancel</button>
      <button class="primary" id="paySave">Save payment</button>
    </div>
  </form>
</dialog>

<dialog id="remitDlg">
  <form id="remitForm" class="stack">
    <h3 id="remitTitle">Remit collection</h3>
    <p class="muted" id="remitMeta"></p>
    <label>Date remitted <input type="date" name="remitted_on" required></label>
    <label>Amount <input type="number" name="amount" step="0.01" min="0.01" required inputmode="decimal"></label>
    <label>How
      <select name="mode">
        <option value="cash">Cash</option>
        <option value="fund_transfer">Fund transfer</option>
        <option value="care_of">Care of another office</option>
      </select>
    </label>
    <label>Reference <input name="reference" maxlength="100" placeholder="Receipt or transfer number (optional)"></label>
    <p class="err" id="remitErr" role="alert"></p>
    <div class="actions"><span class="spacer"></span><button type="button" data-close>Cancel</button><button class="primary">Save remittance</button></div>
  </form>
</dialog>


<dialog id="releaseDlg">
  <form id="releaseForm" class="stack">
    <h3 id="releaseTitle">Release collection</h3>
    <p class="muted" id="releaseMeta"></p>
    <ul class="bycol" id="releaseBreak"></ul>
    <label>Date released <input type="date" name="released_on" required></label>
    <label>Amount <input type="number" name="amount" step="0.01" min="0.01" required inputmode="decimal"></label>
    <label>Note <input name="note" maxlength="255" placeholder="Optional"></label>
    <p class="err" id="releaseErr" role="alert"></p>
    <div class="actions"><span class="spacer"></span><button type="button" data-close>Cancel</button><button class="primary">Save release</button></div>
  </form>
</dialog>

<dialog id="periodDlg">
  <form id="periodForm" class="stack">
    <h3 id="periodTitle">Add a column</h3>
    <p class="muted">A month, or a case such as a name that everyone contributes to.</p>
    <label>Column name <input name="label" maxlength="40" required placeholder="Dec or Hautea"></label>
    <label>Due date <input type="date" name="due_on"></label>
    <p class="hint">Employees who started after this month do not owe it. Leave it empty if everyone owes it right away.</p>
    <label>This column is for <select name="beneficiary_id"></select></label>
    <p class="hint">The person it is for is not asked to pay it.</p>
    <p class="err" id="periodErr" role="alert"></p>
    <div class="actions"><span class="spacer"></span><button type="button" data-close>Cancel</button><button class="primary" id="periodSave">Add column</button></div>
  </form>
</dialog>

<dialog id="empDlg">
  <form id="empForm" class="stack">
    <h3>Add an employee</h3>
    <label>Name <input name="name" required maxlength="120" placeholder="Dela Cruz, Juan A."></label>
    <label>Division <input name="division" list="divList" maxlength="30" placeholder="MSSD"></label>
    <label>Started on <input type="date" name="start_on"></label>
    <datalist id="divList"><?php foreach ($divisions as $d): ?><option value="<?= h($d) ?>"><?php endforeach; ?></datalist>
    <label>Status
      <select name="status">
        <option value="enrolled">Enrolled</option>
        <option value="not_enrolled">Not enrolled</option>
        <option value="scholarship">On scholarship program</option>
        <option value="transferred">Transferred</option>
      </select>
    </label>
    <p class="err" id="empErr" role="alert"></p>
    <div class="actions"><span class="spacer"></span><button type="button" data-close>Cancel</button><button class="primary">Add employee</button></div>
  </form>
</dialog>

<?php if (is_admin()): ?>
  <dialog id="yearDlg">
    <form id="yearForm" class="stack">
      <h3>Start a new year</h3>
      <p class="muted">Creates two tabs: the monthly tab with Jan to Dec, and a Mandatory tab with no columns yet. Your employee list is shared, and the old tabs stay as they are.</p>
      <label>Year <input type="number" name="year" min="2000" max="2100" value="<?= $nextYear ?>" required></label>
      <label>Monthly amount per person <input type="number" name="monthly_amount" step="0.01" min="0.01" value="<?= h($monthlyAmt) ?>" required></label>
      <label>Usual Mandatory amount per person <input type="number" name="mandatory_amount" step="0.01" min="0.01" value="<?= h($mandatoryAmt) ?>" required></label>
      <p class="err" id="yearErr" role="alert"></p>
      <div class="actions"><span class="spacer"></span><button type="button" data-close>Cancel</button><button class="primary">Create tabs</button></div>
    </form>
  </dialog>

  <dialog id="tabDlg">
    <form id="tabForm" class="stack">
      <h3>Add a tab</h3>
      <p class="muted">A new page in the ledger, such as a fund or a one-time collection. Your employee list is shared.</p>
      <label>Tab name <input name="label" maxlength="50" required placeholder="Christmas fund"></label>
      <label>Year <input type="number" name="year" min="2000" max="2100" placeholder="Optional"></label>
      <p class="hint" id="tabPreview"></p>
      <label>Usual amount per person <input type="number" name="amount" step="0.01" min="0.01" required></label>
      <label>Columns
        <select name="columns">
          <option value="none">None yet, I will add them as needed</option>
          <option value="months">Jan to Dec of the year above</option>
        </select>
      </label>
      <label style="flex-direction:row;align-items:center;gap:8px"><input type="checkbox" name="repeat"> Add this tab again every year when I press New year</label>
      <p class="hint">Repeating and Jan to Dec both need a year. The next year's copy keeps the same name, amount and column type.</p>
      <p class="err" id="tabErr" role="alert"></p>
      <div class="actions"><span class="spacer"></span><button type="button" data-close>Cancel</button><button class="primary">Create tab</button></div>
    </form>
  </dialog>
<?php endif; ?>

<div id="toast" role="status" aria-live="polite"></div>
<script>
  window.EAP = {
    fund: <?= $fundId ?>,
    csrf: <?= json_encode(csrf_token()) ?>
  };
</script>
<script src="assets/app.js"></script>
<?php page_footer();
