/datum/controller/subsystem/round_master
	name = "Round Master"
	wait = 1
	priority = FIRE_PRIORITY_DEFAULT
	runlevels = RUNLEVEL_GAME
	flags = SS_NO_FIRE | SS_NO_INIT

	var/current_master = null

/datum/controller/subsystem/round_master/proc/has_master()
	return !!current_master

/datum/controller/subsystem/round_master/proc/is_master(client/C)
	return current_master == C

/datum/controller/subsystem/round_master/proc/set_master(client/C)
	current_master = C

/datum/controller/subsystem/round_master/proc/clear_master()
	current_master = null

SUBSYSTEM_DEF(round_master)
