CREATE TABLE kudos_system.kudos_log (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	giver VARCHAR(32) NOT NULL,
	receiver VARCHAR(32) NOT NULL,
	round_id INT UNSIGNED NOT NULL,
	time DATETIME NOT NULL,
	PRIMARY KEY (id),
	INDEX idx_receiver (receiver),
	INDEX idx_giver (giver),
	INDEX idx_round (round_id),
	INDEX idx_time (time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE kudos_system.kudos_unique (
	giver VARCHAR(32) NOT NULL,
	receiver VARCHAR(32) NOT NULL,
	last_given DATETIME NOT NULL,
	PRIMARY KEY (giver),
	INDEX idx_receiver (receiver),
	INDEX idx_last_given (last_given)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
