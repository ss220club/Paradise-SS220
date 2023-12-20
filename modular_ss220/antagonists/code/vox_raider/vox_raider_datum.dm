/datum/game_mode
	var/list/datum/mind/vox_raiders = list()

/datum/antagonist/vox_raider
	name = "vox raider"
	roundend_category = "vox raiders"
	job_rank = ROLE_VOX_RAIDER
	special_role = SPECIAL_ROLE_VOX_RAIDER
	antag_hud_name = "hudvoxraider"
	antag_hud_type = ANTAG_HUD_VOX_RAIDER
	clown_gain_text = {"Ты очень много тренировался, чтобы наконец-то вступить в Синдикат, даже твоя клоунская натура не сможет помешать.
						Ты уверенно владеешь всем оружием."}
	wiki_page_name = "vox_raiders"
	var/datum/team/vox_raiders_team/raiders_team = null

/datum/antagonist/vox_raider/add_owner_to_gamemode()
	SSticker.mode.vox_raiders |= owner

/datum/antagonist/vox_raider/remove_owner_from_gamemode()
	SSticker.mode.vox_raiders -= owner

/datum/antagonist/vox_raider/greet()
	. = ..()
	SEND_SOUND(owner.current, sound('modular_ss220/antagonists/sound/ambience/antag/vox_raiders_intro.ogg'))

	. += {"Вы ненавидите Нанотрейзен, корпорация дала вам достаточно поводов для этого.
			Лучшую возможность бороться с ней предоставляет Синдикат, так что вы со своим напарником, разделяющим подобные чувства, связались с ними, чтобы вступить в их ряды.
			Теперь вы кровные братья и вы готовы сделать все ради общей цели."}

	var/raider_names = get_raider_names_text()
	if(raider_names)
		. += "Оберегай и кооперируйся с братьями: <b>[raider_names]</b>. Ведь только вместе вы сможете добиться успеха!"
		antag_memory += "<b>Ваши братья</b>: [raider_names]<br>"

	var/meeting_area = get_meeting_area()
	if(meeting_area)
		. += "Встреть их в назначенном месте:  <b>[meeting_area]</b>"
		antag_memory += "<b>Место встречи</b>: [meeting_area]<br>"

	. += "Слава Синдикату!"

/datum/antagonist/vox_raider/create_team(datum/team/vox_raiders_team/team)
	if(!istype(team))
		error("Wrong team type passed to [type].")
		return

	raiders_team = team
	return raiders_team

/datum/antagonist/vox_raider/get_team()
	return raiders_team

/datum/antagonist/vox_raider/proc/get_raider_names_text()
	PRIVATE_PROC(TRUE)
	var/datum/team/vox_raiders_team/team = get_team()
	if(!istype(team))
		return ""

	return team.get_raider_names_text(owner)

/datum/antagonist/vox_raider/proc/get_meeting_area()
	PRIVATE_PROC(TRUE)
	var/datum/team/vox_raiders_team/team = get_team()
	if(!istype(team))
		return ""

	return team.meeting_area

/datum/antagonist/vox_raider/proc/admin_add(admin, datum/mind/new_antag)
	if(!new_antag)
		return FALSE

	if(new_antag.has_antag_datum(/datum/antagonist/vox_raider))
		alert(admin, "Candidate is already vox raider")
		return FALSE

	if(!can_be_owned(new_antag))
		alert(admin, "Candidate can't be vox raider.")
		return FALSE

	switch(alert(admin, "Create new team or add to existing?", "vox raiders", "Create", "Add", "Cancel"))
		if("Create")
			return create_new_vox_raiders_team(admin, new_antag)
		if("Add")
			return add_to_existing_vox_raiders_team(admin, new_antag)

	return FALSE

/datum/antagonist/vox_raider/proc/create_new_vox_raiders_team(admin, datum/mind/first_raider)
	PRIVATE_PROC(TRUE)
	var/list/choices = list()
	for(var/mob/living/alive_living_mob in GLOB.alive_mob_list)
		var/datum/mind/mind_to_check = alive_living_mob.mind
		if(!mind_to_check || mind_to_check == first_raider || !can_be_owned(mind_to_check))
			continue

		choices["[mind_to_check.name]([alive_living_mob.ckey])"] = mind_to_check

	if(!length(choices))
		alert(admin, "No candidates for second vox raider found.")
		return FALSE

	sortTim(choices, GLOBAL_PROC_REF(cmp_text_asc))
	var/choice = tgui_input_list(admin, "Choose the vox raider.", "raider", choices)
	if(!choice)
		return FALSE

	var/datum/mind/second_raider = choices[choice]
	if(!second_raider)
		stack_trace("Chosen second vox raider `[choice]` was `null` for some reason")

	var/datum/team/vox_raiders_team/raider_team = new(list(first_raider, second_raider), FALSE)
	if(isnull(first_raider.add_antag_datum(src, raider_team)))
		qdel(raider_team)
		return FALSE

	if(isnull(second_raider.add_antag_datum(/datum/antagonist/vox_raider, raider_team)))
		error("Antag datum couldn't be granted to second raider in `/datum/antagonist/vox_raider/proc/create_new_vox_raiders_team`")
		alert(admin, "Second raider wasn't made into `vox raider` for some reason. Try again.")
		return TRUE

	log_admin("[key_name(admin)] made [key_name(first_raider)] and [key_name(second_raider)] into vox raiders.")
	return TRUE

/datum/antagonist/vox_raider/proc/add_to_existing_vox_raiders_team(admin, datum/mind/raider_to_add)
	PRIVATE_PROC(TRUE)
	var/list/choices = list()
	for(var/datum/team/vox_raiders_team/team in GLOB.antagonist_teams)
		var/list/member_ckeys = team.get_member_ckeys()
		choices["[team.name][length(member_ckeys) ? "([member_ckeys.Join(", ")])" : ""]"] = team

	if(!length(choices))
		alert(admin, "No vox raider teams found. Try creating new one.")
		return FALSE

	sortTim(choices, GLOBAL_PROC_REF(cmp_text_asc))
	var/choice = tgui_input_list(admin, "Choose the vox raiders team.", "vox raiders Team", choices)
	if(!choice)
		return FALSE

	var/datum/team/vox_raiders_team/chosen_team = choices[choice]
	if(!chosen_team)
		stack_trace("Chosen vox raiders team `[choice]` was `null` for some reason.")


	return !isnull(raider_to_add.add_antag_datum(src, chosen_team))
