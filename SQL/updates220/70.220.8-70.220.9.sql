CREATE TABLE IF NOT EXISTS `kudos_log` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `giver` VARCHAR(50) NOT NULL COMMENT 'Кто дал',
    `receiver` VARCHAR(50) NOT NULL COMMENT 'Кому дал',
    `round_id` INT(11) UNSIGNED DEFAULT NULL,
    `time` DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_history` (`receiver`, `time`),
    -- Индекс для сброса
    INDEX `idx_system` (`giver`, `receiver`, `time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `kudos_unique` (
    `target_ckey` VARCHAR(50) NOT NULL COMMENT 'Ckey игрока, чьи кудосы считаем',
    `current_month_count` INT(11) DEFAULT 0 COMMENT 'Счётчик за текущий месяц',
    `past_month_count` INT(11) DEFAULT 0 COMMENT 'Счётчик за прошлый месяц',
    `last_update` DATETIME NOT NULL COMMENT 'Дата последнего изменения',
    PRIMARY KEY (`target_ckey`),
    INDEX `idx_counts` (`current_month_count`, `past_month_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
