GLOBAL_LIST_EMPTY(ladder_teleporters)

/obj/structure/ladder_teleporter
	name = "Лестница"
	desc = "Лестница ведущая куда-то..."
	icon = 'modular_ss220/lazarus/icons/ladder.dmi'
	icon_state = "both"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = TRUE
	var/target_id
	var/ladder_id

/obj/structure/ladder_teleporter/New()
	..()
	GLOB.ladder_teleporters += src

/obj/structure/ladder_teleporter/Destroy()
	GLOB.ladder_teleporters -= src
	return ..()

/obj/structure/ladder_teleporter/singularity_act()
	return

/obj/structure/bladder_teleporter/singularity_pull()
	return

/obj/structure/ladder_teleporter/attack_hand(mob/user)
	var/obj/structure/ladder_teleporter/target
	for(var/obj/structure/ladder_teleporter/L in GLOB.ladder_teleporters)
		if(target_id == L.ladder_id)
			target = L
			continue
	if(!isnull(target))
		user.visible_message("<span class='notice'>[user] начал передвигаться по лестнице.", "<span class='notice'>Вы начали передвигаться по лестнице.</span>")
		if(!isnull(user.pulling))
			user.pulling.loc = user.loc
		user.loc = src.loc
		if(do_after(user, 20, target = src))
			user.visible_message("<span class='notice'>[user] закончил передвигаться по лестнице.", "<span class='notice'>Вы закончили передвигаться по лестнице.</span>")
			usr.loc = target.loc
			if(!isnull(user.pulling))
				user.pulling.loc = target.loc

/obj/structure/ladder_teleporter/attack_ghost(mob/user)
	for(var/obj/structure/ladder_teleporter/L in GLOB.ladder_teleporters)
		if(target_id == L.ladder_id)
			user.loc = L.loc
