<?php

declare(strict_types=1);
require __DIR__ . '/inc/bootstrap.php';

header('X-Robots-Tag: noindex, nofollow');
if (cfg('public_view') === false) {
    http_response_code(404);
    echo 'This page is not available.';
    exit;
}
$user = current_user();
$code = trim((string)(cfg('public_code') ?? ''));
$needCode = $code !== '' && !$user && empty($_SESSION['pub_ok']);
$help = (string)(cfg('public_help') ?? '');
$app = h(cfg('app_name'));
?>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex, nofollow">
    <title>Check your contributions - <?= $app ?></title>
    <link rel="stylesheet" href="assets/app.css">
</head>

<body>
    <header class="pubtop">
        <span class="brand"><?= $app ?></span>
        <span class="spacer"></span>
        <?php if ($user): ?>
            <a class="staff" href="index.php">Open the ledger</a>
        <?php else: ?>
            <a class="staff" href="login.php">Log In</a>
        <?php endif; ?>
    </header>

    <main class="pub">
        <h1>Check your contributions</h1>
        <p class="lead">Type your name to see what you have paid. This page is view only.</p>

        <section id="lock" <?= $needCode ? '' : 'hidden' ?>>
            <form id="lockForm" class="stack" style="max-width:360px">
                <label>Access code <input name="code" autocomplete="off" required></label>
                <p class="err" id="lockErr" role="alert"></p>
                <button class="primary">Continue</button>
            </form>
        </section>

        <section id="finder" <?= $needCode ? 'hidden' : '' ?>>
            <div class="pubsearch">
                <input type="search" id="q" placeholder="Your Name" autocomplete="off" aria-label="Your name" autofocus>
                <div id="results" class="results" aria-live="polite" hidden></div>
            </div>
            <p class="err" id="findErr" role="alert"></p>
        </section>

        <section id="record" hidden></section>

        <p class="pubfoot"><?= h($help) ?></p>
    </main>

    <script>
        window.PUB = {
            csrf: <?= json_encode(csrf_token()) ?>
        };
    </script>
    <script src="assets/public.js"></script>
</body>

</html>