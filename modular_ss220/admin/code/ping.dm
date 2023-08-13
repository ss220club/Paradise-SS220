/client
	/// Last ping of the client
	var/lastping = 0
	/// Average ping of the client
	var/avgping = 0
	/// world.time they connected
	var/connection_time
	/// world.realtime they connected
	var/connection_realtime
	/// world.timeofday they connected
	var/connection_timeofday

/client/New(TopicData)
	. = ..()
	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday

/client/Destroy()
	. = ..()
	SSping.currentrun -= src

/mob/show_stat_station_time()
	. = ..()
	stat(null, "Ping: [round(client.lastping, 1)]ms (Average: [round(client.avgping, 1)]ms)")

/client/verb/update_ping(time as num)
	set instant = TRUE
	set name = ".update_ping"
	var/ping = pingfromtime(time)
	lastping = ping
	if (!avgping)
		avgping = ping
	else
		avgping = MC_AVERAGE_SLOW(avgping, ping)

/client/proc/pingfromtime(time)
	return ((world.time+world.tick_lag*TICK_USAGE_REAL/100)-time)*100

/client/verb/display_ping(time as num)
	set instant = TRUE
	set name = ".display_ping"
	to_chat(src, span_notice("Round trip ping took [round(pingfromtime(time),1)]ms"))

/client/verb/ping()
	set name = "Ping"
	set category = "OOC"
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")
