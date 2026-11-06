<?php
// Edit these values to match your server. Nothing else needs changing.
return [
    'db_host'  => '127.0.0.1',
    'db_port'  => 3306,
    'db_name'  => 'eap_tracker',
    'db_user'  => 'root',
    'db_pass'  => '',
    'timezone' => 'Asia/Manila',
    'app_name' => 'EAP tracker',
    // Order of the division groups in the grid. Any other division is listed after these.
    'division_order' => ['MSSD', 'AFMD', 'CPD', 'IDD', 'SDD', 'JOCOS'],
    // true shows the real error text in API responses. Keep false when others use the system.
    'debug' => false,
];
