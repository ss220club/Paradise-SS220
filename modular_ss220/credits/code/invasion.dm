/datum/credits/invasion

/datum/credits/invasion/New()
	. = ..()
	soundtrack = 'config/credits/sounds/Invasion.mp3'

/datum/credits/invasion/fill_credits()
	credits += new /datum/credit/episode_title/invasion()
	credits += new /datum/credit/roles/invasion()
	credits += new /datum/credit/crewlist/invasion()
	credits += new /datum/credit/corpses/invasion()
	credits += new /datum/credit/staff/invasion()
	credits += new /datum/credit/disclaimer()

/datum/credit/episode_title/invasion

/datum/credit/episode_title/invasion/New()
	content += "<center><h1>вторжение</h1></center>"
	content += "<center><h1>часть вторая</h1></center>"
	content += "<hr>"

/datum/credit/roles/invasion

/datum/credit/proc/fill_roles_from_file(var/filepath)
	var/list/roles = file2list(filepath)
	roles.Remove("")

	var/list/roles_list = list()
	var/list/chunk = list()

	var/chunksize = -1

	for(var/role in roles)
		chunk += role
		chunksize++

		if(chunksize > 2)
			roles_list += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		roles_list += "<center>[jointext(chunk,"<br>")]</center>"

	return roles_list

/datum/credit/roles/invasion/New()
	content += fill_roles_from_file("config/credits/invasion/nt_roles.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/syndicate_roles.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/raider_roles.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/village_roles.txt")
	content += "<hr>"

/datum/credit/crewlist/invasion

/datum/credit/crewlist/invasion/New()
	var/list/cast = list()
	var/list/chunk = list()
	var/chunksize = 0

	for(var/mob/living/carbon/human/human in GLOB.alive_mob_list | GLOB.dead_mob_list)
		if(findtext(human.real_name,"(mannequin)"))
			continue
		if(ismonkeybasic(human))
			continue
		if(!human.last_known_ckey)
			continue
		if(!human.mind?.assigned_role)
			continue

		if(!length(cast) && !chunksize)
			cast += "<hr>"
			cast += "<center><h1>пережившие вторжение:</h1></center>"
		chunk += "[human.real_name] в роли [uppertext(human.mind.assigned_role)] ([human.last_known_ckey])"
		chunksize++
		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	content += cast

/datum/credit/corpses/invasion/New()
	var/list/corpses = list()

	for(var/mob/living/carbon/human/human in GLOB.dead_mob_list)
		if(!human.last_known_ckey)
			continue
		else if(human.real_name)
			corpses += human.real_name

	if(length(corpses))
		content += "<hr>"
		content += "<center><h1>не пережившие вторжение:<br></h1></center>"
		while(length(corpses) > 10)
			content += "<center>[jointext(corpses, ", ", 1, 10)],</center>"
			corpses.Cut(1, 10)

		if(length(corpses))
			content += "<center>[jointext(corpses, ", ")].</center>"

/datum/credit/staff/invasion

/datum/credit/staff/invasion/New()
	content += "<center><h1>разработка ивента:</h1></center>"
	content += fill_roles_from_file("config/credits/invasion/level_conception.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/level_design.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/environment_design.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/characters_design.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/main_code.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/second_code.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/sound_design.txt")
	content += "<hr>"
	content += fill_roles_from_file("config/credits/invasion/script.txt")
	content += "<hr>"
