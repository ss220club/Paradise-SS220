/obj/effect/countdown/nuclearbomb
	name = "nuclear bomb countdown"

/obj/effect/countdown/nuclearbomb/get_value()
	var/obj/machinery/nuclearbomb/N = attached_to
	if(!istype(N))
		return
	if(N.timing)
		return N.timeleft
	return
