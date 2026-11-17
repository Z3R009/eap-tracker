<?php

declare(strict_types=1);

$GLOBALS['cfg'] = require __DIR__ . '/../config.php';
date_default_timezone_set($GLOBALS['cfg']['timezone']);

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_name('eap_tracker');
    session_set_cookie_params(['httponly' => true, 'samesite' => 'Lax']);
    session_start();
}

function cfg(string $key)
{
    return $GLOBALS['cfg'][$key] ?? null;
}

function db(): PDO
{
    static $pdo = null;
    if ($pdo) {
        return $pdo;
    }
    $c = $GLOBALS['cfg'];
    $dsn = "mysql:host={$c['db_host']};port={$c['db_port']};dbname={$c['db_name']};charset=utf8mb4";
    $pdo = new PDO($dsn, $c['db_user'], $c['db_pass'], [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ]);
    return $pdo;
}

function h($v): string
{
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}

function csrf_token(): string
{
    if (empty($_SESSION['csrf'])) {
        $_SESSION['csrf'] = bin2hex(random_bytes(16));
    }
    return $_SESSION['csrf'];
}

function check_csrf(bool $json = false): void
{
    $sent = $_SERVER['HTTP_X_CSRF'] ?? ($_POST['csrf'] ?? '');
    if (!hash_equals(csrf_token(), (string)$sent)) {
        http_response_code(419);
        if ($json) {
            header('Content-Type: application/json');
            echo json_encode(['error' => 'Your page is out of date. Reload it and try again.']);
        } else {
            echo 'Your page is out of date. Go back, reload it, and try again.';
        }
        exit;
    }
}

function current_user(): ?array
{
    return $_SESSION['user'] ?? null;
}

function is_admin(): bool
{
    return (current_user()['role'] ?? '') === 'admin';
}

function require_login(): void
{
    if (!current_user()) {
        header('Location: login.php');
        exit;
    }
}

function require_admin(): void
{
    require_login();
    if (!is_admin()) {
        http_response_code(403);
        page_header('Not allowed');
        echo '<main class="page"><h1>Admins only</h1><p class="muted">Ask an admin if you need this page.</p></main>';
        page_footer();
        exit;
    }
}

function log_action(string $action, string $detail = ''): void
{
    $st = db()->prepare('INSERT INTO audit_log (user_id, action, detail) VALUES (?, ?, ?)');
    $st->execute([current_user()['id'] ?? null, $action, mb_substr($detail, 0, 500)]);
}

function money($n): string
{
    $n = (float)$n;
    return '₱' . number_format($n, fmod($n, 1.0) == 0.0 ? 0 : 2);
}

function fmt_date(?string $d): string
{
    return $d ? date('M j, Y', strtotime($d)) : '';
}

function redirect(string $to): void
{
    header('Location: ' . $to);
    exit;
}

function page_header(string $title, string $active = ''): void
{
    $u = current_user();
    $app = h(cfg('app_name'));
    echo '<!doctype html><html lang="en"><head><meta charset="utf-8">';
    echo '<meta name="viewport" content="width=device-width, initial-scale=1">';
    echo '<title>' . h($title) . ' - ' . $app . '</title>';
    echo '<link rel="stylesheet" href="assets/app.css"></head><body>';
    if ($u) {
        $links = [
            'ledger'    => ['index.php', 'Ledger'],
            'arrears'   => ['arrears.php', 'Who still owes'],
            'employees' => ['employees.php', 'Employees'],
        ];
        if ($u['role'] === 'admin') {
            $links['users'] = ['users.php', 'Users'];
            $links['audit'] = ['audit.php', 'History'];
        }
        if (cfg('public_view') !== false) {
            $links['public'] = ['view.php', 'Public page'];
        }
        echo '<header class="top"><a class="brand" href="index.php">' . $app . '</a><nav>';
        foreach ($links as $key => [$href, $label]) {
            echo '<a href="' . $href . '"' . ($key === $active ? ' aria-current="page"' : '') . ($key === 'public' ? ' target="_blank" rel="noopener"' : '') . '>' . $label . '</a>';
        }
        echo '</nav><form method="post" action="login.php" class="who"><span>' . h($u['full_name']) . '</span>';
        echo '<input type="hidden" name="csrf" value="' . h(csrf_token()) . '">';
        echo '<button name="logout" value="1" class="link">Sign out</button></form></header>';
    }
}

function page_footer(): void
{
    echo '</body></html>';
}
