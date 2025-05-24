/obj/structure/chair/office/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	playsound(loc, pick('sound/items/cartwheel1.ogg', 'sound/items/cartwheel2.ogg'), 50, TRUE, ignore_walls = FALSE)

/obj/structure/janitorialcart/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	playsound(loc, pick('sound/items/cartwheel1.ogg', 'sound/items/cartwheel2.ogg'), 75, TRUE, ignore_walls = FALSE)

/obj/structure/engineeringcart/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	playsound(loc, pick('sound/items/cartwheel1.ogg', 'sound/items/cartwheel2.ogg'), 100, TRUE, ignore_walls = FALSE)

/obj/structure/reagent_dispensers/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	playsound(loc, pick('sound/items/cartwheel1.ogg', 'sound/items/cartwheel2.ogg'), 100, TRUE, ignore_walls = FALSE)

/obj/machinery/nuclearbomb/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	playsound(loc, pick('sound/items/cartwheel1.ogg', 'sound/items/cartwheel2.ogg'), 100, TRUE, ignore_walls = FALSE)

/obj/structure/bed/roller/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	playsound(loc, pick('sound/items/cartwheel1.ogg', 'sound/items/cartwheel2.ogg'), 50, TRUE, ignore_walls = FALSE)
