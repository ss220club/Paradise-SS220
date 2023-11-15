/client/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(SSvote.active_vote)
		SSvote.active_vote.ui_interact(usr)
	else
		to_chat(usr, "Нет активных голосований")

/client/proc/start_vote()
	set category = "Admin"
	set name = "Начать голосование"
	set desc = "Начать голосование на сервере"

	if(!check_rights(R_ADMIN))
		return

	if(SSvote.active_vote)
		to_chat(usr, "Голосование уже в процессе")
		return

	// Ask admins which type of vote they want to start
	var/vote_types = subtypesof(/datum/vote)
	vote_types |= "\[CUSTOM]"

	// This needs to be a map to instance it properly. I do hate it as well, dont worry.
	var/list/votemap = list()
	for(var/vtype in vote_types)
		votemap["[vtype]"] = vtype

	var/choice = input(usr, "Выбрать тип голосования", "Голосование") as null|anything in vote_types

	if(choice == null)
		return

	if(choice != "\[CUSTOM]")
		// Not custom, figure it out
		var/datum/vote/votetype = votemap["[choice]"]
		SSvote.start_vote(new votetype(usr.ckey))
		return

	// Its custom, lets ask
	var/question = html_encode(input(usr, "За что голосуем?") as text|null)
	if(!question)
		return

	var/list/choices = list()
	for(var/i in 1 to 10)
		var/option = capitalize(html_encode(input(usr, "Впишите опцию или нажмите отмену для завершения") as text|null))
		if(!option || !usr.client)
			break
		choices |= option

	var/c2 = alert(usr, "Показать подсчеты во время голосования?", "Голоса", "Да", "Нет")
	var/c3 = input(usr, "Выберите тип расчета результата", "Голосование", VOTE_RESULT_TYPE_MAJORITY) as anything in list(VOTE_RESULT_TYPE_MAJORITY)

	var/datum/vote/V = new /datum/vote(usr.ckey, question, choices, TRUE)
	V.show_counts = (c2 == "Yes")
	V.vote_result_type = c3
	SSvote.start_vote(V)

