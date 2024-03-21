/obj/item/circuitboard/pt_monitor
	board_name = "pt_monitor"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/pt_monitor

/obj/machinery/computer/pt_monitor
	name = "PT monitoring console"
	desc = "Used to monitor pressure and temperature of linked analyzer."
	icon_screen = "idce"
	icon_keyboard = "atmos_key"
	power_state = ACTIVE_POWER_USE
	idle_power_consumption = 20
	active_power_consumption = 80
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/pt_monitor

/obj/machinery/computer/pt_monitor/ui_interact(mob/user, datum/tgui/ui = null) //отображение TGUI
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PTMonitor", name)
		ui.open()

/obj/machinery/computer/pt_monitor/ui_data(mob/user) //передача данных
	var/list/data = list()
	data["description"] = desc
	data["name"] = name

	return data

/obj/machinery/computer/pt_monitor/attack_hand(mob/user) //персонаж взаимодействует с консолью
	ui_interact(user)

/obj/machinery/computer/pt_monitor/attack_ai(mob/user) //ии взаимодействует с консолью
	attack_hand(user)

