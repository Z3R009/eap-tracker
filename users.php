<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';
require_admin();

$pdo = db();
$error = '';
$me = (int)current_user()['id'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  check_csrf();
  $do = (string)($_POST['do'] ?? '');
  try {
    if ($do === 'add') {
      $u = trim((string)$_POST['username']);
      $full = trim((string)$_POST['full_name']);
      $role = $_POST['role'] === 'admin' ? 'admin' : 'staff';
      if ($u === '' || $full === '') {
        throw new RuntimeException('Enter a username and a full name.');
      }
      if (strlen((string)$_POST['password']) < 8) {
        throw new RuntimeException('Use a password of at least 8 characters.');
      }
      try {
        $pdo->prepare('INSERT INTO users (username, full_name, password_hash, role) VALUES (?,?,?,?)')
          ->execute([$u, $full, password_hash((string)$_POST['password'], PASSWORD_DEFAULT), $role]);
      } catch (PDOException $e) {
        throw new RuntimeException("The username \"$u\" is already taken.");
      }
      log_action('user_added', "$u ($role)");
      $_SESSION['flash'] = "Added $full.";
    } elseif ($do === 'password') {
      if (strlen((string)$_POST['password']) < 8) {
        throw new RuntimeException('Use a password of at least 8 characters.');
      }
      $pdo->prepare('UPDATE users SET password_hash = ? WHERE id = ?')
        ->execute([password_hash((string)$_POST['password'], PASSWORD_DEFAULT), (int)$_POST['id']]);
      log_action('password_reset', 'user #' . (int)$_POST['id']);
      $_SESSION['flash'] = 'Password changed.';
    } elseif ($do === 'role') {
      $id = (int)$_POST['id'];
      $role = (string)($_POST['role'] ?? '');

      if (!in_array($role, ['staff', 'admin'], true)) {
        throw new RuntimeException('Invalid role.');
      }

      if ($id === $me && $role !== 'admin') {
        throw new RuntimeException('You cannot remove your own admin role.');
      }

      $pdo->prepare('UPDATE users SET role = ? WHERE id = ?')
        ->execute([$role, $id]);

      log_action('user_role_updated', "user #$id ($role)");
      $_SESSION['flash'] = 'User role updated.';
    } elseif ($do === 'toggle') {
      $id = (int)$_POST['id'];
      if ($id === $me) {
        throw new RuntimeException('You cannot deactivate your own account.');
      }
      $pdo->prepare('UPDATE users SET active = 1 - active WHERE id = ?')->execute([$id]);
      log_action('user_toggled', 'user #' . $id);
    }
    redirect('users.php');
  } catch (RuntimeException $e) {
    $error = $e->getMessage();
  }
}

$users = $pdo->query('SELECT id, username, full_name, role, active, created_at FROM users ORDER BY active DESC, full_name')->fetchAll();
$flash = $_SESSION['flash'] ?? '';
unset($_SESSION['flash']);

page_header('Users', 'users');
?>
<main class="page">
  <h1>Users</h1>
  <p class="muted">Staff can record payments, collect, remit and add employees. Admins can also manage users, delete remittances and see the history.</p>
  <?php if ($flash): ?><p class="ok-msg"><?= h($flash) ?></p><?php endif; ?>
  <?php if ($error): ?><p class="err" role="alert"><?= h($error) ?></p><?php endif; ?>

  <form method="post" class="formrow">
    <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
    <input type="hidden" name="do" value="add">
    <label>Full name <input name="full_name" required></label>
    <label>Username <input name="username" required autocomplete="off"></label>
    <label>Password <input type="password" name="password" required minlength="8" autocomplete="new-password"></label>
    <label>Role <select name="role">
        <option value="staff">Staff</option>
        <option value="admin">Admin</option>
      </select></label>
    <button class="primary">Add user</button>
  </form>

  <table class="list">
    <tr>
      <th>Name</th>
      <th>Username</th>
      <th>Role</th>
      <th>Status</th>
      <th>New password</th>
      <th></th>
    </tr>
    <?php foreach ($users as $u): ?>
      <tr<?= $u['active'] ? '' : ' style="opacity:.55"' ?>>
        <td><?= h($u['full_name']) ?></td>
        <td><?= h($u['username']) ?></td>
        <td>
          <form method="post" style="display:flex;gap:6px;align-items:center">
            <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
            <input type="hidden" name="do" value="role">
            <input type="hidden" name="id" value="<?= (int)$u['id'] ?>">

            <select name="role">
              <option value="staff" <?= $u['role'] === 'staff' ? 'selected' : '' ?>>Staff</option>
              <option value="admin" <?= $u['role'] === 'admin' ? 'selected' : '' ?>>Admin</option>
            </select>

            <button type="submit">Update</button>
          </form>
        </td>
        <td><?= $u['active'] ? 'Active' : 'Deactivated' ?></td>
        <td>
          <form method="post" style="display:flex;gap:6px">
            <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
            <input type="hidden" name="do" value="password"><input type="hidden" name="id" value="<?= (int)$u['id'] ?>">
            <input type="password" name="password" minlength="8" placeholder="8+ characters" autocomplete="new-password" style="width:150px">
            <button>Change</button>
          </form>
        </td>
        <td>
          <?php if ((int)$u['id'] !== $me): ?>
            <form method="post">
              <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
              <input type="hidden" name="do" value="toggle"><input type="hidden" name="id" value="<?= (int)$u['id'] ?>">
              <button class="link"><?= $u['active'] ? 'Deactivate' : 'Reactivate' ?></button>
            </form>
          <?php endif; ?>
        </td>
        </tr>
      <?php endforeach; ?>
  </table>
</main>
<?php page_footer();
