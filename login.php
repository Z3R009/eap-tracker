<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';

$pdo = db();
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['logout'])) {
    check_csrf();
    session_destroy();
    redirect(cfg('public_view') === false ? 'login.php' : 'view.php');
}

$userCount = (int)$pdo->query('SELECT COUNT(*) FROM users')->fetchColumn();
$firstRun = $userCount === 0;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    check_csrf();
    $username = trim((string)($_POST['username'] ?? ''));
    $password = (string)($_POST['password'] ?? '');

    if ($firstRun) {
        $full = trim((string)($_POST['full_name'] ?? ''));
        if ($username === '' || $full === '') {
            $error = 'Enter your name and a username.';
        } elseif (strlen($password) < 8) {
            $error = 'Use a password of at least 8 characters.';
        } else {
            $pdo->prepare('INSERT INTO users (username, full_name, password_hash, role) VALUES (?, ?, ?, "admin")')
                ->execute([$username, $full, password_hash($password, PASSWORD_DEFAULT)]);
            $firstRun = false;
        }
    }
    if (!$firstRun && $error === '') {
        $st = $pdo->prepare('SELECT id, username, full_name, password_hash, role FROM users WHERE username = ? AND active = 1');
        $st->execute([$username]);
        $u = $st->fetch();
        if ($u && password_verify($password, $u['password_hash'])) {
            session_regenerate_id(true);
            $_SESSION['user'] = ['id' => (int)$u['id'], 'username' => $u['username'], 'full_name' => $u['full_name'], 'role' => $u['role']];
            log_action('login', $u['username']);
            redirect('index.php');
        }
        $error = 'That username or password is not right.';
    }
}

page_header($firstRun ? 'Create admin account' : 'Sign in');
?>
<main class="login">
    <h1><?= $firstRun ? 'Create the admin account' : 'Sign in' ?></h1>
    <?php if ($firstRun): ?>
        <p class="muted">This is the first time the system is opened. The account you create here can add other users later.</p>
    <?php endif; ?>
    <?php if ($error): ?><p class="err" role="alert"><?= h($error) ?></p><?php endif; ?>
    <form method="post" class="stack">
        <input type="hidden" name="csrf" value="<?= h(csrf_token()) ?>">
        <?php if ($firstRun): ?>
            <label>Your full name <input name="full_name" required autocomplete="name"></label>
        <?php endif; ?>
        <label>Username <input name="username" required autocomplete="username" autofocus></label>
        <label>Password <input type="password" name="password" required autocomplete="<?= $firstRun ? 'new-password' : 'current-password' ?>"></label>
        <button class="primary"><?= $firstRun ? 'Create account and sign in' : 'Sign in' ?></button>
    </form>
    <?php if (cfg('public_view') !== false): ?>
        <p class="muted" style="margin-top:18px"><a href="view.php">Back to the public records page</a></p>
    <?php endif; ?>
</main>
<?php page_footer();
