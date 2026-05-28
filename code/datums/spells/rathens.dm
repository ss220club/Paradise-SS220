/datum/spell/rathens
	name = "Rathen's Secret"
	desc = "Создает вокруг себя мощную ударную волну, которая силой вырывает у врагов аппендикс, а иногда и конечности."
	base_cooldown = 50 SECONDS
	invocation = "APPEN NATH!"
	invocation_type = "shout"
	cooldown_min = 20 SECONDS
	action_icon_state = "lungpunch"

/datum/spell/rathens/create_new_targeting()
	var/datum/spell_targeting/targeted/T = new()
	T.max_targets = INFINITY
	return T

/datum/spell/rathens/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/human/H in targets)
		if(H.can_block_magic(antimagic_flags))
			continue
		var/datum/effect_system/smoke_spread/s = new
		s.set_up(5, FALSE, H)
		s.start()
		var/obj/item/organ/internal/appendix/A = H.get_int_organ(/obj/item/organ/internal/appendix)
		if(A)
			A.remove(H)
			A.forceMove(get_turf(H))
			spawn()
				A.throw_at(get_edge_target_turf(H, pick(GLOB.alldirs)), rand(1, 10), 5)
			H.visible_message(SPAN_DANGER("[capitalize(A.declent_ru(NOMINATIVE))] [H.declent_ru(GENITIVE)] вылетает из тела в результате магического взрыва!"),\
							SPAN_DANGER("[capitalize(A.declent_ru(NOMINATIVE))] вылетает из вашего тела в магическом взрыве!"))
			H.KnockDown(4 SECONDS)
		else
			var/obj/effect/decal/cleanable/blood/gibs/G = new/obj/effect/decal/cleanable/blood/gibs(get_turf(H))
			spawn()
				G.throw_at(get_edge_target_turf(H, pick(GLOB.alldirs)), rand(1, 10), 5)
			H.apply_damage(10, BRUTE, "chest")
			to_chat(H, SPAN_USERDANGER("У вас больше нет аппендикса, его что-то вырвало! Черт возьми, что это было?"))
			H.KnockDown(6 SECONDS)
			for(var/obj/item/organ/external/E in H.bodyparts)
				if(istype(E, /obj/item/organ/external/head))
					continue
				if(istype(E, /obj/item/organ/external/chest))
					continue
				if(istype(E, /obj/item/organ/external/groin))
					continue
				if(prob(7))
					to_chat(H, SPAN_USERDANGER("Вам оторвало [E.declent_ru(ACCUSATIVE)] взрывом!"))
					E.droplimb(1, DROPLIMB_SHARP, 0, 1)
