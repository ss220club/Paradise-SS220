/obj/machinery/autolathe/mini
	name = "minilathe"
	desc = "Compact version of the Autolathe. It produces items using metal and glass."
	icon = 'modular_ss220/minilathe/icon/minilathe.dmi'
	idle_power_consumption = 5
	active_power_consumption = 25
	queue_max_len = 6
	board_type = /obj/item/circuitboard/minilathe
	var/departament_overlay

/obj/machinery/autolathe/mini/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/material_container, list(MAT_METAL, MAT_GLASS), _show_on_examine=TRUE, _after_insert=CALLBACK(src, PROC_REF(AfterMaterialInsert)))
	component_parts = list()
	component_parts += new board_type(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	RefreshParts()

	RegisterSignal(src, COMSIG_TOOL_ATTACK, PROC_REF(on_tool_attack))

	wires = new(src)
	files = new /datum/research/minilathe(src)
	matching_designs = list()

	add_overlay(departament_overlay)

/obj/item/circuitboard/minilathe
	board_name = "Minilathe"
	icon_state = "engineering"
	build_path = /obj/machinery/autolathe/mini
	board_type = "machine"
	origin_tech = "engineering=1;programming=1"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stack/sheet/glass = 1)

// SERVICE
/obj/machinery/autolathe/mini/service
	name = "service minilathe"
	desc = "Compact version of the Autolathe. It produces service-related items using metal and glass."
	categories = list("Dinnerware", "Service Tools", "Materials", "Imported")
	departament_overlay = "overlay_serv"
	board_type = /obj/item/circuitboard/minilathe/service

/obj/machinery/autolathe/mini/Initialize(mapload)
	. = ..()
	files = new /datum/research/minilathe/service(src)
	return ..()

/obj/item/circuitboard/minilathe/service
	board_name = "Service Minilathe"
	icon_state = "service"
	build_path = /obj/machinery/autolathe/mini/service
