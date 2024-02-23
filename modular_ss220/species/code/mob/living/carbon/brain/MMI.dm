/obj/item/mmi/attackby(obj/item/O as obj, mob/user as mob, params)
	if(istype(O, /obj/item/organ/internal/brain/crystal))
		to_chat(user, "<span class='warning'> Этот причудливо сформированный мозг не взаимодействует с [src].</span>")
		return
	. = ..()
