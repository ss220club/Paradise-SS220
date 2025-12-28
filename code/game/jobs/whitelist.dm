// This needs moving somewhere more sensible
// Code reviewers I choose you to help me
// If this PR gets merged with this comment in you're all fired
// -aa07
/proc/can_use_species(mob/M, species)
	// Always if human
	if(species == "human" || species == "Human")
		return TRUE

	var/datum/species/S = GLOB.all_species[species]
	// Part of me feels like the below checks could be merged but ehh

	// No if species is not selectable
	if(NOT_SELECTABLE in S.species_traits)
		return FALSE

	// Yes if admin
	// SS220 EDIT START - Species bans
	// if(check_rights(R_ADMIN, FALSE))
	// 	return TRUE

	if(M.client && is_species_banned(M.client.ckey, species))
		return FALSE
	// SS220 EDIT END

	if(!S.is_available(M))
		return FALSE

	// No if species is blacklisted
	if(S.blacklisted)
		return FALSE

	return TRUE

// SS220 EDIT START - Species bans
/proc/is_species_banned(ckey, species)
	if(!GLOB.configuration.species_whitelist.species_whitelist_enabled)
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
// SS220 EDIT END
