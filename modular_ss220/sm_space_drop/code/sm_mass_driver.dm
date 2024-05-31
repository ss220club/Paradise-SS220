/obj/machinery/mass_driver/sm_mass_driver
	name = "supermatter mass driver"
	desc = "Запускает кристалл Суперматерии бороздить просторы космоса."
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	id_tag = "SpaceDropSM"

// You can't manipulate with mass driver to avoid grief
/obj/machinery/mass_driver/sm_mass_driver/screwdriver_act()
	return

/obj/machinery/mass_driver/sm_mass_driver/multitool_act()
	return

/obj/machinery/mass_driver/sm_mass_driver/emp_act()
	return

/obj/machinery/mass_driver/sm_mass_driver/emag_act()
	return
