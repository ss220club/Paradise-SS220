/obj/obj_destruction(damage_flag)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_OBJ_DESTRUCTION, damage_flag)
	. = ..()
