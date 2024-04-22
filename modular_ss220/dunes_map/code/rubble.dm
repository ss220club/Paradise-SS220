/obj/structure/rubble
	name = "pile of rubble"
	desc = "One man's garbage is another man's treasure."
	icon = 'modular_ss220/dunes_map/icons/rubble.dmi'
	icon_state = "base"
	opacity = 1
	density = TRUE
	anchored = TRUE
	max_integrity = 40

	var/list/loot = list(/obj/item/stock_parts/cell,/obj/item/stack/sheet/metal,/obj/item/stack/rods)
	var/lootleft = 1
	var/emptyprob = 95
	var/is_rummaging = 0

/obj/structure/rubble/New()
	if(prob(emptyprob))
		lootleft = 0
	..()

/obj/structure/rubble/Initialize()
	. = ..()
	update_icon()

/obj/structure/rubble/update_icon(updates)
	. = ..()
	var/matrix/M
	var/list/parts = list()
	for(var/i = 1 to 7)
		var/image/I = image(icon,"rubble[rand(1,15)]")
		if(prob(10))
			var/atom/A = pick(loot)
			if(initial(A.icon) && initial(A.icon_state))
				I.icon = initial(A.icon)
				I.icon_state = initial(A.icon_state)
				I.color = initial(A.color)
			if(!lootleft)
				I.color = "#54362e"
		I.pixel_x = rand(-16,16)
		I.pixel_y = rand(-16,16)
		M.Turn(rand(0,360))
		I.transform = M
		parts += I


/obj/structure/rubble/attack_hand(mob/user)
	if(!is_rummaging)
		if(!lootleft)
			to_chat(user, "<span class='warning'> There's nothing left in this one but unusable garbage...")
			return
		visible_message("[user] starts rummaging through \the [src].")
		is_rummaging = 1
		if(do_after(user, 3 SECONDS, src))
			var/obj/item/booty = pickweight(loot)
			booty = new booty(loc)
			lootleft--
			update_icon()
			to_chat(user, "<span class='notice'> You find \a [booty] and pull it carefully out of \the [src].")
		is_rummaging = 0
	else
		to_chat(user, "<span class='warning'> Someone is already rummaging here!")

/obj/structure/rubble/tool_act(mob/living/user, obj/item/I, tool_type)
	. = ..()
	// Pickaxe - Clear rubble
	if (istype(tool_type, /obj/item/pickaxe))
		user.visible_message(
			"<span class='notice'> \The [user] starts clearing away \the [src] with \a [tool_type].",
			"<span class='notice'> You start clearing away \the [src] with \the [tool_type]."
		)
		if (lootleft && prob(1))
			var/booty = pickweight(loot)
			new booty(loc)
		user.visible_message(
			"<span class='notice'> \The [user] clears away \the [src] with \a [tool_type].",
			"<span class='notice'> You clear away \the [src] with \the [tool_type]."
		)
		qdel(src)
		return TRUE

	return ..()





/obj/structure/rubble/Destroy()
	. = ..()
	visible_message("<span class='warning'> \The [src] breaks apart!")
	qdel(src)

/obj/structure/rubble/house
	loot = list(

	)

/obj/structure/rubble/lab
	emptyprob = 30
	loot = list(

	)

/obj/structure/rubble/war
	emptyprob = 95 //can't have piles upon piles of guns
	loot = list(

	)
