CREATE TABLE `kudos_history` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `giver` VARCHAR(32) NOT NULL,       -- ckey того, кто похвалил
    `receiver` VARCHAR(32) NOT NULL,    -- ckey того, кого похвалили
    `points` DECIMAL(10, 2) NOT NULL,   -- Вес конкретного голоса
    `round_id` INT NOT NULL,            -- ID раунда из GLOB.round_id
    `timestamp` DATETIME NOT NULL,      -- Время (NOW())
    INDEX `idx_pair` (`giver`, `receiver`) -- Индекс для быстрого COUNT в коде
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `kudos_totals` (
    `receiver` VARCHAR(32) PRIMARY KEY, -- ckey игрока
    `total_score` DECIMAL(10, 2) DEFAULT 0.00, -- Накопленные очки
    UNIQUE INDEX `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `kudos_archive` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `receiver` VARCHAR(32) NOT NULL,
    `total_score` DECIMAL(10, 2) NOT NULL,
    `month_mark` VARCHAR(10) NOT NULL, -- Формат "MM-YYYY"
    INDEX `idx_month` (`month_mark`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
