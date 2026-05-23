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

//Код для кувалды
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
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	attack_verb = list(
		"ломает",
		"крушит",
		"прорывает"
	)

	var/force_unwielded = 10
	var/force_wielded = 25
	/// Cooldown between breaching attacks
	var/next_attack_time = 0


/obj/item/tactical_sledgehammer/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/two_handed, \
		force_wielded = force_wielded, \
		force_unwielded = force_unwielded, \
		icon_wielded = "[base_icon_state]1")


/obj/item/tactical_sledgehammer/update_icon_state()
	icon_state = "[base_icon_state]0"


/obj/item/tactical_sledgehammer/afterattack__legacy__attackchain(atom/target, mob/user, proximity)
	. = ..()

	if(!proximity)
		return

	if(world.time < next_attack_time)
		return

	next_attack_time = world.time + 2 SECONDS

	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return

	if(istype(target, /turf/simulated/wall))
		var/turf/simulated/wall/wall = target

		user.do_attack_animation(wall)

		user.visible_message(
			SPAN_DANGER("[user] с силой бьёт [wall] [src]!"),
			SPAN_DANGER("Вы наносите мощный удар по [wall]!")
		)

		playsound(src.loc, 'sound/effects/bang.ogg', 75, TRUE)

		wall.take_damage(20, BRUTE)

	else if(istype(target, /obj/structure/window))
		var/obj/structure/window/window = target

		user.do_attack_animation(window)

		user.visible_message(
			SPAN_DANGER("[user] с треском бьёт по [window] [src]!"),
			SPAN_DANGER("Вы наносите сокрушительный удар по стеклу!")
		)

		playsound(src.loc, 'sound/effects/glasshit.ogg', 75, TRUE)

		window.take_damage(50, BRUTE)

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/door = target

		user.do_attack_animation(door)

		user.visible_message(
			SPAN_DANGER("[user] с размаху бьёт по [door] кувалдой!"),
			SPAN_DANGER("Вы наносите мощный удар по двери!")
		)

		playsound(src.loc, 'sound/effects/bang.ogg', 75, TRUE)

		door.take_damage(100, BRUTE)
