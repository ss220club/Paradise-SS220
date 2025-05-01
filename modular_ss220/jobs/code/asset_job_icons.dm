/datum/asset/spritesheet/job_icons/create_spritesheets()
	var/list/states = GLOB.joblist + "centcom" + "solgov" + "soviet" + "unknown"
	var/default = 'icons/mob/hud/job_assets.dmi'
	var/custom = 'modular_ss220/jobs/icons/job_assets.dmi'
	for(var/state in states)
		var/canonical_state = ckey(state)
		Insert(canonical_state, icon_exists(custom, canonical_state) ? custom : default, canonical_state)
