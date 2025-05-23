#define MAX_SAVE_SLOTS_SS220 5


/datum/client_login_processor/donator_check/proc/CheckAutoDonatorLevel(client/C)
	var/static/list/ultimate_worker = list("Банда", "Братюня", "Сестрюня", "Главный Администратор", "Старший Администратор")

	var/static/list/big_worker = list("Администратор", "Старший Разработчик", "Разработчик", "Бригадир Мапперов", "Маппер", "Ведущий Редактор Вики", "Администратор СС14")

	if(C.holder)
		C.donator_level = (C.holder.rank in ultimate_worker) ? DONATOR_LEVEL_MAX : (C.holder.rank in big_worker) ? BIG_WORKER_LEVEL : LITTLE_WORKER_LEVEL
		return

	var/is_wl = GLOB.configuration.overflow.reroute_cap == 0.5 ? TRUE : FALSE

	var/datum/db_query/rank_ckey_read = SSdbcore.NewQuery(
		"SELECT admin_rank FROM [is_wl ? "admin" : "admin_wl"] WHERE ckey=:ckey",
			list("ckey" = C.ckey), disable_replace = is_wl)

	if(!rank_ckey_read.warn_execute())
		qdel(rank_ckey_read)
		return

	while(rank_ckey_read.NextRow())
		C.donator_level = (rank_ckey_read.item[1] in ultimate_worker) ? DONATOR_LEVEL_MAX : (rank_ckey_read.item[1] in big_worker) ? BIG_WORKER_LEVEL : LITTLE_WORKER_LEVEL

	qdel(rank_ckey_read)

/datum/client_login_processor/donator_check/get_query(client/C)
	var/datum/db_query/query = SSdbcore.NewQuery("SELECT 1", list()) // La stampella
	return query

/datum/client_login_processor/donator_check/process_result(datum/db_query/Q, client/C)
	if(IsGuestKey(C.ckey))
		return

	CheckAutoDonatorLevel(C)


	var/donator_level = SScentral.get_player_donate_tier_blocking(C)

	switch(C.donator_level)
		if(LITTLE_WORKER_LEVEL)
			C.donator_level = LITTLE_WORKER_TTS_LEVEL > donator_level ? C.donator_level : donator_level
		if(BIG_WORKER_LEVEL)
			C.donator_level = BIG_WORKER_TTS_LEVEL > donator_level ? C.donator_level : donator_level
		else
			C.donator_level = max(C.donator_level, donator_level)

	C.donor_loadout_points()
	C.donor_character_slots()

/client/donor_loadout_points()
	if(!prefs)
		return

	prefs.max_gear_slots = GLOB.configuration.general.base_loadout_points

	switch(donator_level)
		if(1)
			prefs.max_gear_slots += 2
		if(2)
			prefs.max_gear_slots += 4
		if(3)
			prefs.max_gear_slots += 8
		if(4)
			prefs.max_gear_slots += 12
		if(5)
			prefs.max_gear_slots += 16
		if(LITTLE_WORKER_LEVEL)
			prefs.max_gear_slots += 1
		if(BIG_WORKER_LEVEL)
			prefs.max_gear_slots += 5

/client/proc/donor_character_slots()
	if(!prefs)
		return

	prefs.max_save_slots = MAX_SAVE_SLOTS_SS220 + 5 * donator_level

	prefs.character_saves.len = prefs.max_save_slots

/client/proc/is_donor_allowed(required_donator_level)
	switch(donator_level)
		if(LITTLE_WORKER_LEVEL)
			if(required_donator_level > LITTLE_WORKER_LEVEL)
				return FALSE
		if(BIG_WORKER_LEVEL)
			if(required_donator_level > BIG_WORKER_LEVEL)
				return FALSE
	return required_donator_level <= donator_level

#undef MAX_SAVE_SLOTS_SS220
