#define SENSOR_PRESSURE 	(1<<0)
#define SENSOR_TEMPERATURE 	(1<<1)
#define NO_DATA_VALUE  		0

/obj/item/circuitboard/pt_monitor
	board_name = "Atmospheric Graph Monitor"
	icon_state = "engineering"
	build_path = /obj/machinery/computer/general_air_control/pt_monitor
	origin_tech = "programming=2;engineering=3;materials=2"

/obj/machinery/computer/general_air_control/pt_monitor
	name = "Atmospheric graph monitoring console"
	desc = "Used to monitor pressure and temperature of linked analyzer."
	icon = 'modular_ss220/pt_monitor/icons/pt_monitor.dmi'
	icon_screen = "screen"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/pt_monitor

	var/record_size = 10
	var/record_interval = 5 SECONDS
	var/next_record_time = 0

/// Переопределим унаследованный от general_air_control TGUI интерфейс
/obj/machinery/computer/general_air_control/pt_monitor/ui_interact(mob/user, datum/tgui/ui = null)
	if(!isprocessing)
		START_PROCESSING(SSmachines, src)
		refresh_all()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// We can use the same template here for sensors and for tanks with inlets/outlets with TGUI memes
		ui = new(user, src, "AtmosGraphMonitor", name)
		ui.open()

// Создание списков pressure_history и temperature_history после конфигурации сенсоров
/obj/machinery/computer/general_air_control/pt_monitor/configure_sensors(mob/living/user, obj/item/multitool/M)
	. = ..()
	for(var/sensor_name in sensor_name_data_map)
		if(isnull(sensor_name_data_map[sensor_name]["pressure_history"]))
			sensor_name_data_map[sensor_name]["pressure_history"] = list()
		if(isnull(sensor_name_data_map[sensor_name]["temperature_history"]))
			sensor_name_data_map[sensor_name]["temperature_history"] = list()

/// Вызов логирования данных в process
/obj/machinery/computer/general_air_control/pt_monitor/process()
	record()
	. = ..()

/// Функция логирования данных в список, поведение подобно /obj/machinery/computer/general_air_control/proc/refresh_sensors()
/obj/machinery/computer/general_air_control/pt_monitor/proc/record()
	if(world.time >= next_record_time)
		next_record_time = world.time + record_interval

		for(var/sensor_name in sensor_name_uid_map)
			var/obj/machinery/atmospherics/AM = locateUID(sensor_name_uid_map[sensor_name])
			if(QDELETED(AM))
				sensor_name_uid_map -= sensor_name
				sensor_name_data_map -= sensor_name
				continue

			if(istype(AM, /obj/machinery/atmospherics/air_sensor))
				var/obj/machinery/atmospherics/air_sensor/AS = AM
				var/list/sensor_data = sensor_name_data_map[sensor_name]
				var/list/sensor_pressure_history = sensor_data["pressure_history"]
				var/list/sensor_temperature_history = sensor_data["temperature_history"]
				var/datum/gas_mixture/air_sample = AS.return_air()

				if(AS.output & SENSOR_PRESSURE)
					sensor_pressure_history += air_sample.return_pressure()
				else
					sensor_pressure_history += NO_DATA_VALUE
				if(AS.output & SENSOR_TEMPERATURE)
					sensor_temperature_history += air_sample.return_temperature()
				else
					sensor_temperature_history += NO_DATA_VALUE

				if(length(sensor_pressure_history) > record_size)
					sensor_pressure_history.Cut(1, 2)
				if(length(sensor_temperature_history) > record_size)
					sensor_temperature_history.Cut(1, 2)
