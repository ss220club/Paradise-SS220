/obj/machinery/computer/shuttle/dunes
	name = "emergency shuttle console"
	circuit = null
	shuttleId = "dunes"
	possible_destinations = "dunes_end"

/obj/machinery/computer/shuttle/dunes/onTransitZ(old_z,new_z)
	. = ..()
	explosion(src, 1, 8, 50, 75, 1, 1)
