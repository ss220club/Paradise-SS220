/datum/species
	var/required_playtimes_minutes = -1

/datum/species/proc/is_available(mob/M)
	if(!M.client)
		return TRUE
	var/list/play_records = params2list(M.client.prefs.exp)
	var/record = text2num(play_records[EXP_TYPE_LIVING])
	if(record < required_playtimes_minutes && M.client.donator_level == 0)
		return FALSE
	return TRUE

/datum/species/nucleation
	required_playtimes_minutes = 12000 // 200 часов

/datum/species/serpentid
	required_playtimes_minutes = -1 // 400 часов (24000), в рамках тестов до ТМа установлено в -1
