// drone

/obj/item/robot_module/drone/Initialize(mapload)
	. = ..()
	basic_modules.Remove(/obj/item/gripper_engineering)
	basic_modules |= list(
		/obj/item/gripper,
		/obj/item/holosign_creator/atmos,
		)

// robots

/obj/item/robot_module/engineering/Initialize(mapload)
	. = ..()
	basic_modules.Remove(/obj/item/gripper_engineering)
	basic_modules |= list(
		/obj/item/gripper,
		/obj/item/inflatable/cyborg,
		/obj/item/inflatable/cyborg/door,
		/obj/item/gps/cyborg,
		)

/obj/item/robot_module/medical/Initialize(mapload)
	. = ..()
	basic_modules.Remove(/obj/item/gripper_medical, /obj/item/reagent_containers/borghypo)
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/rlf,
		/obj/item/gripper/medical,
		/obj/item/reagent_containers/borghypo/basic,
		)

/obj/item/robot_module/butler/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/gripper/service,
		/obj/item/eftpos/cyborg,
		)
// надувные стены
/obj/item/inflatable/cyborg
	name = "надувная стена"
	desc = "Сложенная надувная стена, которая при активации быстро расширяется до большой кубической мембраны."
	var/power_use = 400
	var/structure_type = /obj/structure/inflatable

/obj/item/robot_module/janitor/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		)
/obj/item/inflatable/cyborg/door
	name = "надувной шлюз"
	desc = "Сложенный надувной шлюз, который при активации быстро расширяется в простую дверь."
	icon_state = "folded_door"
	power_use = 600
	structure_type = /obj/structure/inflatable/door

/obj/item/robot_module/miner/Initialize(mapload)
/obj/item/inflatable/cyborg/examine(mob/user)
	. = ..()
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		)
	. += span_notice("Как синтетик, вы можете восстановить их в <b>cyborg recharger</b>")

/obj/item/robot_module/security/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		)
/obj/item/inflatable/cyborg/attack_self(mob/user)
	if(locate(/obj/structure/inflatable) in get_turf(user))
		to_chat(user, span_warning("Здесь уже есть надувная стена!"))
		return FALSE

// Syndicate
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, span_notice("Вы надули [name]"))
	var/obj/structure/inflatable/R = new structure_type(user.loc)
	transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	useResource(user)

/obj/item/robot_module/syndicate/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/gripper/nuclear,
		)
/obj/item/inflatable/cyborg/proc/useResource(mob/user)
	if(!isrobot(user))
		return FALSE
	var/mob/living/silicon/robot/R = user
	if(R.cell.charge < power_use)
		to_chat(user, span_warning("Недостаточно заряда!"))
		return FALSE
	return R.cell.use(power_use)

/obj/item/robot_module/syndicate_medical/Initialize(mapload)
//Небольшой багфикс "непрозрачного открытого шлюза"
/obj/structure/inflatable/door/operate()
	. = ..()
	basic_modules.Remove(/obj/item/gripper_medical)
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/rlf,
		/obj/item/gripper/medical,
		/obj/item/gripper/nuclear,
	)

/obj/item/robot_module/syndicate_saboteur/Initialize(mapload)
	. = ..()
	basic_modules.Remove(/obj/item/gripper_engineering)
	basic_modules |= list(
		/obj/item/gripper,
		/obj/item/gripper/nuclear,
		/obj/item/holosign_creator/atmos,
	)


// Admin Spawns

/obj/item/robot_module/deathsquad/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/gripper/nuclear,
		/obj/item/gps/cyborg,
		/obj/item/pinpointer/operative/nad,
		)

/obj/item/robot_module/destroyer/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/gripper/nuclear,
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/pinpointer,
		/obj/item/pinpointer/operative/nad,
	)

/obj/item/robot_module/combat/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/gripper/nuclear,
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/pinpointer/operative/nad,
	)

// Aliens
/obj/item/robot_module/alien/hunter/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/crowbar/cyborg,
		/obj/item/gps/cyborg,
		/obj/item/pinpointer/operative/nad,
	)
	opacity = FALSE
