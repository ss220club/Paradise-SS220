/obj/item/melee/energy
	var/sharpening_allowed = FALSE

/obj/item/melee/energy/try_sharpen(obj/item/item, amount, max_amount)
	if(!sharpening_allowed)
		return COMPONENT_BLOCK_SHARPEN_BLOCKED
	return ..()

/obj/item/melee/energy/cleaving_saw
	sharpening_allowed = TRUE

/obj/item/melee/classic_baton/on_non_silicon_stun(mob/living/target, mob/living/user)
	target.apply_damage(stamina_damage, STAMINA, blocked = target.run_armor_check(armor_type = ENERGY))

/obj/item/tactical_sledgehammer
	name = "D-4 tactical breaching hammer"
	desc = "Металлопластиковый композитный молот для создания брешей в стенах или уничтожения различных структур."
	icon = 'modular_ss220/balance/code/items/icons/sledgehammer.dmi'
	icon_state = "sledgehammer_tactical0"
	base_icon_state = "sledgehammer_tactical"
	worn_icon = 'modular_ss220/balance/code/items/icons/melee_back.dmi'
	worn_icon_state = "sledgehammer_tactical"
	lefthand_file = 'modular_ss220/balance/code/items/icons/inhands/lefthand.dmi'
	righthand_file = 'modular_ss220/balance/code/items/icons/inhands/righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	force = 10
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 3
	new_attack_chain = TRUE
	var/wall_damage = 25
	var/window_damage = 50
	var/airlock_damage = 100
	var/firedoor_damage = 200

	attack_verb = list(
		"ломает",
		"крушит",
		"прорывает"
	)

	var/force_wielded = 25
	/// Prevents multiple wall breach actions running simultaneously
	var/is_breaching = FALSE


/obj/item/tactical_sledgehammer/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/two_handed, \
		force_wielded = force_wielded, \
		force_unwielded = force, \
		icon_wielded = "[base_icon_state]1")


/obj/item/tactical_sledgehammer/update_icon_state()
	icon_state = "[base_icon_state]0"


/obj/item/tactical_sledgehammer/pre_attack(atom/target, mob/living/user, params)
	if(..())
		return FINISH_ATTACK

	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return

	if(!user.Adjacent(target))
		return

	if(is_breaching)
		return FINISH_ATTACK

	if(istype(target, /turf/simulated/wall))
		var/turf/simulated/wall/wall = target
		return breach_wall(wall, user)

	if(istype(target, /obj/structure/window))
		var/obj/structure/window/window = target
		return breach_window(window, user)

	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/door = target
		return breach_airlock(door, user)

	if(istype(target, /obj/machinery/door/firedoor))
		var/obj/machinery/door/firedoor/firedoor = target
		return breach_firedoor(firedoor, user)


/obj/item/tactical_sledgehammer/proc/breach_wall(turf/simulated/wall/wall, mob/living/user)
	is_breaching = TRUE

	user.visible_message(
		SPAN_WARNING("[user] заносит [src] для удара по [wall]!"),
		SPAN_WARNING("Вы готовитесь нанести мощный удар по [wall].")
	)

	if(!do_after(user, 2 SECONDS, needhand = TRUE, target = wall, progress = TRUE))
		user.visible_message(
			SPAN_WARNING("[user] бросает затею ломать [wall]."),
			SPAN_WARNING("Вы бросаете затею ломать [wall].")
		)

		is_breaching = FALSE
		return FINISH_ATTACK

	is_breaching = FALSE

	if(QDELETED(src) || QDELETED(wall))
		return FINISH_ATTACK

	user.do_attack_animation(wall)

	user.visible_message(
		SPAN_DANGER("[user] с силой бьёт [wall] [src]!"),
		SPAN_DANGER("Вы наносите мощный удар по [wall]!")
	)

	playsound(src.loc, 'sound/effects/bang.ogg', 75, TRUE)
	wall.take_damage(wall_damage)
	return FINISH_ATTACK


/obj/item/tactical_sledgehammer/proc/breach_window(obj/structure/window/window, mob/living/user)
	user.do_attack_animation(window)

	user.visible_message(
		SPAN_DANGER("[user] с треском бьёт по [window] [src]!"),
		SPAN_DANGER("Вы наносите сокрушительный удар по стеклу!")
	)

	playsound(src.loc, 'sound/effects/glasshit.ogg', 75, TRUE)
	window.take_damage(window_damage, BRUTE)
	return FINISH_ATTACK | MELEE_COOLDOWN_PREATTACK


/obj/item/tactical_sledgehammer/proc/breach_airlock(obj/machinery/door/airlock/door, mob/living/user)
	user.do_attack_animation(door)

	user.visible_message(
		SPAN_DANGER("[user] с размаху бьёт по [door] кувалдой!"),
		SPAN_DANGER("Вы наносите мощный удар по двери!")
	)

	playsound(src.loc, 'sound/effects/bang.ogg', 75, TRUE)
	door.take_damage(airlock_damage, BRUTE)
	return FINISH_ATTACK | MELEE_COOLDOWN_PREATTACK


/obj/item/tactical_sledgehammer/proc/breach_firedoor(obj/machinery/door/firedoor/firedoor, mob/living/user)
	user.do_attack_animation(firedoor)

	user.visible_message(
		SPAN_DANGER("[user] с размаху бьёт по [firedoor] кувалдой!"),
		SPAN_DANGER("Вы наносите мощный удар по пожарному шлюзу!")
	)

	playsound(src.loc, 'sound/effects/bang.ogg', 50, TRUE)
	firedoor.take_damage(firedoor_damage, BRUTE)
	return FINISH_ATTACK | MELEE_COOLDOWN_PREATTACK

/obj/item/tactical_sledgehammer/syndicate
	name = "D-4S syndicate breaching hammer"
	desc = "Усиленная версия тактической кувалды для диверсионных операций."
	icon_state = "sledgehammer_syndie0"
	base_icon_state = "sledgehammer_syndie"
	worn_icon_state = "sledgehammer_syndie"
	force = 20
	force_wielded = 35
	throwforce = 20
	wall_damage = 100
	window_damage = 150
	airlock_damage = 150
	firedoor_damage = 400


/obj/item/tactical_sledgehammer/syndicate/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/parry, \
		_stamina_constant = 2, \
		_stamina_coefficient = 0.25, \
		_parryable_attack_types = ALL_ATTACK_TYPES, \
		_parry_cooldown = 0.9 SECONDS, \
		_requires_two_hands = TRUE)
