<?php
// Copy this file to config.php and fill in your real values.
// config.php is NOT stored in GitHub.
return [
    'db_host'  => '127.0.0.1',
    'db_port'  => 3306,
    'db_name'  => 'eap_tracker',
    'db_user'  => 'your_db_user',
    'db_pass'  => 'your_db_password',
    'timezone' => 'Asia/Manila',
    'app_name' => 'EAP tracker',
    // Order of the division groups in the grid. Any other division is listed after these.
    'division_order' => ['MSSD', 'AFMD', 'CPD', 'IDD', 'SDD', 'JOCOS'],
    // true shows the real error text in API responses. Keep false when others use the system.
    'debug' => false,
];