CREATE TABLE IF NOT EXISTS `kudos_log` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `giver` VARCHAR(50) NOT NULL COMMENT 'Ckey того, кто дал кудос, или ___SYSTEM___ для архивов',
    `receiver` VARCHAR(50) NOT NULL COMMENT 'Ckey получателя или флаг',
    `round_id` INT(11) UNSIGNED DEFAULT NULL COMMENT 'ID раунда',
    `past_unique` INT(11) DEFAULT 0 COMMENT 'Сумма уникальных кудосов за прошлый месяц',
    `time` DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    -- Индекс подсчета общего количества кудосов
    INDEX `idx_receiver_total` (`receiver`, `giver`),
    -- Индекс архива за прошлый месяц
    INDEX `idx_system_archive` (`giver`, `receiver`, `time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `kudos_unique` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `giver` VARCHAR(50) NOT NULL COMMENT 'Ckey того, кто отдал свой кудос',
    `receiver` VARCHAR(50) NOT NULL COMMENT 'Ckey того, кто получил этот кудос',
    `last_given` DATETIME NOT NULL COMMENT 'Дата и время последнего обновления кудоса',
    PRIMARY KEY (`id`),
    -- Индекс для проверки - голосовал ли уже игрок в этом месяце
    INDEX `idx_giver_monthly` (`giver`, `last_given`),
    -- Индекс подсчета текущих кудосов
    INDEX `idx_receiver_monthly` (`receiver`, `last_given`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
