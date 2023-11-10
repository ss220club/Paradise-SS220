/datum/configuration_section/overflow_configuration
	var/reservation_time = 1 MINUTES
	var/server_address = "127.0.0.1"

/datum/configuration_section/overflow_configuration/load_data(list/data)
	. = ..()

	CONFIG_LOAD_NUM(reservation_time, data["reservation_time"])
	CONFIG_LOAD_STR(server_address, data["server_address"])
