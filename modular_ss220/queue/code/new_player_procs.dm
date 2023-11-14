/client/proc/queue_check()
	if(SSqueue.initialized)
		if(ckey in SSqueue.queue_bypass_list)
			return TRUE
		if(!SSqueue.queue_enabled)
			SSqueue.queue_bypass_list |= ckey
			return TRUE

	log_debug("Try redirect [ckey] to queue server")

	var/result = world.Export("[GLOB.configuration.overflow.overflow_server_location]?ping")

	log_debug("Ping queue server result [result]")

	if(!result)
		return TRUE

	var/redirect_link = "[GLOB.configuration.overflow.overflow_server_location]?target=[GLOB.configuration.overflow.server_address]:[world.port]"
	log_debug("generated redirect link [redirect_link]")
	src << link(redirect_link)

	return FALSE


/client/proc/reserve_queue_slot()
	if(ckey in SSqueue.queue_bypass_list)
		addtimer(CALLBACK(SSqueue, TYPE_PROC_REF(/datum/controller/subsystem/queue, reserve_queue_slot), ckey), GLOB.configuration.overflow.reservation_time)

		. = ..()


/datum/controller/subsystem/queue/proc/reserve_queue_slot(reserved_ckey)
	if(reserved_ckey in GLOB.player_list)
		return

	queue_bypass_list.Remove(reserved_ckey)
