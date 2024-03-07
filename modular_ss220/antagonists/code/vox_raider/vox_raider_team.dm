/datum/team/vox_raiders
	name = "Vox Raiders"
	antag_datum_type = /datum/antagonist/vox_raider

/datum/team/vox_raiders/New(list/starting_members, add_antag_datum)
	. = ..()
	forge_objectives()

/datum/team/vox_raiders/proc/forge_objectives()
	PRIVATE_PROC(TRUE)
	// Основная цель
	add_team_objective(new /datum/objective/raider_steal())
	//Коллекционная цель
	var/list/possible_collect_objective_types = list(
		/datum/objective/raider_entirety_steal,
		/datum/objective/raider_collection_access,
		/datum/objective/raider_collection_tech
		)
	var/picked_collect_objective_type = pick(possible_collect_objective_types)
	add_team_objective(new picked_collect_objective_type())
	// Конечная цель
	add_team_objective(new /datum/objective/survive(
	{"Не допустите гибели вас и остальных Воксов из команды."}))


	// !!!!!! Тест !!!!!!!
	add_team_objective(new /datum/objective/raider_entirety_steal())
	add_team_objective(new /datum/objective/raider_collection_access())
	add_team_objective(new /datum/objective/raider_collection_tech())

/datum/team/vox_raiders/add_member(datum/mind/new_member, add_antag_datum)
	. = ..()
	update_name()

/datum/team/vox_raiders/remove_member(datum/mind/member)
	. = ..()
	update_name()

/datum/team/vox_raiders/proc/update_name()
	PRIVATE_PROC(TRUE)
	var/new_name = get_raider_names_text()
	if(!new_name)
		name = initial(name)
		return

	name = "[initial(name)] of [new_name]"

/datum/team/vox_raiders/proc/get_raider_names_text(datum/mind/raider_to_exclude)
	var/list/raider_names = list()
	for(var/datum/mind/raider as anything in members)
		if(raider == raider_to_exclude)
			continue

		raider_names += raider.name

	return raider_names.Join(", ")
