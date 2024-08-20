# Updating DB from 59.220.6 to 59.220.7
# Adds SS220 toggle prefs ~Maxiemar

DROP TABLE IF EXISTS `player_220`;
CREATE TABLE `player_220` (
	`ckey` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_general_ci',
	`toggles_220` int(11) DEFAULT NULL
	PRIMARY KEY (`ckey`) USING BTREE,
) COLLATE = 'utf8mb4_general_ci' ENGINE = InnoDB;