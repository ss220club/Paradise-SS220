/datum/action/innate/cult
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	background_icon_state = "bg_cult"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_CONSCIOUS
	buttontooltipstyle = "cult"

/datum/action/innate/cult/IsAvailable()
	if(!iscultist(owner))
		return FALSE
	return ..()


//Comms
/datum/action/innate/cult/comm
	name = "Общение"
	desc = "Прошепченные слова услышат все культисты.<br><b>Внимание:</b>Рядомстоящие некультисты всё равно вас услышат."
	button_icon_state = "cult_comms"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/innate/cult/comm/Activate()
	var/input = stripped_input(usr, "Выберите сообщения для других аколитов.", "Голос Крови", "")
	if(!input || !IsAvailable())
		return
	cultist_commune(usr, input)
	return

/datum/action/innate/cult/comm/proc/cultist_commune(mob/living/user, message)
	if(!user || !message)
		return

	if(user.holy_check())
		return

	if(!user.can_speak())
		to_chat(user, "<span class='warning'>Вы не можете говорить!</span>")
		return

	if(HAS_TRAIT(user, TRAIT_MUTE) || user.mind.miming) //Under vow of silence/mute?
		user.visible_message("<span class='notice'>[user], кажется, шепчет себе что-то.</span>",
		"<span class='notice'>Вы шепчете себе что-то.</span>") //Make them do *something* abnormal.
		sleep(10)
	else
		user.whisper("O bidai nabora se[pick("'","`")]sma!") // Otherwise book club sayings.
		sleep(10)
		user.whisper(message) // And whisper the actual message

	var/title
	var/large = FALSE
	var/living_message
	if(istype(user, /mob/living/simple_animal/demon/slaughter/cult)) //Harbringers of the Slaughter
		title = "<b>Предвестник резни</b>"
		large = TRUE
	else
		title = "<b>[(isconstruct(user) ? "Конструкт" : isshade(user) ? "" : "Аколит")] [user.real_name]</b>"

	living_message = "<span class='cult[(large ? "large" : "speech")]'>[title]: [message]</span>"
	for(var/mob/M in GLOB.player_list)
		if(iscultist(M))
			to_chat(M, living_message)
		else if((M in GLOB.dead_mob_list) && !isnewplayer(M))
			to_chat(M, "<span class='cult[(large ? "large" : "speech")]'>[title] ([ghost_follow_link(user, ghost=M)]): [message]</span>")

	log_say("(CULT) [message]", user)

/datum/action/innate/cult/comm/spirit
	name = "Духовное сообщение"
	desc = "Передаёт сообщение из духовного мира для всех культистов."

/datum/action/innate/cult/comm/spirit/IsAvailable()
	return TRUE

/datum/action/innate/cult/comm/spirit/cultist_commune(mob/living/user, message)

	var/living_message
	if(!message)
		return
	var/title = "The [user.name]"
	living_message = "<span class='cultlarge'>[title]: [message]</span>"

	for(var/mob/M in GLOB.player_list)
		if(iscultist(M))
			to_chat(M, living_message)
		else if((M in GLOB.dead_mob_list) && !isnewplayer(M))
			to_chat(M, "<span class='cultlarge'>[title] ([ghost_follow_link(user, ghost=M)]): [message]</span>")


//Objectives
/datum/action/innate/cult/check_progress
	name = "Изучение Завесы"
	button_icon_state = "tome"
	desc = "Проверьте прогресс культа и текущую цель."
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/innate/cult/check_progress/New()
	if(SSticker.mode)
		button_icon_state = SSticker.cultdat.tome_icon
	..()

/datum/action/innate/cult/check_progress/IsAvailable()
	if(iscultist(owner) || isobserver(owner))
		return TRUE
	return FALSE

/datum/action/innate/cult/check_progress/Activate()
	if(!IsAvailable())
		return
	if(SSticker && SSticker.mode)
		SSticker.mode.cult_objs.study(usr, TRUE)
	else
		to_chat(usr, "<span class='cultitalic'>Вам не удалось изучить Завесу. (Этого не должно происходить, adminhelp и/или орите на кодера)</span>")


//Draw rune
/datum/action/innate/cult/use_dagger
	name = "Начертить Кровавую Руну"
	desc = "Используйте ритуальный кинжал для начертания мощных рун"
	button_icon_state = "blood_dagger"

/datum/action/innate/cult/use_dagger/Grant()
	if(SSticker.mode)
		button_icon_state = SSticker.cultdat.dagger_icon
	..()

/datum/action/innate/cult/use_dagger/override_location()
	button.ordered = FALSE
	button.screen_loc = "6:157,4:-2"
	button.moved = "6:157,4:-2"

/datum/action/innate/cult/use_dagger/Activate()
	var/obj/item/melee/cultblade/dagger/D = owner.find_item(/obj/item/melee/cultblade/dagger)
	if(D)
		owner.remove_from_mob(D)
		owner.put_in_hands(D)
		D.attack_self(owner)
	else
		to_chat(usr, "<span class='cultitalic'>Похоже, у вас нет с собой ритуального кинжала. Если вам нужен новый, подготовьте и используйте заклинание 'Призыв Кинжала'.</span>")
