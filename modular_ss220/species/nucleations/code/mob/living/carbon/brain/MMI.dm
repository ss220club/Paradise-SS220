/obj/item/mmi/item_interaction(obj/item/O as obj, mob/user as mob, params)
	if(istype(O, /obj/item/organ/internal/brain/crystal))
		to_chat(user, SPAN_WARNING("Этот причудливо сформированный мозг не взаимодействует с [src]."))
		return ITEM_INTERACT_COMPLETE
	. = ..()
