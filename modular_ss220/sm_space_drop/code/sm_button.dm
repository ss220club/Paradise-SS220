
//////////////////////////////////////
//			СБССМ Кнопки			//
//////////////////////////////////////

/obj/machinery/driver_button/sm_drop_button
	name = "Кнопка сброса СМ"
	desc = "Кнопка для экстренного выбраса СМ в космос"
	icon = 'modular_ss220/sm_space_drop/icons/sm_buttons.dmi'
	icon_state = "launcherbtt"
	anchored = TRUE
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, rad = 100, fire = 90, acid = 70)
	idle_power_consumption = 2
	active_power_consumption = 4
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	id_tag = "SpaceDropSM"

/obj/machinery/driver_button/sm_drop_button/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(active)
		return

	add_fingerprint(user)

	if(!allowed(usr))
		return

	use_power(5)

	for(var/obj/machinery/atmospherics/supermatter_crystal/engine/crystal in SSair.atmos_machinery)
		if(crystal.id_tag == id_tag)
			crystal.anchored = FALSE
			break

	launch_sequence()

/obj/machinery/driver_button/drop_sm/multitool_act(mob/user, obj/item/I)
  return FALSE
