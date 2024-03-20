/obj/item/circuitboard/pt_monitor
	board_name = "pt_monitor"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/pt_monitor

/obj/machinery/computer/pt_monitor
	name = "PT monitoring console"
	desc = "Used to monitor PT across the station."
	icon_screen = "idce"
	icon_keyboard = "atmos_key"
	power_state = ACTIVE_POWER_USE
	idle_power_consumption = 20
	active_power_consumption = 80
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/pt_monitor
