# Updating DB from 73.220.9 to 73.220.10
# Adds donor chat effect ~Mirka-l

ALTER TABLE `player` ADD `donor_chat_effect` VARCHAR(7) COLLATE utf8mb4_unicode_ci DEFAULT 'None';
