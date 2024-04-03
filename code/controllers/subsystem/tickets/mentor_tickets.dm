GLOBAL_REAL(SSmentor_tickets, /datum/controller/subsystem/tickets/mentor_tickets)

/datum/controller/subsystem/tickets/mentor_tickets/New()
	NEW_SS_GLOBAL(SSmentor_tickets)
	PreInit()
	ss_id = "mentor_tickets"

/datum/controller/subsystem/tickets/mentor_tickets
	name = "Mentor Tickets"
	offline_implications = "Mentor tickets will no longer be marked as stale. No immediate action is needed."
	ticket_system_name = "Mentor Tickets"
	ticket_name = "Ментор тикет"
	span_class = "mentorhelp"
	anchor_link_extra = ";is_mhelp=1"
	ticket_help_type = "Mentorhelp"
	ticket_help_span = "mentorhelp"
	other_ticket_name = "Админ"
	other_ticket_permission = R_ADMIN
	close_rights = R_MENTOR | R_ADMIN
	rights_needed = R_MENTOR | R_ADMIN | R_MOD
	db_save_id = "MENTOR"

/datum/controller/subsystem/tickets/mentor_tickets/Initialize()
	..()
	close_messages = list("<font color='red' size='3'><b>- [ticket_name] Закрыт -</b></font>",
				"<span class='boldmessage'>Пожалуйста, старайтесь как можно более подробно описывать информацию в ментор-хелпе. Менторы не знают всю ситуацию, в которой вы находитесь, и им необходимо больше информации для предоставления вам помощи.</span>",
				"<span class='[span_class]'>Ваш [ticket_name] был закрыт.</span>")

	response_phrases = list("Известный баг" = "К сожалению, это известный баг. К счастью, он скоро будет пофикшен.",
		"Баг ТМа" = "К сожалению, это ошибка текущего тестового обновления (ТМ - TestMerge). Она должна исчезнуть после того, как ТМ снимут или пофиксят.",
		"Почисти Кэш" = "Чтобы исправить пустой экран, перейдите во вкладку 'Special Verbs' и нажмите 'Reload UI Resources'. Если это не поможет, очистите Кэш Byond, для этого закройте все процессы 'Dream Maker', перейдите в Byond, нажмите шестерёнку и выберите 'Preferences', во вкладке 'Games' будет кнопка 'Clear Cache'. Если ни один из этих способов не помог, советуем обратиться в 'paradise-help' чат на дискорд сервере.",
		"Эксперементируй!" = "Эксперементируй! Большая часть удовольствия от этой игры, состоит в том, чтобы пробовать различные штуки и бороться с последствиями, если что-то пошло не так.",
		"Как выполнить цель" = "Есть множество способов выполнить цель на антаге. Если вы собрались действовать напролом, постарайтесь убедиться в том, что успеете войти и выйти до прибытия подкрепления. Стелс тоже может сработать, если вы будете действовать быстро и избегать лишнего внимания. Но не забывайте об РП способах! Заманить цель в ловушку гораздо интереснее, чем разрядить в неё барабан с револьвера. Даже если вы не преуспеете, таким образом все стороны явно получат больше удовольствия.",
		"Английский тикет" = "Hello! You've reached the Russian Paradise server. Perhaps you've mistaken. The English one has this name: \[Paradise Station]."
	)

	if(GLOB.configuration.url.github_url)
		response_phrases["Новый баг"] = "Звучит как баг! Чтобы сообщить о нём, пожалуйста, перейдите на наш <a href='[GLOB.configuration.url.github_url]'>Github</a>. После чего перейдите в 'Issues', нажмите 'New Issue' и заполните форму. Если в репорте будет информация с текущего раунда - отправьте его по окончании. В качестве альтернативы, вы можете написать в канал 'ss13-трекер', однако репорты с Github обрабатываются быстрее!"

	var/unsorted_responses = list()
	for(var/key in response_phrases)        //build a new list based on the short descriptive keys of the master list so we can send this as the input instead of the full paragraphs to the admin choosing which autoresponse
		unsorted_responses += key
	sorted_responses = sortTim(unsorted_responses, GLOBAL_PROC_REF(cmp_text_asc)) //use sortTim and cmp_text_asc to sort alphabetically


/datum/controller/subsystem/tickets/mentor_tickets/message_staff(msg, prefix_type = NONE, important = FALSE)
	message_mentorTicket(msg, important)

/datum/controller/subsystem/tickets/mentor_tickets/create_other_system_ticket(datum/ticket/T)
	SStickets.newTicket(get_client_by_ckey(T.client_ckey), T.first_raw_response, T.title)

/datum/controller/subsystem/tickets/mentor_tickets/autoRespond(N)
	if(!check_rights(rights_needed))
		return

	var/datum/ticket/T = allTickets[N]
	var/client/C = usr.client
	if((T.staffAssigned && T.staffAssigned != C) || (T.lastStaffResponse && T.lastStaffResponse != C) || ((T.ticketState != TICKET_OPEN) && (T.ticketState != TICKET_STALE))) //if someone took this ticket, is it the same mentor who is autoresponding? if so, then skip the warning
		if(alert(usr, "[T.ticketState == TICKET_OPEN ? "Другой ментор уже занимается вопросом." : "Этот тикет уже помечен как решённый или закрытый."] Вы уверены что хотите продолжить?", "Подтверждение", "Да", "Нет") != "Да")
			return
	T.assignStaff(C)

	var/message_key = input("Выберите автоответ. Это пометит тикет как решённый.", "Автоответ") as null|anything in sortTim(sorted_responses, GLOBAL_PROC_REF(cmp_text_asc)) //use sortTim and cmp_text_asc to sort alphabetically
	var/client/ticket_owner = get_client_by_ckey(T.client_ckey)
	if(message_key == null)
		T.staffAssigned = null //if they cancel we dont need to hold this ticket anymore
		return

	SEND_SOUND(returnClient(N), sound('sound/effects/adminhelp.ogg'))
	to_chat_safe(returnClient(N), "<span class='[span_class]'>[key_name_hidden(C)] использует автоответ:</span> <span class='adminticketalt'>[response_phrases[message_key]]</span>") //for this we want the full value of whatever key this is to tell the player so we do response_phrases[message_key]
	message_staff("[C] ипользовал автоответ в ментор-тикете [ticket_owner]:<span class='adminticketalt'> [message_key]</span>") //we want to use the short named keys for this instead of the full sentence which is why we just do message_key
	T.lastStaffResponse = "Автоответ: [message_key]"
	resolveTicket(N)
	log_game("[C] ипользовал автоответ в ментор-тикете [ticket_owner]: [response_phrases[message_key]]")
