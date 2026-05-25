/obj/structure/chair/stool/bar
	can_buckle = TRUE

/obj/structure/chair/stool/handle_layer()
	layer = OBJ_LAYER

/obj/structure/chair/stool/post_buckle_mob(mob/living/M)
	. = ..()

	M.pixel_y = 2

/obj/structure/chair/stool/post_unbuckle_mob(mob/living/M)
	. = ..()

	M.pixel_y = initial(M.pixel_y)
