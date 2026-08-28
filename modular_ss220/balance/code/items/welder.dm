/obj/item/weldingtool/toggle_welder(turn_off)
	. = ..()

	if(tool_enabled)
		force = 10
