/obj/machinery/sm_mass_driver
	name = "Пусковая установка СМ"
	desc = "Запускает СМ бороздить просторы космоса."
	icon = 'icons/obj/objects.dmi'
	icon_state = "mass_driver"
	anchored = TRUE
	idle_power_consumption = 2
	active_power_consumption = 50
	// ADD GREG
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	// ADD GREG

	/// Throw power
	var/power = 1
	/// ID tag, used for buttons
	var/id_tag = "SpaceDropSM"
	/// This is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.
	var/drive_range = 50

/obj/machinery/sm_mass_driver/proc/drive(amount)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(500 * power)
	var/O_limit = 0
	var/atom/target = get_edge_target_turf(src, dir)
	for(var/atom/movable/O in loc)
		if((!O.anchored && O.move_resist != INFINITY) || ismecha(O)) //Mechs need their launch platforms. Also checks if something is anchored or has move resist INFINITY, which should stop ghost flinging.
			O_limit++

			if(O_limit >= 20)//so no more than 20 items are sent at a time, probably for counter-lag purposes
				break

			use_power(500)
			var/coef = 1
			if(emagged)
				coef = 5
			INVOKE_ASYNC(O, TYPE_PROC_REF(/atom/movable, throw_at), target, (drive_range * power * coef), (power * coef))

	flick("mass_driver1", src)

/obj/machinery/sm_mass_driver/multitool_act(mob/user, obj/item/I)
