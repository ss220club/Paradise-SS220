/obj/machinery/mass_driver/sm_mass_driver
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

	id_tag = "SpaceDropSM"

/obj/machinery/sm_mass_driver/multitool_act(mob/user, obj/item/I)
	return FALSE
