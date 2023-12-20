/datum/team/get_member_ckeys()
	var/list/member_ckeys = list()
	for(var/datum/mind/member as anything in members)
		if(!member.current)
			continue

		member_ckeys += member.current.ckey

	return member_ckeys


/datum/team/vox_raiders_team
	name = "vox raiders"
	antag_datum_type = /datum/antagonist/vox_raider

/datum/team/vox_raiders_team/New(list/starting_members, add_antag_datum)
	. = ..()
	forge_objectives()

/datum/team/vox_raiders_team/add_member(datum/mind/new_member, add_antag_datum)
	. = ..()
	update_name()

/datum/team/vox_raiders_team/remove_member(datum/mind/member)
	. = ..()
	update_name()

/datum/team/vox_raiders_team/proc/get_raider_names_text(datum/mind/raider_to_exclude)
	var/list/raider_names = list()
	for(var/datum/mind/raider as anything in members)
		if(raider == raider_to_exclude)
			continue

		raider_names += raider.name

	return raider_names.Join(", ")

/datum/team/vox_raiders_team/proc/update_name()
	PRIVATE_PROC(TRUE)
	var/new_name = get_raider_names_text()
	if(!new_name)
		name = initial(name)
		return

	name = "[initial(name)] of [new_name]"

/datum/team/vox_raiders_team/proc/forge_objectives()
	PRIVATE_PROC(TRUE)
	add_team_objective(new /datum/objective/raider_steal())
	add_team_objective(new /datum/objective/survive(
	{"Не допустите гибели вас и остальных ВОКСов из команды."}))

