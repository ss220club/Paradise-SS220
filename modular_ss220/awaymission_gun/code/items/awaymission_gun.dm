/obj/item/gun/energy/laser/awaymission_aeg
	name = "Wireless Energy Gun"
	desc = "An energy gun that recharges wirelessly during away missions. Does not work outside the gate."
	icon = 'modular_ss220/awaymission_gun/icons/items/energy.dmi'
	lefthand_file = 'modular_ss220/awaymission_gun/icons/inhands/lefthand.dmi'
	righthand_file = 'modular_ss220/awaymission_gun/icons/inhands/righthand.dmi'
	icon_state = "laser_gate"
	item_state = "nucgun"
	force = 10
	origin_tech = "combat=5;magnets=3;powerstorage=4"
	selfcharge = TRUE // Selfcharge is enabled and disabled, and used as the away mission tracker
	can_charge = 0
	emagged = FALSE

/obj/item/gun/energy/laser/awaymission_aeg/Initialize(mapload)
	. = ..()
	// Force update it incase it spawns outside an away mission and shouldnt be charged
	onTransitZ(new_z = loc.z)

/obj/item/gun/energy/laser/awaymission_aeg/onTransitZ(old_z, new_z)
	if(emagged)
		return

	if(is_away_level(new_z))
		if(ismob(loc))
			to_chat(loc, span_notice("Ваш [name] активируется, начиная потреблять энергию от ближайшего беспроводного источника питания."))
		selfcharge = TRUE
	else
		if(selfcharge)
			if(ismob(loc))
				to_chat(loc, span_danger("Ваш [name] деактивируется, так как он находится вне зоны действия источника питания.</span>"))
			cell.charge = 0
			selfcharge = FALSE
			update_icon()

/obj/item/gun/energy/laser/awaymission_aeg/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.unEquip(src)

/obj/item/gun/energy/laser/awaymission_aeg/emag_act(mob/user)
	. = ..()
	if(emagged)
		return
	if(user)
		if(prob(50))
			user.visible_message(span_warning("От [name] летят искры!"), span_notice("Вы взломали [name], что привело к перезаписи протоколов безопасности. Устройство может быть использовано вне ограничений"))
			playsound(loc, 'sound/effects/sparks4.ogg', 30, 1)
			do_sparks(5, 1, src)
			emagged = TRUE
			selfcharge = TRUE
		else
			user.visible_message(span_warning("От [name] летят искры... Он сейчас взорвётся!"), span_notice("Ой... Что-то пошло не так!"))
			do_sparks(5, 1, src)
			update_mob()
			explosion(loc, -1, 0, 2)
			qdel(src)


// GUNS
/obj/item/gun/energy/laser/awaymission_aeg/rnd
	name = "Exploreverse Mk I"
	desc = "Первый прототип оружия с миниатюрным реактором для исследований в крайне отдаленных секторах. \
	\nДанную модель невозможно подключить к зарядной станции, во избежание истощения подключенных источников питания, \
	в связи с протоколами безопасности, опустошающие заряд при нахождении вне предназначенных мест использования устройств."
	origin_tech = "combat=2;magnets=2;powerstorage=3"
	force = 10

