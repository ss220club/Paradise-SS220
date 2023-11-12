
//////////////////////////////////////
//			SMDS Button				//
//////////////////////////////////////

/obj/machinery/sm_drop_controll_buttons
	name = "SM Drop Controll"
	desc = "Кнопка для экстренного выбраса СМ в космос"
	icon = 'modular_ss220/sm_space_drop/icon/sm_buttons.dmi'
	icon_state = "sm_button_off"
	anchored = TRUE
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, rad = 100, fire = 90, acid = 70)
	idle_power_consumption = 2
	active_power_consumption = 4
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	/// ID tag of the driver to hook to
	var/id_tag = "SpaceDropSM"
	/// Are we active?
	var/active = FALSE
	/// Range of drivers + blast doors to hit
	// Без этой залупы ошибки в оснвовном коде т.к. есть еше кнопки что использую эту залупу для ограничения действия что работает не коректно
	var/range = 7

/obj/machinery/button/indestructible
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/sm_drop_controll_buttons/Initialize(mapload, place_dir)
	. = ..()
	switch(place_dir)
		if(NORTH)
			pixel_y = 25
		if(SOUTH)
			pixel_y = -25
		if(EAST)
			pixel_x = 25
		if(WEST)
			pixel_x = -25

/obj/machinery/sm_drop_controll_buttons/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/sm_drop_controll_buttons/attack_ghost(mob/user)
	if(user.can_advanced_admin_interact())
		attack_hand(user)

/obj/machinery/sm_drop_controll_buttons/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(active)
		return

	add_fingerprint(user)

	use_power(5)
	// ADD GREG
	for(var/obj/machinery/atmospherics/supermatter_crystal/engine/M)
		if(M.id_tag == id_tag)
			M.anchored = FALSE
	// ADD GREG

	// Start us off
	launch_sequence()


/obj/machinery/sm_drop_controll_buttons/proc/launch_sequence()
	active = TRUE
	icon_state = "sm_button_on_animated"
	// Time sequence
	// OPEN DOORS
	// Wait 2 seconds
	// LAUNCH
	// Wait 5 seconds
	// CLOSE
	// Then make not active

	for(var/obj/machinery/door/poddoor/M)
		if(M.id_tag == id_tag && !M.protected)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door, open))
	// 2 seconds after previous invocation

	for(var/obj/machinery/sm_mass_driver/M)
		if(M.id_tag == id_tag)
			addtimer(CALLBACK(M, TYPE_PROC_REF(/obj/machinery/sm_mass_driver, drive)), 2 SECONDS)

	// We want this 5 seconds after open, so the delay is 7 seconds from this proc

	for(var/obj/machinery/door/poddoor/M)
		if(M.id_tag == id_tag && !M.protected)
			addtimer(CALLBACK(M, TYPE_PROC_REF(/obj/machinery/door, close)), 7 SECONDS)

	// And rearm us
	addtimer(CALLBACK(src, PROC_REF(rearm)), 7 SECONDS)

/obj/machinery/sm_drop_controll_buttons/proc/rearm()
	icon_state = "sm_button_off"
	active = FALSE
