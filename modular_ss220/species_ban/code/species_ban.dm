/proc/is_species_banned(client/client, species)
	if(!GLOB.configuration.species_ban.species_bans_enabled)
		return FALSE

	return client.sbh.is_banned(species)

/proc/is_species_banned_ckey(ckey, species)
	if(!GLOB.configuration.species_ban.species_bans_enabled)
		return FALSE
	if(!SSdbcore.IsConnected())
		return FALSE

	var/datum/db_query/query = SSdbcore.NewQuery({"
		SELECT id FROM ban
		WHERE ckey=:ckey
		AND job=:species
		AND (bantype='SPECIES_PERMABAN' OR (bantype='SPECIES_TEMPBAN' AND expiration_time > Now()))
		AND (unbanned IS NULL OR unbanned = 0)
	"}, list("ckey" = ckey, "species" = species))

	if(!query.warn_execute())
		qdel(query)
		return FALSE

	var/is_banned = FALSE
	if(query.NextRow())
		is_banned = TRUE

	qdel(query)
	return is_banned

/// Lists all active species bans for src client.
/client/proc/display_species_bans(from_client_connection = FALSE)
	if(!from_client_connection)
		sbh.reload_species_bans(src)

	if(!length(sbh.species_bans))
		if(!from_client_connection)
			to_chat(src, chat_box_red(SPAN_WARNING("You have no active species bans!")))
		return

	var/list/messages = list()
	var/list/default_species_bans = GLOB.configuration.species_ban.default_species_bans

	for(var/species in sbh.species_bans)
		var/datum/species_ban/ban = sbh.species_bans[species]
		if(from_client_connection && (ban.species in default_species_bans) && ban.a_ckey == "@system") // SQL\updates220\64.220.8-64.220.9.sql
			continue
		switch(ban.bantype)
			if("SPECIES_PERMABAN")
				messages.Add(SPAN_WARNING("[ban.bantype]: [ban.species] - REASON: [ban.reason], by [ban.a_ckey]; [ban.bantime]"))
			if("SPECIES_TEMPBAN")
				messages.Add(SPAN_WARNING("[ban.bantype]: [ban.species] - REASON: [ban.reason], by [ban.a_ckey]; [ban.bantime]; [ban.duration]; expires [ban.expiration_time]"))

	if(!length(messages))
		if(!from_client_connection)
			to_chat(src, chat_box_red(SPAN_WARNING("You have no active species bans!")))
		return

	if(GLOB.configuration.url.banappeals_url)
		messages.Add(SPAN_WARNING("You can appeal the bans at: [GLOB.configuration.url.banappeals_url]"))

	to_chat(src, chat_box_red(messages.Join("<br>")))

/client/verb/displayspeciesbans()
	set category = "OOC"
	set name = "Display Current Species Bans"
	set desc = "Displays all of your current species bans."

	var/client/C = src
	if(!istype(C))
		C = usr.client

	C.display_species_bans(FALSE)
