// Drone
/obj/item/robot_module/drone/Initialize(mapload)
	basic_modules |= list(
		/obj/item/holosign_creator/atmos/basic,
	)
	return ..()

// Robots
/obj/item/robot_module/engineering/Initialize(mapload)
	basic_modules |= list(
		/obj/item/lightreplacer/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/holosign_creator/atmos/basic,
	)
	special_rechargables |= list(
		/obj/item/lightreplacer/cyborg,
	)
	return ..()

/obj/item/robot_module/medical/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/rlf,
	)
	return ..()

/obj/item/robot_module/butler/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/eftpos/cyborg,
	)
	return ..()

/obj/item/robot_module/janitor/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
	)
	return ..()

/obj/item/robot_module/security/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
	)
	return ..()

// Syndicate
/obj/item/robot_module/syndicate_medical/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/rlf,
	)
	return ..()

/obj/item/robot_module/syndicate_saboteur/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gripper/engineering,
		/obj/item/holosign_creator/atmos/better,
	)
	return ..()


// Admin Spawns
/obj/item/robot_module/deathsquad/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/pinpointer/operative/nad,
	)
	return ..()

/obj/item/robot_module/destroyer/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/pinpointer,
		/obj/item/pinpointer/operative/nad,
	)
	return ..()

/obj/item/robot_module/combat/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/pinpointer/operative/nad,
	)
	return ..()

// Aliens
/obj/item/robot_module/alien/hunter/Initialize(mapload)
	basic_modules |= list(
		/obj/item/gps/cyborg,
		/obj/item/pinpointer/operative/nad,
	)
	return ..()
