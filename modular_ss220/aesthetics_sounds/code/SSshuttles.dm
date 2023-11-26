/datum/controller/subsystem/shuttle/moveShuttle(shuttleId, dockId, timed, mob/user)
	. = ..()
	if(. == 0)
		var/obj/docking_port/mobile/M = getShuttle(shuttleId)
		M.areaInstance << M.fly_sound
