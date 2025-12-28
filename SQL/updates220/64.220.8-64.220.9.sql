# Updating DB from 64.220.8 to 64.220.9
# Migration from species whitelist to species ban system

# This migration converts the old whitelist system to the new ban system
# Old logic: if species IS in whitelist -> player CAN play
# New logic: if species IS in bans -> player CANNOT play
# Therefore: we ban all species that are NOT in the player whitelist

CREATE TEMPORARY TABLE temp_all_species (species_name VARCHAR(50));

INSERT INTO temp_all_species (species_name) VALUES
('Human'),
('Diona'),
('Drask'),
('Grey'),
('Kidan'),
('Machine'),
('Nian'),
('Plasmaman'),
('Skrell'),
('Slime People'),
('Tajaran'),
('Unathi'),
('Vox'),
('Nucleation'),
('Vulpkanin'),
('Serpentid');

# Insert bans for all species that are NOT in players whitelist
INSERT INTO ban (
    bantime,
    ban_round_id,
    serverip,
    server_id,
    bantype,
    reason,
    job,
    duration,
    rounds,
    expiration_time,
    ckey,
    computerid,
    ip,
    a_ckey,
    a_computerid,
    a_ip,
    who,
    adminwho,
    edits,
    unbanned,
    unbanned_datetime,
    unbanned_round_id,
    unbanned_ckey,
    unbanned_computerid,
    unbanned_ip,
    exportable
)
SELECT
    NOW() as bantime,
    0 as ban_round_id,
    '127.0.0.0:8000' as serverip, -- You might want to change this to your server's IP
    'some_server' as server_id, -- You might want to change this to your server's ID
    'SPECIES_PERMABAN' as bantype,
    'Migrated from old whitelist system' as reason,
    s.species_name as job,
    -1 as duration,
    0 as rounds,
    DATE_ADD(NOW(), INTERVAL -1 MINUTE) as expiration_time,
    p.ckey as ckey,
    '' as computerid,
    '' as ip,
    'AutoMigration' as a_ckey,
    '' as a_computerid,
    '' as a_ip,
    '' as who,
    'AutoMigration' as adminwho,
    NULL as edits,
    NULL as unbanned,
    NULL as unbanned_datetime,
    NULL as unbanned_round_id,
    NULL as unbanned_ckey,
    NULL as unbanned_computerid,
    NULL as unbanned_ip,
    0 as exportable
FROM player p
JOIN temp_all_species s
ON p.species_whitelist IS NOT NULL
    AND p.species_whitelist != ''
    AND p.species_whitelist != '[]'
    AND NOT JSON_CONTAINS(p.species_whitelist, JSON_QUOTE(s.species_name))
	AND s.species_name != 'Serpentid'; -- Allow for everyone no matter what

# Clean up
DROP TEMPORARY TABLE temp_all_species;

ALTER TABLE `player` DROP COLUMN `species_whitelist`;
