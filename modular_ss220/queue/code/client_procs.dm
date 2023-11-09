/mob/new_player/Login()
	. = ..()

	if(!SSdbcore.IsConnected())
		return

	if(SSqueue.queue_enabled)
		if(client?.holder)
			SSqueue.queue_bypass_list |= ckey
			return

		if(client?.ckey in SSqueue.queue_bypass_list)
			return

		if(length(GLOB.clients) > GLOB.configuration.overflow.reroute_cap)
			src << link(GLOB.configuration.overflow.overflow_server_location)
