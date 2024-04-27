/obj/structure/rubble
	name = "pile of rubble"
	desc = "One man's garbage is another man's treasure."
	icon = 'modular_ss220/dunes_map/icons/loot_piles.dmi'
	icon_state = "randompile"
	opacity = 0
	density = FALSE
	anchored = TRUE
	max_integrity = 40
	layer = TURF_DECAL_LAYER

	var/list/loot
	var/list/trash_types
	var/lootleft = 0
	var/emptyprob = 25
	var/is_rummaging = 0

/obj/structure/rubble/New()
	if(prob(emptyprob))
		lootleft = 1
	..()

/obj/structure/rubble/Initialize()
	. = ..()
	icon_state = "[pick(trash_types)]"
	update_icon()


/obj/structure/rubble/attack_hand(mob/user)
	if(!is_rummaging)
		visible_message("[user] starts rummaging through \the [src].")
		is_rummaging = 1
		if(!do_after(user, 3 SECONDS, target = src))
			is_rummaging = 0
			return

		if(!lootleft)
			to_chat(user, "<span class='warning'> There's nothing left in this one but unusable garbage...")
			is_rummaging = 0
			return

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

/obj/structure/rubble/outside
	trash_types = list("technical_pile1", "technical_pile2", "junk_pile5", "junk_pile1", "boxfort", "trash_pile2")
	loot = list(
		/obj/item/stock_parts/cell,
		/obj/item/stack/sheet/metal,
		/obj/item/stack/rods)

/obj/structure/rubble/house
	trash_types = list("junk_pile2", "junk_pile4","trash_pile1", "trash_pile2")
	loot = list(
		/obj/item/food/snacks/chips = 6,
		/obj/item/kitchen/knife,
		/obj/item/reagent_containers/drinks/cans/starkist,
		/obj/item/reagent_containers/drinks/cans/space_up,
		/obj/item/stack/sheet/wood = 3,
		/obj/item/reagent_containers/glass/beaker/large,
		/obj/item/reagent_containers/glass/beaker/waterbottle/large


	)

/obj/structure/rubble/lab
	trash_types = list("junk_pile4", "technical_pile1", "technical_pile2", "technical_pile3")
	emptyprob = 30
	loot = list(

	)

/obj/structure/rubble/war
	trash_types = list("boxfort", "junk_pile3", "junk_pile5",  "junk_pile1")
	emptyprob = 40 //can't have piles upon piles of guns
	loot = list(

	)
