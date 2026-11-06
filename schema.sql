-- EAP tracker schema. Import into an empty database (utf8mb4).
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(40) NOT NULL UNIQUE,
  full_name VARCHAR(100) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','staff') NOT NULL DEFAULT 'staff',
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  division VARCHAR(30) NOT NULL DEFAULT '',
  status ENUM('enrolled','not_enrolled','scholarship','transferred') NOT NULL DEFAULT 'enrolled',
  start_on DATE NULL,
  remarks VARCHAR(255) NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_division_name (division, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- One row per tab in the ledger ("notebook page").
CREATE TABLE IF NOT EXISTS funds (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(60) NOT NULL,
  default_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  sort_no SMALLINT NOT NULL DEFAULT 0,
  active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- The grid columns of a tab: months (Jan..Dec) or cases (Elosis, Urbano...).
CREATE TABLE IF NOT EXISTS periods (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fund_id INT NOT NULL,
  label VARCHAR(40) NOT NULL,
  due_on DATE NULL,
  sort_no SMALLINT NOT NULL DEFAULT 0,
  UNIQUE KEY uq_fund_label (fund_id, label),
  FOREIGN KEY (fund_id) REFERENCES funds(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- "Collect today" creates one of these. Its color is the cell color in the grid.
CREATE TABLE IF NOT EXISTS collections (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fund_id INT NOT NULL,
  collected_on DATE NOT NULL,
  color CHAR(7) NOT NULL,
  note VARCHAR(255) NULL,
  created_by INT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_fund_date (fund_id, collected_on),
  FOREIGN KEY (fund_id) REFERENCES funds(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- One row per filled cell. collection_id is NULL for 'direct' and 'care_of' payments.
CREATE TABLE IF NOT EXISTS payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  period_id INT NOT NULL,
  collection_id INT NULL,
  amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  mode ENUM('cash','fund_transfer','direct','care_of') NOT NULL DEFAULT 'cash',
  note VARCHAR(255) NULL,
  created_by INT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY one_cell (employee_id, period_id),
  KEY idx_collection (collection_id),
  FOREIGN KEY (employee_id) REFERENCES employees(id),
  FOREIGN KEY (period_id) REFERENCES periods(id),
  FOREIGN KEY (collection_id) REFERENCES collections(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Money handed over for a collection. Several rows = partial remittances.
CREATE TABLE IF NOT EXISTS remittances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  collection_id INT NOT NULL,
  remitted_on DATE NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  mode ENUM('cash','fund_transfer','care_of') NOT NULL DEFAULT 'cash',
  reference VARCHAR(100) NULL,
  created_by INT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_collection (collection_id),
  FOREIGN KEY (collection_id) REFERENCES collections(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS audit_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL,
  action VARCHAR(40) NOT NULL,
  detail VARCHAR(500) NOT NULL DEFAULT '',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO funds (id, name, default_amount, sort_no) VALUES
  (1, '2026', 50.00, 1),
  (2, '2026 Mandatory', 100.00, 2);

INSERT IGNORE INTO periods (fund_id, label, due_on, sort_no) VALUES
  (1,'Jan','2026-01-01',1),(1,'Feb','2026-02-01',2),(1,'Mar','2026-03-01',3),
  (1,'Apr','2026-04-01',4),(1,'May','2026-05-01',5),(1,'Jun','2026-06-01',6),
  (1,'Jul','2026-07-01',7),(1,'Aug','2026-08-01',8),(1,'Sep','2026-09-01',9),
  (1,'Oct','2026-10-01',10),(1,'Nov','2026-11-01',11),(1,'Dec','2026-12-01',12);
