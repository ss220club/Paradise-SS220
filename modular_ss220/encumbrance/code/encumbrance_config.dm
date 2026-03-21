/datum/configuration_section/ss220_encumbrance_configuration
	var/enabled = TRUE
	var/base_capacity = 36
	var/slowdown_per_weight = 0.08
	var/max_slowdown = 4.0
	var/pulling_weight_mult = 1.0

	var/tiny_weight = 1.0
	var/small_weight = 2.0
	var/normal_weight = 3.0
	var/bulky_weight = 4.0
	var/huge_weight = 5.0
	var/gigantic_weight = 6.0

	var/rail_thin_mult = 0.75
	var/thin_mult = 0.90
	var/average_mult = 1.00
	var/well_built_mult = 1.10
	var/muscular_mult = 1.20
	var/overweight_mult = 0.95

/datum/configuration_section/ss220_encumbrance_configuration/load_data(list/data)
	CONFIG_LOAD_BOOL(enabled, data["enabled"])
	CONFIG_LOAD_NUM(base_capacity, data["base_capacity"])
	CONFIG_LOAD_NUM(slowdown_per_weight, data["slowdown_per_weight"])
	CONFIG_LOAD_NUM(max_slowdown, data["max_slowdown"])
	CONFIG_LOAD_NUM(pulling_weight_mult, data["pulling_weight_mult"])

	CONFIG_LOAD_NUM(tiny_weight, data["tiny_weight"])
	CONFIG_LOAD_NUM(small_weight, data["small_weight"])
	CONFIG_LOAD_NUM(normal_weight, data["normal_weight"])
	CONFIG_LOAD_NUM(bulky_weight, data["bulky_weight"])
	CONFIG_LOAD_NUM(huge_weight, data["huge_weight"])
	CONFIG_LOAD_NUM(gigantic_weight, data["gigantic_weight"])

	CONFIG_LOAD_NUM(rail_thin_mult, data["rail_thin_mult"])
	CONFIG_LOAD_NUM(thin_mult, data["thin_mult"])
	CONFIG_LOAD_NUM(average_mult, data["average_mult"])
	CONFIG_LOAD_NUM(well_built_mult, data["well_built_mult"])
	CONFIG_LOAD_NUM(muscular_mult, data["muscular_mult"])
	CONFIG_LOAD_NUM(overweight_mult, data["overweight_mult"])

/datum/server_configuration
	var/datum/configuration_section/ss220_encumbrance_configuration/ss220_encumbrance

/datum/server_configuration/load_all_sections()
	. = ..()
	ss220_encumbrance = new()
	safe_load(ss220_encumbrance, "ss220_encumbrance_configuration")
