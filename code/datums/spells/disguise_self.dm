/datum/spell/disguise_self
	name = "Disguise Self"
	desc = "Позволяет замаскироваться под члена экипажа в зависимости от вашего местоположения, а также изменяет ваш голос. Требует две секунды на применение в неподвижном состоянии. Иллюзия не сработает при детальном осмотре, но может обмануть при беглом взгляде. Маскировка спадёт, если вас атакуют, толкнут или бросят в вас предмет."

	base_cooldown = 3 SECONDS
	clothes_req = FALSE
	level_max = 0 //cannot be improved
	action_icon_state = "disguise_self"
	sound = null

/datum/spell/disguise_self/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/disguise_self/cast(list/targets, mob/user = usr)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user

	H.emote("spin")
	to_chat(H, SPAN_NOTICE("Вы начинаете крутиться на месте и применять [src.name]..."))
	if(do_after(H, 2 SECONDS, FALSE, H))
		finish_disguise(H)
		return TRUE
	else
		H.slip("your own foot", 1 SECONDS, 0, 0, 1, "trip")
		to_chat(H, SPAN_DANGER("Вы должны стоять неподвижно, чтобы применить [src.name]!"))
		return FALSE

/datum/spell/disguise_self/proc/finish_disguise(mob/living/carbon/human/H)
	H.apply_status_effect(STATUS_EFFECT_MAGIC_DISGUISE)
	var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread
	smoke.set_up(4, FALSE, H.loc)
	smoke.start()
