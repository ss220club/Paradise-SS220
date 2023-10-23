/datum/credits/halloween

/datum/credits/halloween/New()
	. = ..()
	soundtrack = 'config/credits/sounds/Twin Musicom - Spooky Ride.mp3'

/datum/credits/halloween/fill_credits()
	credits += new /datum/credit/episode_title/halloween()
	credits += new /datum/credit/streamers()
	credits += new /datum/credit/crewlist/halloween()
	credits += new /datum/credit/corpses/halloween()
	credits += new /datum/credit/staff/halloween()
	credits += new /datum/credit/disclaimer()

/datum/credit/episode_title/halloween

/datum/credit/episode_title/halloween/New()
	var/episode_title = ""

	var/list/titles = list()

	titles["halloween"] = file2list("config/credits/titles/halloween_titles.txt")

	for(var/possible_titles in titles)
		LAZYREMOVEASSOC(titles, possible_titles, "")

	episode_title = pick(titles["halloween"])

	content += "<center><h1>🎃EPISODE [GLOB.round_id]🎃<br><h1>[episode_title]</h1></h1></center>"

/datum/credit/crewlist/halloween

/datum/credit/crewlist/halloween/New()
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
			cast += "<center><h1>Актерская труппа:</h1></center>"
		chunk += "[human.real_name] в роли [uppertext(human.mind.assigned_role)]"
		chunksize++
		if(chunksize > 2)
			cast += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		cast += "<center>[jointext(chunk,"<br>")]</center>"

	content += cast

/datum/credit/corpses/halloween/New()
	var/list/corpses = list()

	for(var/mob/living/carbon/human/human in GLOB.dead_mob_list)
		if(!human.last_known_ckey)
			continue
		else if(human.real_name)
			corpses += human.real_name

	if(length(corpses))
		content += "<hr>"
		content += "<center><h1>Трупы:<br></h1></center>"
		while(length(corpses) > 10)
			content += "<center>[jointext(corpses, ", ", 1, 10)],</center>"
			corpses.Cut(1, 10)

		if(length(corpses))
			content += "<center>[jointext(corpses, ", ")].</center>"

/datum/credit/staff/halloween

/datum/credit/staff/halloween/New()
	var/list/staff = list()
	var/list/chunk = list()
	var/list/goodboys = list()
	var/list/staffjobs = file2list("config/credits/jobs/halloweenstaffjobs.txt")

	staffjobs.Remove("")

	var/chunksize = 0

	for(var/client/client in GLOB.clients)
		if(!client.holder)
			continue
		if(!length(staff))
			staff += "<hr>"
			staff += "<center><h1>Живые трупы:</h1></center>"

		if(check_rights_client(R_DEBUG|R_ADMIN|R_MOD, FALSE, client))
			chunk += "[uppertext(pick(staffjobs))] - '[client.key]'"
			chunksize++
		else if(check_rights_client(R_MENTOR, FALSE, client))
			goodboys += "[client.key]"

		if(chunksize > 2)
			staff += "<center>[jointext(chunk,"<br>")]</center>"
			chunk.Cut()
			chunksize = 0

	if(length(chunk))
		staff += "<center>[jointext(chunk,"<br>")]</center>"

	content += staff

	if(length(goodboys))
		content += "<center><h1>Духи:<br></h1>[english_list(goodboys)]</center><br>"
