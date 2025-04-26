/datum/asset/spritesheet/job_icons/create_spritesheets()
	var/list/states = GLOB.joblist + "centcom" + "solgov" + "soviet" + "unknown"
	for(var/state in states)
		Insert(ckey(state), 'modular_ss220/jobs/icons/job_assets_combined.dmi', ckey(state))
