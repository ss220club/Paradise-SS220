/obj/item/circuitboard/pt_monitor
	board_name = "Atmospheric Graph Monitor"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/general_air_control/pt_monitor
	origin_tech = "programming=2;engineering=3;materials=2"

/obj/machinery/computer/general_air_control/pt_monitor
	name = "Atmospheric graph monitoring console"
	desc = "Used to monitor pressure and temperature of linked analyzer."
	icon_screen = "idce"
	icon_keyboard = "atmos_key"
	//code\game\machinery\computer\power_monitor_console.dm
	circuit = /obj/item/circuitboard/pt_monitor

/obj/machinery/computer/general_air_control/pt_monitor/ui_interact(mob/user, datum/tgui/ui = null)
	if(!isprocessing)
		START_PROCESSING(SSmachines, src)
		refresh_all()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// We can use the same template here for sensors and for tanks with inlets/outlets with TGUI memes
		ui = new(user, src, "AtmosGraphMonitor", name)
		ui.open()
