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
/obj/item/sledgehammer
	name = "sledgehammer"
	desc = "Большая и тяжелая кувалда из пластали для разрушения стен. Может также быть использована для разрушения горных пород."
	icon = 'modular_ss220/balance/code/items/icons/sledgehammer.dmi'
	icon_state = "sledgehammer0"
	base_icon_state = "sledgehammer"
	worn_icon = 'modular_ss220/balance/code/items/icons/melee_back.dmi'
	worn_icon_state = "sledgehammer"
	lefthand_file = 'modular_ss220/balance/code/items/icons/inhands/lefthand.dmi'
	righthand_file = 'modular_ss220/balance/code/items/icons/inhands/righthand.dmi'
	slot_flags = ITEM_SLOT_BACK
	force = 10
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 3
	attack_verb = list("smashes", "crushes", "breaches")
	var/force_unwielded = 10
	var/force_wielded = 20
	// кулдаун между ударами (в тиках BYOND: 1 сек = 10)
	var/next_attack_time = 0


/obj/item/sledgehammer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/two_handed, \
		force_wielded = force_wielded, \
		force_unwielded = force_unwielded, \
		icon_wielded = "[base_icon_state]1")


/obj/item/sledgehammer/update_icon_state()
	icon_state = "[base_icon_state]0"


/obj/item/sledgehammer/afterattack__legacy__attackchain(atom/target, mob/user, proximity)
	. = ..()

	if(!proximity)
		return

	//КД 2 секунды
	if(world.time < next_attack_time)
		return

	next_attack_time = world.time + 2 SECONDS

	//двуручный хват
	if(!HAS_TRAIT(src, TRAIT_WIELDED))
		return


	// УДАР ПО СТЕНАМ
	if(istype(target, /turf/simulated/wall))
		var/turf/simulated/wall/W = target

		user.do_attack_animation(W)

		user.visible_message(
			"<span class='danger'>[user] с силой бьёт [W] [src]!</span>",
			"<span class='danger'>Вы наносите мощный удар по [W]!</span>"
		)

		playsound(src.loc, 'sound/effects/bang.ogg', 75, TRUE)
		W.take_damage(20, BRUTE)


	// УДАР ПО ДВЕРЯМ
	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/D = target

		user.do_attack_animation(D)

		user.visible_message(
			"<span class='danger'>[user] с размаху бьёт по [D] кувалдой!</span>",
			"<span class='danger'>Вы наносите мощный удар по двери!</span>"
		)

		playsound(src.loc, 'sound/effects/bang.ogg', 75, TRUE)
		D.take_damage(60, BRUTE)


/obj/item/sledgehammer/tactical
	name = "D-4 tactical breaching hammer"
	desc = "Металлопластиковый композитный молот для создания брешей в стенах или уничтожения различных структур."
	icon_state = "sledgehammer_tactical0"
	base_icon_state = "sledgehammer_tactical"
	worn_icon_state = "sledgehammer_tactical"
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	force_wielded = 25
