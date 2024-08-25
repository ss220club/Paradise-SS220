/datum/unit_test/security_levels

/datum/unit_test/security_levels/Run()
	security_levels_order()

/datum/unit_test/security_levels/proc/security_levels_order()
	var/list/expected = list(
		new /datum/security_level/green,
		new /datum/security_level/blue,
		new /datum/security_level/violet,
		new /datum/security_level/orange,
		new /datum/security_level/red,
		new /datum/security_level/gamma,
		new /datum/security_level/epsilon,
		new /datum/security_level/delta
	)
	var/list/actual = SSsecurity_level.available_levels
	if(!compare_list(expected, actual))
		Fail("Security levels order is invalid.\nExpected: [expected]\nActual: [actual]")
