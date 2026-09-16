USER_VERB(cinematic_new, R_MAINTAINER, "Cinematic (NEW)", "Shows a cinematic.", VERB_CATEGORY_EVENT)
	var/datum/cinematic/choice = input(client, "Choose a cinematic to play to everyone in the server.", "Choose Cinematic") in sortTim(subtypesof(/datum/cinematic), GLOBAL_PROC_REF(cmp_typepaths_asc))
	if(!choice || !ispath(choice, /datum/cinematic))
		return

	play_cinematic(choice, world)

/client/verb/cinematic_leave()
	set name = "Прекратить смотреть синематик"
	set category = "OOC"
	set desc = "Отключить проигрывание синематика."

	if(!mob.screens["cinematic"])
		return

	SEND_SIGNAL(src, COMSIG_CINEMATIC_WATCHER_LEAVES)
