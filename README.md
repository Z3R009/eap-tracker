# EAP tracker

A small PHP and MySQL web app that replaces the "2026" and "2026 MANDATORY" sheets of
EAP_PAYMENT_TRACKER_DTI_REGION.xlsx. Each sheet is a tab. Every payment belongs to a
collection (a collection day), the collection's color paints the cell, and each collection
shows whether it has been remitted.

## What you need

- PHP 7.4 or newer with the pdo_mysql and mbstring extensions (XAMPP and Laragon have both)
- MySQL 5.7+ or MariaDB 10.3+
- A current browser (Chrome or Edge 111+, Firefox 113+)

## Files

| File | What it does |
|---|---|
| `schema.sql` | Creates the tables, the two tabs (2026, 2026 Mandatory) and the Jan to Dec columns. |
| `seed_2026.sql` | Your workbook data: 57 employees, 403 payments, 9 collections and the remittances noted in the file. Optional. |
| `config.php` | Database login, timezone, division order. The only file you edit. |
| `index.php` | The ledger: tabs, summary cards, color grid, collections list. |
| `assets/app.js` | Everything the ledger does in the browser: tap to pay, dialogs, search, highlight. |
| `assets/app.css` | Look and feel, including dark mode and print. |
| `api.php` | The server side of the ledger (save payment, collect today, remit, add column or employee). |
| `collection.php` | One collection: its payments, remittances, a note, and a printable slip. |
| `arrears.php` | Who still owes, per tab, printable. |
| `employees.php` | Add and edit employees: division, status, start date, remarks, active. |
| `users.php` | Admin only: add users, change passwords, deactivate. |
| `audit.php` | Admin only: the last 300 actions, with who and when. |
| `login.php` | Sign in. On first run it creates the admin account. |
| `inc/bootstrap.php` | Database connection, session, login checks, CSRF protection, page header. |
| `inc/ledger.php` | Rules: collection totals, status (open, partial, remitted), color choice, remittance checks. |
| `tools/xlsx_to_sql.py` | Rebuilds `seed_2026.sql` from the workbook. Needs Python and `pip install openpyxl`. |

## Start it (XAMPP on Windows)

1. Copy the `eap-tracker` folder into `C:\xampp\htdocs\`.
2. Start Apache and MySQL in the XAMPP control panel.
3. Open http://localhost/phpmyadmin, create a database named `eap_tracker` (collation `utf8mb4_general_ci`).
4. Select that database, choose Import, and import `schema.sql`. Then import `seed_2026.sql` to bring in your workbook data.
5. Open `config.php`. For default XAMPP the values already work (user `root`, empty password). Change them if yours differ.
6. Open http://localhost/eap-tracker/ . The first screen asks you to create the admin account. Choose a password of 8 or more characters.

Command line instead: `mysql -u root -p eap_tracker < schema.sql`, then `< seed_2026.sql`, then
`php -S localhost:8000` inside the folder and open http://localhost:8000.

To let other computers in the office use it, put it on one PC or server that stays on and share its
address, for example http://192.168.1.20/eap-tracker/. Use HTTPS if it is reachable beyond the office network.

Load `seed_2026.sql` only once, into an empty database. To start clean, drop the database and repeat steps 3 and 4.

## Using it day to day

1. Sign in and pick a tab: 2026 (the monthly contribution) or 2026 Mandatory.
2. Press **Collect today**. This opens today's collection with its own color. Pressing it again the same day reuses it.
3. Record payments:
   - With "Tap a cell to pay the usual amount" on, one tap on an empty cell records the usual amount (50 or 100) as cash into the collection shown in "Recording into".
   - Hold Shift and click, or turn that option off, to open the form instead. There you can change the amount, pick Fund transfer, Paid directly, or Care of another office, and add a note.
   - Click a painted cell to edit or delete that payment.
4. Dashed cells are due and still unpaid. Gray "Direct" and "c/o" cells are payments that did not go through your collections.
5. Hover a collection in the list below the grid to highlight its cells. Click its date for the detail page and the printable slip.
6. When you hand money over, press **Remit** on that collection and enter the date, amount and reference. A partial amount marks the collection Partial. Once the full amount is remitted it is Remitted and its payments are locked.
7. To correct a remitted collection, an admin deletes the remittance on the collection page. It opens for changes again.
8. **Add column** adds a month or a new case to the current tab. **Add employee** adds a name to every tab.
9. **Who still owes** lists enrolled employees with due columns that have no payment.
10. Open collections older than 30 days show their age in red as a reminder to remit.

Roles: staff can record, collect, remit and add employees. Admins can also manage users, delete remittances and read History.

## Notes about the imported data

- Collection colors came from the cell fills. The first collection (blue) has only a remitted date in the file, so its date is shown as Feb 6.
- The seed records the July 23 collection as partly remitted: 900 (care of) plus 3,750 (fund transfer) of 4,950. The 300 difference is Ferolino's January to June cells, which no "Collection as of" row in the workbook included. Check whether that 300 was ever remitted.
- In the old 2026 sheet the "Collection as of" rows added up to 13,500 against 13,800 in the grid, because some cells were left out and a few were counted twice. The app counts each payment once.
- Names that differed between sheets were merged (for example Barachea and Barnachea). The list printed by `tools/xlsx_to_sql.py` shows every merge.
- "Rosario B. Cabarrubias" appeared twice in the Mandatory sheet (enrolled and not enrolled). Only the enrolled row was kept.
- "Direct", "Direct (1k)" and "c/o NC" or "c/o SC" text became payments of mode Direct or Care of. "Direct (1k)" has an amount of 1,000. Plain "Direct" and "c/o" have amount 0, so edit them if you know the amounts.
- Nine employees have no 2026 payment at all, so they appear in Who still owes. Mark them Not enrolled on the Employees page if they do not contribute.
- The "release 7-27" notes (payouts) are not imported. Only collections and remittances are tracked.

## Backups and safety

- Back up the database regularly: `mysqldump -u root -p eap_tracker > backup.sql`.
- Change `debug` to `false` in `config.php` (it already is) for everyday use.
- `inc/` and `tools/` carry an `.htaccess` that blocks direct web access on Apache.

## Public page (no sign in)

`view.php` is a page anyone with the link can open. An employee types their name, picks it from
the short list, and sees their own colored boxes for every tab, read only. Signing in is not needed.

- Share this link: `http://your-server/eap-tracker/` also lands there when nobody is signed in.
- **Staff sign in** is a small link in the top right corner. Staff who are signed in see **Open the ledger** instead.
  The staff menu has a **Public page** link that opens it in a new tab so you can copy the address.
- It shows only the person's own boxes (amount, color, collection date, exempt or paid another way). It never shows
  notes, remarks, other people, collection totals or remittances.
- Each visitor is limited to 60 searches a minute. Wrong access codes are limited to 8 tries in 10 minutes.
- The page asks search engines not to list it.

Optional settings, added inside `config.php` before the last `];` (the page works without them):

```php
    'public_view' => true,   // false turns the public page off completely
    'public_code' => '',     // set a word or number to make visitors enter it once
    'public_help' => 'If something looks wrong, tell the collector.',
```

After you change `config.php`, PHP can take a couple of seconds to notice. The first time the public page is used it
creates a small table called `public_hits` for the rate limit, so the database user needs permission to create tables
(the default XAMPP root user has it).