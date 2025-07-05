/obj/structure/flora/lazarus
	icon = 'modular_ss220/lazarus/icons/plants.dmi'
	anchored = TRUE
	max_integrity = 15

/obj/structure/flora/lazarus/berry
	name = "ягодный куст"
	desc = "Куст с разнообразными ягодами. Не ясно как он выжил в столь суровых условиях, но плоды выглядят свежими."
	icon_state = "berry_bush_full"
	var/berries_exist = TRUE

/obj/structure/flora/lazarus/berry/attack_hand(mob/living/user)
	. = ..()
	if(!do_after(user, 8 SECONDS, target = src))
		return
	if(!berries_exist)
		return
	berries_exist = FALSE
	icon_state = "berry_bush_empty"
	for(var/i = 0, i < 4, i++)
		new /obj/item/food/grown/berries(loc)

/obj/structure/flora/lazarus/comfrey
	name = "дикий окопник"
	desc = "Растение с целебными свойствами, которое может помочь при травмах."
	icon_state = "comfrey"

/obj/structure/flora/lazarus/comfrey/attack_hand(mob/living/user)
	. = ..()
	if(!do_after(user, 8 SECONDS, target = src))
		return
	for(var/i = 0, i < 3, i++)
		new /obj/item/food/grown/comfrey(loc)
	qdel(src)

/obj/structure/flora/lazarus/aloe
	name = "дикое алое"
	desc = "Растение с целебными свойствами, которое может помочь при ожогах."
	icon_state = "aloe"

/obj/structure/flora/lazarus/aloe/attack_hand(mob/living/user)
	. = ..()
	if(!do_after(user, 8 SECONDS, target = src))
		return
	for(var/i = 0, i < 3, i++)
		new /obj/item/food/grown/aloe(loc)
	qdel(src)
