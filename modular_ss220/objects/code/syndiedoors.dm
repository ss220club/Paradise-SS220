//////////////////////////////////
/*
	Add recipes to craft list
*/

/datum/modpack/objects/initialize()
	GLOB.plastitanium_recipes += list(
			new /datum/stack_recipe_list("S-class airlock assemblies", list(
				new /datum/stack_recipe("S-class public airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_public, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class security airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_sec, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class cargo airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_cargo, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class atmospherics airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_atmos, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class research airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_research, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class medical airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_med, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class maintenance airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_maint, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class command airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_com, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class freezer airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_freezer, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class external maintenance airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_extmai, 4, time = 50, one_per_turf = 1, on_floor = 1),
				new /datum/stack_recipe("S-class engineering airlock assembly", /obj/structure/door_assembly/syndicate/door_assembly_syndie_engi, 4, time = 50, one_per_turf = 1, on_floor = 1),
			))
		)

//////////////////////////////////
/*
	Syndie airlocks by Furukai
*/

/obj/machinery/door/airlock/syndicate
	name = "evil looking airlock"
	desc = "Why does it have those blowers?"
	overlays_file = 'modular_ss220/objects/icons/syndicate/overlays.dmi'
	note_overlay_file = 'modular_ss220/objects/icons/syndicate/overlays.dmi'
	paintable = FALSE

/obj/machinery/door/airlock/syndicate/security
	name = "evil looking security airlock"
	icon = 'modular_ss220/objects/icons/syndicate/security.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_sec
	normal_integrity = 500

/obj/machinery/door/airlock/syndicate/security/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 450

/obj/machinery/door/airlock/syndicate/public
	name = "evil looking public airlock"
	icon = 'modular_ss220/objects/icons/syndicate/public.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_public
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/public/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 300

/obj/machinery/door/airlock/syndicate/atmos
	name = "evil looking atmos airlock"
	icon = 'modular_ss220/objects/icons/syndicate/atmos.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_atmos
	normal_integrity = 400
/obj/machinery/door/airlock/syndicate/atmos/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/maintenance
	name = "evil looking maintenance airlock"
	icon = 'modular_ss220/objects/icons/syndicate/maintenance.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_maint
	normal_integrity = 300

/obj/machinery/door/airlock/syndicate/maintenance/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 250

/obj/machinery/door/airlock/syndicate/medical
	name = "evil looking medbay airlock"
	icon = 'modular_ss220/objects/icons/syndicate/medical.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_med
	normal_integrity = 400


/obj/machinery/door/airlock/syndicate/medical/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/cargo
	name = "evil looking cargo airlock"
	icon = 'modular_ss220/objects/icons/syndicate/cargo.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_cargo
	normal_integrity = 400

/obj/machinery/door/airlock/syndicate/cargo/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/research
	name = "evil looking research airlock"
	icon = 'modular_ss220/objects/icons/syndicate/research.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_research
	normal_integrity = 400

/obj/machinery/door/airlock/syndicate/research/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/engineering
	name = "evil looking engineering airlock"
	icon = 'modular_ss220/objects/icons/syndicate/engineering.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_engi
	normal_integrity = 450

/obj/machinery/door/airlock/syndicate/engineering/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/airlock/syndicate/command
	name = "evil looking command airlock"
	icon = 'modular_ss220/objects/icons/syndicate/command.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_com
	normal_integrity = 500

/obj/machinery/door/airlock/syndicate/command/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 450

/obj/machinery/door/airlock/syndicate/freezer
	name = "evil looking freezer airlock"
	desc = "It's not even cold inside..."
	icon = 'modular_ss220/objects/icons/syndicate/freezer.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_freezer
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/freezer/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 300

/obj/machinery/door/airlock/syndicate/extmai
	name = "evil looking external maintenance airlock"
	icon = 'modular_ss220/objects/icons/syndicate/maintenanceexternal.dmi'
	assemblytype = /obj/structure/door_assembly/syndicate/door_assembly_syndie_extmai
	normal_integrity = 350

/obj/machinery/door/airlock/syndicate/extmai/glass
	opacity = 0
	glass = TRUE
	normal_integrity = 300

//////////////////////////////////
/*
	Syndie airlock assemblies by Furukai
*/

/obj/structure/door_assembly/syndicate
	overlays_file = 'modular_ss220/objects/icons/syndicate/overlays.dmi'

/obj/structure/door_assembly/syndicate/door_assembly_syndie_sec
	name = "evil looking security airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/security.dmi'
	base_name = "evil looking security airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/security/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/security
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_public
	name = "evil looking public airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/public.dmi'
	base_name = "evil looking public airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/public/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/public
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_atmos
	name = "evil looking atmos airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/atmos.dmi'
	base_name = "evil looking atmos airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/atmos/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/atmos
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_maint
	name = "evil looking maintenance airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/maintenance.dmi'
	base_name = "evil looking maintenance airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/maintenance/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/maintenance
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_med
	name = "evil looking medical airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/medical.dmi'
	base_name = "evil looking medical airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/medical/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/medical
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_cargo
	name = "evil looking cargo airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/cargo.dmi'
	base_name = "evil looking cargo airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/cargo/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/cargo
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_research
	name = "evil looking research airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/research.dmi'
	base_name = "evil looking research airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/research/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/research
	material_type = /obj/item/stack/sheet/mineral/plastitanium
/obj/structure/door_assembly/syndicate/door_assembly_syndie_com
	name = "evil looking command airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/command.dmi'
	base_name = "evil looking command airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/command/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/command
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_freezer
	name = "evil looking freezer airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/freezer.dmi'
	base_name = "evil looking freezer airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/freezer/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/freezer
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_extmai
	name = "evil looking external maintenance airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/maintenanceexternal.dmi'
	base_name = "evil looking external maintenance airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/extmai/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/extmai
	material_type = /obj/item/stack/sheet/mineral/plastitanium

/obj/structure/door_assembly/syndicate/door_assembly_syndie_engi
	name = "evil looking engineering airlock assembly"
	icon = 'modular_ss220/objects/icons/syndicate/engineering.dmi'
	base_name = "evil looking engineering airlock"
	glass_type = /obj/machinery/door/airlock/syndicate/engineering/glass
	airlock_type = /obj/machinery/door/airlock/syndicate/engineering
	material_type = /obj/item/stack/sheet/mineral/plastitanium
