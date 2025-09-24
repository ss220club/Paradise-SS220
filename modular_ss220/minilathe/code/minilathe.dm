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

	add_overlay(departament_overlay)

/obj/machinery/autolathe/mini/item_interaction(mob/living/user,  obj/item/used)
	. = ..()
	if(!.)
		return

	if(istype(used, /obj/item/disk))
		to_chat(user, span_warning("[src] can't load designs from disks!"))
		return ITEM_INTERACT_COMPLETE

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

/obj/machinery/autolathe/mini/departamental
	name = "strange minilathe"
	desc = "Какой-то странный минилат. Сообщите мистеру-разработчику, если вы вдруг видите его."
	categories = list("Materials")

/obj/machinery/autolathe/mini/departamental/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Minilathe220", name)
		ui.open()

// SERVICE
/obj/machinery/autolathe/mini/departamental/service
	name = "service minilathe"
	desc = "Compact version of the Autolathe. It produces service-related items using metal and glass."
	categories = list("Cookware", "Glassware", "Hydroponical", "Janitorial", "Service Misc.", "Materials")
	departament_overlay = "overlay_serv"
	board_type = /obj/item/circuitboard/minilathe/service

/obj/item/circuitboard/minilathe/service
	board_name = "Service Minilathe"
	icon_state = "service"
	build_path = /obj/machinery/autolathe/mini/departamental/service

// MEDICAL
/obj/machinery/autolathe/mini/departamental/medical
	name = "medical minilathe"
	desc = "Compact version of the Autolathe. It produces medical-related items using metal and glass."
	categories = list("Surgical Tools", "Containers", "Medical Misc.", "Materials")
	departament_overlay = "overlay_med"
	board_type = /obj/item/circuitboard/minilathe/medical

/obj/item/circuitboard/minilathe/medical
	board_name = "Medical Minilathe"
	icon_state = "medical"
	build_path = /obj/machinery/autolathe/mini/departamental/medical

// SECURITY
/obj/machinery/autolathe/mini/departamental/security
	name = "security minilathe"
	desc = "Compact version of the Autolathe. It produces security-related items using metal and glass."
	categories = list("Ammunition", "Security Misc.", "Materials")
	departament_overlay = "overlay_sec"
	board_type = /obj/item/circuitboard/minilathe/security

/obj/item/circuitboard/minilathe/security
	board_name = "Security Minilathe"
	icon_state = "security"
	build_path = /obj/machinery/autolathe/mini/departamental/security

// ENGINEERING
/obj/machinery/autolathe/mini/departamental/engineering
	name = "engineering minilathe"
	desc = "Compact version of the Autolathe. It produces engineering-related items using metal and glass."
	categories = list("Tools", "Electronics", "Construction", "Machinery", "Materials")
	departament_overlay = "overlay_eng"
	board_type = /obj/item/circuitboard/minilathe/engineering

/obj/item/circuitboard/minilathe/engineering
	board_name = "Engineering Minilathe"
	icon_state = "engineering"
	build_path = /obj/machinery/autolathe/mini/departamental/engineering
