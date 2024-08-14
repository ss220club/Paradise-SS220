# Updating DB from 59.220.6 to 59.220.7
# Adds SS220 toggle prefs ~Maxiemar

ALTER TABLE `player` ADD `toggles_220` int(11) DEFAULT NULL;
