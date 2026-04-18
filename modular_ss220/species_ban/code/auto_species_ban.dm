/// Apply default species bans to a new player
/proc/apply_default_species_bans(ckey)
	if(!GLOB.configuration.species_ban.species_bans_enabled)
		return

	if(!SSdbcore.IsConnected())
		log_debug("AutoBan: Database not connected, skipping default species bans for [ckey]")
		return

	var/list/default_species_bans = GLOB.configuration.species_ban.default_species_bans
	if(!length(default_species_bans))
		return

	var/player_exists = FALSE
	var/datum/db_query/query_check = SSdbcore.NewQuery("SELECT id FROM player WHERE ckey=:ckey", list(
		"ckey" = ckey
	))
	if(!query_check.warn_execute())
		qdel(query_check)
		return
	if(query_check.NextRow())
		player_exists = TRUE
	qdel(query_check)

	if(!player_exists)
		log_debug("AutoBan: Player [ckey] not found in database")
		return

	var/serverip = "[world.internet_address]:[world.port]"
	var/ban_reason = "Automatic ban for new players. This species requires special approval."
	var/duration = -1

	var/who = ""
	for(var/client/C in GLOB.clients)
		if(!who)
			who = "[C]"
		else
			who += ", [C]"

	var/adminwho = "@system"
	for(var/client/C in GLOB.admins)
		adminwho += ", [C]"

	for(var/species_name in default_species_bans)
		if(!(species_name in GLOB.all_species))
			log_debug("AutoBan: Invalid species [species_name] in default_species_bans config")
			continue

		var/datum/db_query/query_insert = SSdbcore.NewQuery({"
			INSERT INTO ban (`id`,`bantime`,`serverip`,`bantype`,`reason`,`job`,`duration`,`rounds`,`expiration_time`,`ckey`,`computerid`,`ip`,`a_ckey`,`a_computerid`,`a_ip`,`who`,`adminwho`,`edits`,`unbanned`,`unbanned_datetime`,`unbanned_ckey`,`unbanned_computerid`,`unbanned_ip`,`ban_round_id`,`unbanned_round_id`, `server_id`)
			VALUES (null, Now(), :serverip, 'SPECIES_PERMABAN', :reason, :species, :duration, :rounds, Now() + INTERVAL :duration MINUTE, :ckey, :computerid, :ip, :a_ckey, :a_computerid, :a_ip, :who, :adminwho, '', null, null, null, null, null, :roundid, null, :server_id)
		"}, list(
			"serverip" = serverip,
			"reason" = ban_reason,
			"species" = species_name,
			"duration" = "[duration]",
			"rounds" = "0",
			"ckey" = ckey,
			"computerid" = "",
			"ip" = "",
			"a_ckey" = "@system",
			"a_computerid" = "",
			"a_ip" = world.internet_address,
			"who" = who,
			"adminwho" = adminwho,
			"roundid" = GLOB.round_id,
			"server_id" = GLOB.configuration.system.instance_id
		))

		if(!query_insert.warn_execute())
			log_debug("AutoBan: Failed to insert ban for [ckey] on species [species_name]")
			qdel(query_insert)
			continue

		qdel(query_insert)
		log_admin("AutoBan: Applied default species ban for [ckey] on species [species_name]")
