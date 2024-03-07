/datum/game_mode
	var/list/datum/mind/vox_raiders = list()

/datum/game_mode/antag_mix/vox_raider
	name = "vox raiders"
	config_tag = "vox_raiders"
	required_players = 30

/datum/game_mode/antag_mix/vox_raider/New()
	. = ..()
	list_scenarios = list(/datum/antag_scenario/team/vox_raiders)

	var/datum/antag_scenario/antag_datum = /datum/antag_scenario/team/vox_raiders
	required_players = initial(antag_datum.required_players)

/datum/game_mode/antag_mix/vox_raider/announce()
	to_chat(world, "<B>The current game mode is - Vox Raiders!</B>")
	to_chat(world, "Поблизости сектора [world.name] обнаружен корабль <b>воксов</b>!")
	to_chat(world, "<b>Воксы</b> - всей стаей падки на блестяшки и ценности, с ними можно выгодно поторговаться. Но больше ценностей они ценят друг друга.")
	to_chat(world, "<b>Экипаж</b> - следите за воксами внимательно, в том числе и за теми кто на станции, не допустите потерю дорогостоящего оборудования!")

/datum/game_mode/antag_mix/proc/auto_declare_completion_vox_raiders()
	if(!length(vox_raiders))
		return

	var/list/text = list("<br><font size=3><b>Прогресс Вокс'ов:</b></font>")
	for(var/datum/team/vox_raiders/team in GLOB.antagonist_teams)
		if(!team.objective_holder)
			continue

		var/count = 1
		var/teamwin = 1
		text += "<br><b>Стая [team.name]</b> ("
		for(var/datum/objective/objective in team.objective_holder.objectives)
			if(objective.check_completion())
				text += "<br><B>Цель #[count]</B>: [objective.explanation_text] <font color='green'><B>Выполнена!</B></font>"
				SSblackbox.record_feedback("nested tally", "vox_objective", 1, list("[objective.type]", "SUCCESS"))
			else
				text += "<br><B>Цель #[count]</B>: [objective.explanation_text] <font color='red'>Провалена.</font>"
				SSblackbox.record_feedback("nested tally", "vox_objective", 1, list("[objective.type]", "FAIL"))
				teamwin = 0
			count++
		if(teamwin)
			text += "<br><font color='green'><B>Стая успешно завершила свои цели!</B></font>"
			SSblackbox.record_feedback("tally", "vox_success", 1, "SUCCESS")
		else
			text += "<br><font color='red'><B>Стая провалилась!</B></font>"
			SSblackbox.record_feedback("tally", "wizard_success", 1, "FAIL")
		var/is_survive = FALSE
		for(var/datum/mind/mind in vox_raiders)
			if(!mind.current || mind.current.stat==DEAD)
				break
		if(is_survive)
			text += "<br><font color='green'><B>Вся стая выжила!</B></font>"
		else
			text += "<br><font color='red'><B>У стаи есть потери!</B></font>"

	var/obj/machinery/vox_trader/trader = locate() in GLOB.machines
	if(!trader)
		text += "<br>"
		return text.Join("")
	trader.synchronize_traders_stats()

	text += "<br><br><b>Всего заработано Кикикридитов:</b> [trader.value_sum]"

	var/precious_count = 0
	var/precious_biggest_element
	for(var/I in trader.precious_collected_dict)
		var/value = trader.precious_collected_dict[I]["value"]
		var/count = trader.precious_collected_dict[I]["count"]
		var/value_average = value / count
		var/element = list(I = value_average)
		precious_count += count
		if(!precious_biggest_element)
			precious_biggest_element = element
			continue
	text += "<br><b>Самый дорогой проданный товар:</b> [precious_biggest_element] ([precious_biggest_element[1]]), всего продано [trader.precious_collected_dict[precious_biggest_element]["count"]] штук."

	text += "<br><br><b>Собраны доступы:</b>"
	var/list/checked_accesses = list()
	var/list/region_code = list(
		REGION_GENERAL, REGION_SECURITY, REGION_MEDBAY, REGION_RESEARCH,
		REGION_ENGINEERING, REGION_SUPPLY, REGION_COMMAND, REGION_CENTCOMM
		)
	for(var/code in region_code)
		var/list/region_accesses
		if(code != REGION_CENTCOMM)
			region_accesses = get_region_accesses(code)
		else
			region_accesses = list(ACCESS_CENT_GENERAL)
		for(var/access in trader.collected_access_list)
			if(access in region_accesses)
				region_accesses.Remove(access)
		checked_accesses += list(code = region_accesses)
	for(var/code in region_code)
		if(length(checked_accesses[code]))
			continue
		switch(code)
			if(REGION_GENERAL)
				text += "Собраны все общественные и сервисные доступы!"
			if(REGION_SECURITY)
				text += "<font color='red'>Собраны все доступы службы безопасности!</font>"
			if(REGION_MEDBAY)
				text += "<font color='teal'>Собраны все доступы медицинского отдела!</font>"
			if(REGION_RESEARCH)
				text += "<font color='teal'>Собраны все доступы научного отдела!</font>"
			if(REGION_ENGINEERING)
				text += "<font color='orange'>Собраны все инженерные доступы!</font>"
			if(REGION_SUPPLY)
				text += "<font color='brown'>Собраны все доступы отдела снабжения!</font>"
			if(REGION_COMMAND)
				text += "<font color='blue'>Собраны все командные доступы!</font>"
			if(REGION_CENTCOMM)
				text += "<font color='green'><B>Получен доступ к Центральному Командованию!</B></font>"

	text += "<br><br><b>Собраны технологии:</b>"
	for(var/i in trader.collected_tech_dict)
		text += "[i]: [trader.collected_tech_dict[i]]"

	text += "<br>"
	return text.Join("")
