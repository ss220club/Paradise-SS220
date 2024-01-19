// Makeshift (Lockermech)
/obj/mecha/lockermech
	name = "Шкафомех"
	desc = "Шкафчик с украденными проводами, стойками, электроникой и шлюзовыми сервоприводами, грубо собранными в нечто, напоминающее мех."
	icon = 'modular_ss220/objects/icons/mech.dmi'
	icon_state = "lockermech"
	initial_icon = "lockermech"
	max_integrity = 100 // Its made of scraps
	lights_power = 5
	step_in = 4 // Same speed as a Ripley, for now.
	var/fast_pressure_step_in = 2 //step_in while in normal pressure conditions
	var/slow_pressure_step_in = 4 //step_in while in better pressure conditions
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 0, bomb = 10, rad = 0, fire = 70, acid = 60)
	internal_damage_threshold = 30 //Its got shitty durability
	max_equip = 2 // You only have two arms and the control system is shitty
	wreckage = /obj/structure/mecha_wreckage/lockermech
	var/list/cargo = new
	var/cargo_capacity = 5 // You can fit a few things in this locker but not much.

/obj/mecha/lockermech/go_out()
	..()
	update_icon(UPDATE_OVERLAYS)

/obj/mecha/lockermech/moved_inside(mob/living/carbon/human/H)
	..()
	update_icon(UPDATE_OVERLAYS)

/obj/mecha/lockermech/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	..()
	update_icon(UPDATE_OVERLAYS)

/obj/mecha/lockermech/Move()
	. = ..()
	if(.)
		collect_ore()
	update_pressure()

/obj/mecha/lockermech/proc/collect_ore()
	if(locate(/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/lockermech) in equipment)
		var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in cargo
		if(ore_box)
			for(var/obj/item/stack/ore/ore in range(1, src))
				if(ore.Adjacent(src) && ((get_dir(src, ore) & dir) || ore.loc == loc)) // We can reach it and it's in front of us? grab it!
					ore.forceMove(ore_box)

/obj/mecha/lockermech/proc/update_pressure()
	if(thrusters_active)
		return // Don't calculate this if they have thrusters on, this is calculated right after domove because of course it is

	var/turf/T = get_turf(loc)

	if(lavaland_equipment_pressure_check(T))
		step_in = fast_pressure_step_in
		for(var/obj/item/mecha_parts/mecha_equipment/drill/lockermech/drill in equipment)
			drill.equip_cooldown = initial(drill.equip_cooldown)/2
	else
		step_in = slow_pressure_step_in
		for(var/obj/item/mecha_parts/mecha_equipment/drill/lockermech/drill in equipment)
			drill.equip_cooldown = initial(drill.equip_cooldown)

/obj/mecha/lockermech/Exit(atom/movable/O)
	if(O in cargo)
		return FALSE
	return ..()

/obj/mecha/lockermech/get_stats_part()
	var/output = ..()
	output += "<b>Cargo Compartment Contents:</b><div style=\"margin-left: 15px;\">"
	if(length(cargo))
		for(var/obj/O in cargo)
			output += "<a href='?src=[UID()];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/lockermech/Topic(href, href_list)
	..()
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && (O in cargo))
			occupant_message("<span class='notice'>You unload [O].</span>")
			O.loc = get_turf(src)
			cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - length(cargo)]")
	return

/obj/mecha/lockermech/Destroy()
	for(var/atom/movable/A in cargo)
		A.forceMove(loc)
		step_rand(A)
	cargo.Cut()
	return ..()

/obj/mecha/lockermech/ex_act(severity)
	..()
	for(var/X in cargo)
		var/obj/O = X
		if(prob(30 / severity))
			cargo -= O
			O.forceMove(drop_location())

/obj/mecha/lockermech/emag_act(mob/user)
	if(!emagged)
		emagged = TRUE
		desc += "</br><span class='danger'>The mech's equipment slots spark dangerously!</span>"
	return ..()

// Crafting
/datum/crafting_recipe/lockermech
	name = "Locker Mech"
	result = list(/obj/mecha/lockermech)
	reqs = list(/obj/item/stack/cable_coil = 20,
				/obj/item/stack/sheet/metal = 10,
				/obj/item/storage/toolbox = 2, // For feet
				/obj/item/tank/internals/oxygen = 1, // For air
				/obj/item/airlock_electronics = 1, // You are stealing the motors from airlocks
				/obj/item/extinguisher = 1, // For bastard pnumatics
				/obj/item/c_tube = 1, // To make it airtight
				/obj/item/flashlight = 1, // For the mech light
				/obj/item/stack/tape_roll = 25, // ¯\_(ツ)_/¯
				/obj/item/stock_parts/cell/high = 1,
				/obj/item/stack/rods = 4) // To mount the equipment
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 200
	category = CAT_ROBOT

/datum/crafting_recipe/lockermech_drill
	name = "Locker Mech Exosuit Drill"
	result = list(/obj/item/mecha_parts/mecha_equipment/drill/lockermech)
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/surgicaldrill = 1)
	tools = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_ROBOT

/datum/crafting_recipe/lockermech_clamp
	name = "Locker Mech Exosuit Clamp"
	result = list(/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/lockermech)
	reqs = list(/obj/item/stack/cable_coil = 5,
				/obj/item/stack/sheet/metal = 2,
				/obj/item/wirecutters = 1) // Don't ask, its just for the grabby grabby thing
	tools = list(TOOL_SCREWDRIVER)
	time = 50
	category = CAT_ROBOT

// Wreckage
/obj/structure/mecha_wreckage/lockermech
	name = "\improper Обломки Шкафомеха"
	desc = "Владелец данного изделия, на что он надеялся?..."
	icon = 'modular_ss220/objects/icons/mech.dmi'
	icon_state = "lockermech-broken"

// Equipment
/obj/item/mecha_parts/mecha_equipment/drill/lockermech
	name = "locker mech exosuit drill"
	desc = "Собранная из, скорее всего, краденых деталей, эта дрель не сравнится по эффективности с настоящей."
	equip_cooldown = 60 // Its slow as shit
	force = 10 // Its not very strong
	drill_delay = 15

/obj/item/mecha_parts/mecha_equipment/drill/lockermech/can_attach(obj/mecha/M as obj)
	if(istype(M, /obj/mecha/lockermech))
		if(M.equipment.len < M.max_equip)
			return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/lockermech
	name = "locker mech clamp"
	desc = "Беспорядочное расположение собранных вместе деталей, напоминающее зажим."
	equip_cooldown = 25
	dam_force = 10

/obj/item/mecha_parts/mecha_equipment/hydraulic_clamp/lockermech/can_attach(obj/mecha/M as obj)
	if(istype(M, /obj/mecha/lockermech))
		if(M.equipment.len < M.max_equip)
			return TRUE
	return FALSE
