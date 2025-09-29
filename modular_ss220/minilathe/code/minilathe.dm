/obj/machinery/autolathe/mini
	name = "minilathe"
	desc = "Compact version of the Autolathe. It produces items using metal and glass."
	icon = 'modular_ss220/minilathe/icon/minilathe.dmi'
	idle_power_consumption = 5
	active_power_consumption = 25
	queue_max_len = 6
	board_type = /obj/item/circuitboard/minilathe
	disks_compatible = FALSE
	var/departament_overlay

/obj/machinery/autolathe/mini/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new board_type(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	RefreshParts()

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

/datum/design/minilathe
	name = "Machine Board (Minilathe)"
	desc = "The circuit board for an Minilathe."
	id = "minilathe"
	req_tech = list("programming" = 2, "engineering" = 2)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000)
	build_path = /obj/item/circuitboard/minilathe
	category = list("Research Machinery")

/obj/machinery/autolathe/mini/departamental
	name = "StRaNgE mInIlAtHe"
	desc = "Какой-то странный минилат. Сообщите мистеру-разработчику, если вы вдруг видите его."
	categories = list(DESIGN_MATERIALS)

/obj/machinery/autolathe/mini/departamental/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Minilathe220", name)
		ui.open()

// SERVICE
/obj/machinery/autolathe/mini/departamental/service
	name = "service minilathe"
	desc = "Compact version of the Autolathe. It produces service-related items using metal and glass."
	categories = list(DESIGN_COOKWARE, DESIGN_GLASSWARE, DESIGN_HYDROPONICAL, DESIGN_JANITORIAL, DESIGN_SERVICEMISC, DESIGN_MATERIALS)
	departament_overlay = "overlay_serv"
	board_type = /obj/item/circuitboard/minilathe/service

/obj/item/circuitboard/minilathe/service
	board_name = "Service Minilathe"
	icon_state = "service"
	build_path = /obj/machinery/autolathe/mini/departamental/service

/datum/design/servminilathe
	name = "Machine Board (Service Minilathe)"
	desc = "The circuit board for an Service Minilathe."
	id = "service_minilathe"
	req_tech = list("programming" = 2, "engineering" = 2)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000)
	build_path = /obj/item/circuitboard/minilathe/service
	category = list("Misc. Machinery")

// MEDICAL
/obj/machinery/autolathe/mini/departamental/medical
	name = "medical minilathe"
	desc = "Compact version of the Autolathe. It produces medical-related items using metal and glass."
	categories = list(DESIGN_SURGICAL, DESIGN_CONTAINERS, DESIGN_MEDICALMISC, DESIGN_MATERIALS)
	departament_overlay = "overlay_med"
	board_type = /obj/item/circuitboard/minilathe/medical

/obj/item/circuitboard/minilathe/medical
	board_name = "Medical Minilathe"
	icon_state = "medical"
	build_path = /obj/machinery/autolathe/mini/departamental/medical

/datum/design/medminilathe
	name = "Machine Board (Medical Minilathe)"
	desc = "The circuit board for an Medical Minilathe."
	id = "medical_minilathe"
	req_tech = list("programming" = 2, "engineering" = 2, "biotech" = 1)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000)
	build_path = /obj/item/circuitboard/minilathe/medical
	category = list("Misc. Machinery")

// SECURITY
/obj/machinery/autolathe/mini/departamental/security
	name = "security minilathe"
	desc = "Compact version of the Autolathe. It produces security-related items using metal and glass."
	categories = list(DESIGN_AMMUNITION, DESIGN_SECURITYMISC, DESIGN_MATERIALS)
	departament_overlay = "overlay_sec"
	board_type = /obj/item/circuitboard/minilathe/security

/obj/item/circuitboard/minilathe/security
	board_name = "Security Minilathe"
	icon_state = "security"
	build_path = /obj/machinery/autolathe/mini/departamental/security

/datum/design/secminilathe
	name = "Machine Board (Security Minilathe)"
	desc = "The circuit board for an Security Minilathe."
	id = "security_minilathe"
	req_tech = list("programming" = 2, "engineering" = 2, "combat" = 1)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000)
	build_path = /obj/item/circuitboard/minilathe/security
	category = list("Misc. Machinery")

// ENGINEERING
/obj/machinery/autolathe/mini/departamental/engineering
	name = "engineering minilathe"
	desc = "Compact version of the Autolathe. It produces engineering-related items using metal and glass."
	categories = list("Tools", "Electronics", "Construction", "Machinery", DESIGN_MATERIALS)
	departament_overlay = "overlay_eng"
	board_type = /obj/item/circuitboard/minilathe/engineering

/obj/item/circuitboard/minilathe/engineering
	board_name = "Engineering Minilathe"
	icon_state = "engineering"
	build_path = /obj/machinery/autolathe/mini/departamental/engineering

/datum/design/engminilathe
	name = "Machine Board (Engineering Minilathe)"
	desc = "The circuit board for an Engineering Minilathe."
	id = "engineering_minilathe"
	req_tech = list("programming" = 2, "engineering" = 2, "materials" = 1)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000)
	build_path = /obj/item/circuitboard/minilathe/engineering
	category = list("Misc. Machinery")
