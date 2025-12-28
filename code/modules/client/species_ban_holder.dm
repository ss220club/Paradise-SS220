/// Holder for species bans
/datum/species_ban_holder
	var/list/datum/species_ban/species_bans = list()

/// Get species bans query
/datum/species_ban_holder/proc/get_query(client/C)
	var/datum/db_query/query = SSdbcore.NewQuery({"
		SELECT bantime, bantype, reason, job, duration, expiration_time, a_ckey FROM ban
		WHERE ckey LIKE :ckey AND (
			(bantype LIKE 'SPECIES_TEMPBAN' AND expiration_time > NOW()) OR
			(bantype LIKE 'SPECIES_PERMABAN')
		) AND ISNULL(unbanned)
		ORDER BY bantime DESC LIMIT 100"},
		list("ckey" = C.ckey)
	)
	return query

/// Process the query results
/datum/species_ban_holder/proc/process_query(datum/db_query/Q)
	while(Q.NextRow())
		var/datum/species_ban/SB = new()
		SB.bantime = Q.item[1]
		SB.bantype = Q.item[2]
		SB.reason = Q.item[3]
		SB.species = Q.item[4]
		SB.duration = Q.item[5]
		SB.expiration_time = Q.item[6]
		SB.a_ckey = Q.item[7]
		species_bans[SB.species] = SB

/// Check if a species is banned
/datum/species_ban_holder/proc/is_banned(species)
	return (species in species_bans)

/datum/species_ban_holder/proc/get_ban(species)
	if(species in species_bans)
		return species_bans[species]
	return null

/// Reload species bans from database
/datum/species_ban_holder/proc/reload_species_bans(client/C)
	var/datum/db_query/data = get_query(C)
	if(!data.warn_execute())
		qdel(data)
		return

	species_bans.Cut()
	process_query(data)
	qdel(data)

/datum/species_ban
	var/bantime
	var/bantype
	var/reason
	var/species
	var/duration
	var/expiration_time
	var/a_ckey

/datum/species_ban_holder/vv_edit_var(var_name, var_value)
	return FALSE

/datum/species_ban_holder/CanProcCall(procname)
	return FALSE
