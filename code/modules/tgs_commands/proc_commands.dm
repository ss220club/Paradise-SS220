/proc/get_online_staff_counts()
	var/num_mentors_online = 0
	var/num_admins_online = 0
	var/num_devs_online = 0

	for(var/client/C in GLOB.admins)
		if(check_rights(R_BAN, FALSE, C.mob))
			num_admins_online++
		else if(check_rights(R_DEV_TEAM, FALSE, C.mob))
			num_devs_online++
		else if(check_rights(R_MENTOR, FALSE, C.mob))
			num_mentors_online++

	return list(
		"admins" = num_admins_online,
		"mentors" = num_mentors_online,
		"developers" = num_devs_online
	)
