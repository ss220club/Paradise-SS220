/datum/spell/disguise_self
	name = "Disguise Self"
	desc = "Замаскируйтесь себя под члена экипажа, в зависимости от вашего текущего местоположения. Активация заклинания занимает две секунды, будучи неподвижным. \
		Иллюзия недостаточно сильна для более тщательного осмотра, но обманывает людей с первого взгляда. \
		Вы потеряете контроль над иллюзией, если на вас нападут, толкнут или бросят в вас предмет, каким бы мягким он ни был."

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
	to_chat(H, "<span class='notice'>Вы наачинаете крутится на месте и копировать [src.declent_ru(GENITIVE)]...</span>")
	if(do_after(H, 2 SECONDS, FALSE, H))
		finish_disguise(H)
		return TRUE
	else
		H.slip("your own foot", 1 SECONDS, 0, 0, 1, "trip")
		to_chat(H, "<span class='danger'>Вы должны стоять неподвижно чтобы скопировать [src.declent_ru(GENITIVE)]!</span>")
		return FALSE

/datum/spell/disguise_self/proc/finish_disguise(mob/living/carbon/human/H)
	H.apply_status_effect(STATUS_EFFECT_MAGIC_DISGUISE)
	var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread
	smoke.set_up(4, FALSE, H.loc)
	smoke.start()
