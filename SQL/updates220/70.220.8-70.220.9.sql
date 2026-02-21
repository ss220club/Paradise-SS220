CREATE TABLE `kudos_history` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `giver` VARCHAR(32) NOT NULL,
    `receiver` VARCHAR(32) NOT NULL,
    `points` DECIMAL(10, 2) NOT NULL,
    `round_id` INT NOT NULL,
    `timestamp` DATETIME NOT NULL,
    INDEX `idx_pair` (`giver`, `receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `kudos_totals` (
    `receiver` VARCHAR(32) PRIMARY KEY,
    `total_score` DECIMAL(10, 2) DEFAULT 0.00,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `kudos_archive` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `receiver` VARCHAR(32) NOT NULL,
    `total_score` DECIMAL(10, 2) NOT NULL,
    `month_mark` VARCHAR(10) NOT NULL,
    INDEX `idx_month` (`month_mark`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
