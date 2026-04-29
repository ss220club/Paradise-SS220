USER_VERB(cinematic_new, R_MAINTAINER, "Cinematic (NEW)", "Shows a cinematic.", VERB_CATEGORY_EVENT)
	var/datum/cinematic/choice = input(client, "Choose a cinematic to play to everyone in the server.", "Choose Cinematic") in sortTim(subtypesof(/datum/cinematic), GLOBAL_PROC_REF(cmp_typepaths_asc))
	if(!choice || !ispath(choice, /datum/cinematic))
		return

	play_cinematic(choice, world)

USER_VERB(cinematic_leave, R_NONE, "Прекратить смотреть синематик", "Отключить проигрывание синематика.", VERB_CATEGORY_OOC)
	SEND_SIGNAL(client, COMSIG_CINEMATIC_WATCHER_LEAVES)
