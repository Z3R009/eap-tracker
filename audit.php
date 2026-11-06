<?php
declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require_admin();

$rows = db()->query(
    'SELECT a.created_at, a.action, a.detail, u.full_name FROM audit_log a
     LEFT JOIN users u ON u.id = a.user_id ORDER BY a.id DESC LIMIT 300'
)->fetchAll();

page_header('History', 'audit');
?>
<main class="page">
  <h1>History</h1>
  <p class="muted">The latest 300 actions: who recorded, changed or remitted what, and when.</p>
  <table class="list">
    <tr><th>When</th><th>Who</th><th>What</th><th>Details</th></tr>
    <?php foreach ($rows as $r): ?>
      <tr>
        <td style="white-space:nowrap"><?= h(date('M j, Y g:i a', strtotime($r['created_at']))) ?></td>
        <td><?= h($r['full_name']) ?></td>
        <td><?= h(str_replace('_', ' ', $r['action'])) ?></td>
        <td><?= h($r['detail']) ?></td>
      </tr>
    <?php endforeach; ?>
    <?php if (!$rows): ?><tr><td colspan="4" class="muted">Nothing recorded yet.</td></tr><?php endif; ?>
  </table>
</main>
<?php page_footer();
