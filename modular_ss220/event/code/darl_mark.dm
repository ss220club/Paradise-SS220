GLOBAL_VAR_INIT(candidates_left, 0)

/datum/spell/touch/dark_mark
	name = "Наделить чёрной меткой"
	desc = "Наделяет цель заклинания чёрной меткой и кандидатам в капитаны"
	hand_path = /obj/item/melee/touch_attack/dark_mark
	action_icon_state = "skeleton"
	clothes_req = FALSE

	base_cooldown = 1 SECONDS

/obj/item/melee/touch_attack/dark_mark
	name = "зуб бегемота"
	desc = "что-то странное"
	icon = 'icons/obj/weapons/magical_weapons.dmi'
	icon_state = "fleshtostone"

	catchphrase = "Чёрная метка!"
	on_use_sound = null;
	attached_spell = /datum/spell/touch/dark_mark

/obj/item/melee/touch_attack/dark_mark/customised_abstract_text(mob/living/carbon/owner)
	return SPAN_WARNING("[owner.p_their(TRUE)] [owner.l_hand == src ? "левая рука" : "правая рука"] покрыта злобным чёрным дымом.")


/obj/item/melee/touch_attack/dark_mark/after_attack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

	if(!proximity_flag || target == user || blocked_by_antimagic || !ishuman(target) || !iscarbon(user) || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED)) //clowning around after touching yourself would unsurprisingly, be bad
		return


	var/mob/living/carbon/human/H = target

	for(var/obj/item/organ/internal/i in H.internal_organs)
		if(istype(i, /obj/item/organ/internal/cyberimp/arm/katana/dark_mark))
			to_chat(user, SPAN_WARNING("ДЕБИЛ, ТЫ УЖЕ ВЫДАЛ ЕМУ МЕТКУ!!!"))
			return

	H.give_dark_mark()
	handle_delete(user)


/mob/living/carbon/human/proc/give_dark_mark()

	var/list/string_list = list()
	string_list += "<b>Хриплый голос в вашей голове</b>\n"
	string_list += "1. Вам была оказана великая честь - стать \"ЕЁ\" капитаном.\n"
	string_list += "2. Соберите вокруг себя верную команду, продемонстрируйте лидерские навыки.\n"
	string_list += "3. Приготовитесь отстоять своё первенство среди остальных кандидатов.\n"
	to_chat(src, SPAN_BIGGERDANGER(string_list.Join()))

	GLOB.candidates_left += 1

	var/obj/item/organ/internal/cyberimp/arm/katana/dark_mark/mark = new()
	mark.give_mark(src)


/obj/item/organ/internal/cyberimp/arm/katana/dark_mark
	var/list/sound_names = list('modular_ss220/event/sound/bell_1.ogg', 'modular_ss220/event/sound/bell_2.ogg')

/obj/item/organ/internal/cyberimp/arm/katana/dark_mark/proc/give_mark(mob/user)
	RegisterSignal(user, COMSIG_MOB_DEATH, PROC_REF(user_death))
	playsound(user, 'modular_ss220/event/sound/begemore_rar.ogg', 50, TRUE)
	insert(user)

/obj/item/organ/internal/cyberimp/arm/katana/dark_mark/user_death_async(mob/user)
	Retract()

	GLOB.candidates_left -= 1
	var/text = "Кандидат [user.real_name] погибает. Кандидатов осталось [GLOB.candidates_left]."
	GLOB.begemot.Announce(text, "Ещё один кандидат выбыл из гонки", pick(sound_names), msg_sanitized = TRUE)

	user.visible_message(SPAN_WARNING("[user] рассыпается в пыль!"),
	SPAN_USERDANGER("Ваша душа теперь часть корабля!"))
	qdel()
	remove(user)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, dust)), 1 SECONDS)


/obj/item/organ/internal/cyberimp/arm/katana/dark_mark/remove(mob/living/carbon/M, special)
	GLOB.candidates_left -= 1
	var/text = "Кандидат [M.real_name] Трусливо сбегает из гонки! Кандидатов осталось [GLOB.candidates_left]."
	GLOB.begemot.Announce(text, "Ещё один кандидат выбыл из гонки", 'modular_ss220/event/sound/begemore_rar.ogg', msg_sanitized = TRUE)

	UnregisterSignal(M, COMSIG_MOB_DEATH)
	. = ..()


