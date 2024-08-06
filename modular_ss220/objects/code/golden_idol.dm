#define IDOL_NOUN_LIFESPAN "GAD"
#define IDOL_NOUN_HEAT "HORA"
#define IDOL_NOUN_MATTER "BRIN"
#define IDOL_NOUN_AIR "SUKB"	// There is no info about how AIR noun sounds
#define IDOL_NOUN_EMPTY "пусто"

#define IDOL_VERB_DECREASE "NAGANA"
#define IDOL_VERB_INCREASE "TEGANA"

/obj/item/golden_idol
	name = "золотой идол"
	desc = "Причудливая статуэтка, отлитая из бронзы и покрытая золотом. На её спине расположено три глифа и небольшой рычажок. Один взгляд на идол пробуждает в вас желание власти."
	icon = 'modular_ss220/objects/icons/golden_idol.dmi'
	icon_state = "red"
	var/idol_verb = IDOL_VERB_DECREASE
	var/idol_noun = IDOL_NOUN_LIFESPAN
	var/idol_addition = IDOL_NOUN_EMPTY
	var/idol_in_use = FALSE
	var/idol_storage = null

/obj/item/golden_idol/examine(mob/user)
	. = ..()
	. += span_notice("Используйте в руке чтобы изменить глагол. Сейчас активен ") + span_boldnotice(idol_verb)
	. += span_notice("Используйте альт-клик чтобы изменить существительное. Сейчас активно ") + span_boldnotice(idol_noun)
	. += span_notice("Используйте контрл-клик чтобы изменить дополнение. Сейчас активно ") + span_boldnotice(idol_addition)

// Glif changing

/obj/item/golden_idol/attack_self(mob/user)
	if(idol_verb == IDOL_VERB_DECREASE)
		idol_verb = IDOL_VERB_INCREASE
	else
		idol_verb = IDOL_VERB_DECREASE
	to_chat(user, span_notice("Вы изменили глиф глагола на [idol_verb]"))

/obj/item/golden_idol/AltClick(mob/user)
	if(!Adjacent(user) || !ishuman(user) || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return

	if(idol_in_use)
		to_chat(user, span_warning("У вас не получается изменить глиф существительного. Идол дрожит от наполняющей его энергии. Вам нужно выпустить ей!"))
		return

	switch(idol_noun)
		if(IDOL_NOUN_LIFESPAN)
			idol_noun = IDOL_NOUN_HEAT
		if(IDOL_NOUN_HEAT)
			idol_noun = IDOL_NOUN_MATTER
		if(IDOL_NOUN_MATTER)
			idol_noun = IDOL_NOUN_AIR
		if(IDOL_NOUN_AIR)
			idol_noun = IDOL_NOUN_LIFESPAN
	to_chat(user, span_notice("Вы изменили глиф существительного на [idol_noun]"))

/obj/item/golden_idol/CtrlClick(mob/user)
	..()
	if(!Adjacent(user) || !ishuman(user) || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return

	if(loc != user)
		return

	if(idol_in_use)
		to_chat(user, span_warning("У вас не получается изменить глиф дополнения. Идол дрожит от наполняющей его энергии. Вам нужно выпустить ей!"))
		return

	switch(idol_addition)
		if(IDOL_NOUN_LIFESPAN)
			idol_addition = IDOL_NOUN_HEAT
		if(IDOL_NOUN_HEAT)
			idol_addition = IDOL_NOUN_MATTER
		if(IDOL_NOUN_MATTER)
			idol_addition = IDOL_NOUN_AIR
		if(IDOL_NOUN_AIR)
			idol_addition = IDOL_NOUN_EMPTY
		if(IDOL_NOUN_EMPTY)
			idol_addition = IDOL_NOUN_LIFESPAN
	to_chat(user, span_notice("Вы изменили глиф дополнения на [idol_addition]"))

// Spells

/obj/item/golden_idol/update_icon_state()
	if(idol_in_use)
		icon_state = "blue"
		return
	icon_state = "red"

/obj/item/golden_idol/proc/set_storage(new_value)
	idol_storage = new_value

// Used to get not read-only air mixture
/datum/milla_safe/golden_idol_get_air/on_run(obj/item/golden_idol/idol, turf/L)
	var/datum/gas_mixture/env = get_turf_air(L)
	idol.set_storage(env.remove(env.total_moles()))

/obj/item/golden_idol/afterattack(atom/target, mob/user, proximity, params)
	if(!proximity)
		return
	if(idol_in_use && idol_verb == IDOL_VERB_DECREASE)
		to_chat(user, span_warning("У вас не получается активировать идол. Он дрожит от наполняющей его энергии. Вам нужно выпустить её!"))
		return
	if(!idol_in_use && idol_verb == IDOL_VERB_INCREASE)
		to_chat(user, span_warning("Вы нажимаете на рычажок идола, но ничего не происходит. Вы что-то делаете не так."))
		return

	// Hold items
	if(idol_noun == IDOL_NOUN_MATTER && idol_addition == IDOL_NOUN_EMPTY)
		if(idol_in_use)
			if(isnull(idol_storage))
				return
			if(!isturf(target.loc) && !isturf(target))
				return
			if(!isitem(idol_storage))
				return
			var/obj/item/I = idol_storage
			I.forceMove(get_turf(target))
			idol_storage = null
			visible_message(span_warning("[I] появляется в луче света, идущем от самоцвета в золотом идоле."))
			playsound(src, 'sound/items/pshoom.ogg', 50, TRUE)
			idol_in_use = FALSE
		else
			if(!isitem(target))
				return
			var/obj/item/I = target
			I.forceMove(src)
			idol_storage = I
			visible_message(span_warning("[I] растворяется в луче света, идущем от самоцвета в золотом идоле."))
			playsound(src, 'sound/items/pshoom.ogg', 50, TRUE)
			idol_in_use = TRUE

	// Transfer Air
	else if(idol_noun == IDOL_NOUN_AIR && idol_addition == IDOL_NOUN_EMPTY)
		if(idol_in_use)
			var/turf/simulated/L = get_turf(target)
			var/datum/gas_mixture/air = idol_storage
			if(!istype(air) || !istype(L))
				return
			L.blind_release_air(air)
			visible_message(span_warning("Идол выплёскивает волну газа!."))
			playsound(src, 'sound/items/pshoom.ogg', 50, TRUE)
			idol_in_use = FALSE
		else
			var/turf/simulated/L = get_turf(target)
			if(!istype(L))
				return
			var/datum/milla_safe/golden_idol_get_air/milla = new()
			milla.invoke_async(src, L)
			visible_message(span_warning("Идол поглощает газ вокруг себя!"))
			playsound(src, 'sound/items/pshoom.ogg', 50, TRUE)
			idol_in_use = TRUE
	else
		to_chat(user, span_warning("Вы нажимаете на рычажок идола, но ничего не происходит. Вы что-то делаете не так."))
	update_icon_state()



#undef IDOL_NOUN_LIFESPAN
#undef IDOL_NOUN_HEAT
#undef IDOL_NOUN_MATTER
#undef IDOL_NOUN_AIR
#undef IDOL_NOUN_EMPTY

#undef IDOL_VERB_DECREASE
#undef IDOL_VERB_INCREASE
