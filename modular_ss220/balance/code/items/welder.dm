/obj/item/weldingtool/toggle_welder()
	. = ..()

	if(tool_enabled)
		force = 10
