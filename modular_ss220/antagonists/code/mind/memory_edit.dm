/datum/mind/proc/clear_antag_datum(datum/antagonist/antag_datum_to_clear)
	if(!has_antag_datum(antag_datum_to_clear))
		return

	remove_antag_datum(antag_datum_to_clear)
	var/antag_name = initial(antag_datum_to_clear.name)
	log_admin("[key_name(usr)] has removed <b>[antag_name]</b> from [key_name(current)]")
	message_admins("[key_name_admin(usr)] has removed <b>[antag_name]</b> from [key_name_admin(current)]")


/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["blood_brother"])
		switch(href_list["blood_brother"])
			if("clear")
				clear_antag_datum(/datum/antagonist/blood_brother)
			if("make")
				var/datum/antagonist/blood_brother/antag_datum = new
				if(!antag_datum.admin_add(usr, src))
					qdel(antag_datum)

	if(href_list["vox_raider"])
		switch(href_list["vox_raider"])
			if("clear")
				clear_antag_datum(/datum/antagonist/vox_raider)
			if("make")
				var/datum/antagonist/vox_raider/antag_datum = new
				if(!antag_datum.admin_add(usr, src))
					qdel(antag_datum)

	. = ..()

/datum/mind/proc/memory_edit_blood_brother()
	. = _memory_edit_header("blood brother")
	if(has_antag_datum(/datum/antagonist/blood_brother))
		. += "<b><font color='red'>BLOOD BROTHER</font></b>|<a href='?src=[UID()];blood_brother=clear'>Remove</a>"
	else
		. += "<a href='?src=[UID()];blood_brother=make'>Make Blood Brother</a>"

	. += _memory_edit_role_enabled(ROLE_BLOOD_BROTHER)

/datum/mind/proc/memory_edit_vox_raider()
	. = _memory_edit_header("vox raider")
	if(has_antag_datum(/datum/antagonist/vox_raider))
		. += "<b><font color='red'>VOX RAIDER</font></b>|<a href='?src=[UID()];vox_raider=clear'>Remove</a>"
	else
		. += "<a href='?src=[UID()];vox_raider=make'>Make Vox Raider</a>"

	. += _memory_edit_role_enabled(ROLE_VOX_RAIDER)

// Если ОФФы добавят нового антагониста с разумом, то потребуется смещение (кто-нибудь дайте мне разума)
// Используется в /datum/admins/proc/one_click_antag()
/datum/admins/Topic(href, href_list)
	. = ..()
	if(href_list["makeAntag"])
		switch(href_list["makeAntag"])
			if("8")
				log_admin("[key_name(usr)] has spawned a blood brothers.")
				if(!makeBloodBrothersTeam())
					to_chat(usr, "<span class='warning'>Unfortunately there weren't enough candidates available.</span>")
			if("9")
				log_admin("[key_name(usr)] has spawned a vox raiders.")
				if(!makeVoxRaidersTeam())
					to_chat(usr, "<span class='warning'>Unfortunately there weren't enough candidates available.</span>")

/datum/admins/proc/makeBloodBrothersTeam()
	var/confirm = alert("Are you sure?", "Confirm creation", "Yes", "No")
	if(confirm != "Yes")
		return FALSE

	var/amount = input("Size of team?", "Confirm creation")
	if(!amount || amount >= 10 || amount <= 0)
		return FALSE

	var/datum/antagonist/blood_brother/temp = new
	var/list/mob/living/carbon/human/candidates = list()

	if(GLOB.configuration.gamemode.prevent_mindshield_antags)
		temp.restricted_jobs += temp.protected_jobs

	log_admin("[key_name(owner)] tried making Blood Brothers with One-Click-Antag")
	message_admins("[key_name_admin(owner)] tried making Blood Brothers with One-Click-Antag")

	for(var/mob/living/carbon/human/applicant in GLOB.player_list)
		if(CandCheck(ROLE_BLOOD_BROTHER, applicant, temp))
			candidates += applicant

	if(candidates.len)
		var/numBrothers = min(candidates.len, amount)
		var/list/assigned = list()


		for(var/i = 0, i<numBrothers, i++)
			if(i>=amount)
				break
			H = pick(candidates)
			assigned.Add(H)
			candidates.Remove(H)

		var/datum/team/blood_brothers_team/brother_team = new(assigned, TRUE)

		return TRUE
	return FALSE

/datum/admins/proc/makeVoxRaidersTeam()
	var/confirm = alert("Are you sure?", "Confirm creation", "Yes", "No")
	if(confirm != "Yes")
		return FALSE
	new /datum/event/abductor
	//new /datum/event/vox_raider

	log_admin("[key_name(owner)] tried making Vox Raiders with One-Click-Antag")
	message_admins("[key_name_admin(owner)] tried making Vox Raiders with One-Click-Antag")

	return TRUE





	// var/image/I = new('icons/mob/simple_human.dmi', "wizard")
	// var/list/candidates = SSghost_spawns.poll_candidates("Do you wish to be considered for the position of a Wizard Federation 'diplomat'?", "wizard", source = I)

	// log_admin("[key_name(owner)] tried making a Wizard with One-Click-Antag")
	// message_admins("[key_name_admin(owner)] tried making a Wizard with One-Click-Antag")

	// if(candidates.len)
	// 	var/mob/dead/observer/selected = pick(candidates)
	// 	candidates -= selected

	// 	var/mob/living/carbon/human/new_character = makeBody(selected)
	// 	new_character.mind.make_Wizard()
	// 	dust_if_respawnable(selected)
	// 	return 1
	// return 0
