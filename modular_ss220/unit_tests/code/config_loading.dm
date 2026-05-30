#ifdef GAME_TESTS

/datum/server_configuration
	/// Contains all the misc configuration values
	var/datum/configuration_section/ss220_unit_test/test

/datum/server_configuration/load_all_sections()
	. = ..()
	safe_load(test, "ss220_unit_test")

/datum/server_configuration/load_configuration()
	test = new()
	. = ..()

/datum/configuration_section/ss220_unit_test
	var/secret_number = -1

/datum/configuration_section/ss220_unit_test/load_data(list/data)
	CONFIG_LOAD_NUM(secret_number, data["secret_number"])

/datum/game_test/config_loading

/datum/game_test/config_loading/Run()
	validate()

/datum/game_test/config_loading/proc/validate()
	var/secret_number = GLOB.configuration.test.secret_number
	if(secret_number != 42)
		Fail("Looks like we don't know the answer to the Ultimate Question of Life, The Universe, and Everything. Expected [42], got [secret_number], check if the config loading is working properly.")

#endif
