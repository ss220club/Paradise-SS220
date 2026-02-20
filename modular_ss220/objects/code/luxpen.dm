/obj/item/reagent_containers/hypospray/autoinjector/lux //Является модулем

	name = "lux medipen"
	desc = "An advanced multi-purpose medical pen containing a powerful cocktail of high-end reagents."
	icon = 'modular_ss220/objects/icons/luxpen.dmi'
	icon_state = "luxpen"
	volume = 60
	amount_per_transfer_from_this = 60
	list_reagents = list("lavaland_extract" = 3, "weak_omnizine" = 10, "omnizine" = 5, "bicaridine" = 5, "kelotane" = 5, "menthol" = 5, "sal_acid" = 5, "teporone" = 8, "salbutamol" = 8, "epinephrine" = 6)

/obj/item/reagent_containers/hypospray/autoinjector/lux/apply(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return

	var/turf/T = get_turf(user)
	var/delay = 50 // 5  SECONDS

	if(isspaceturf(T))
		delay = 0

	var/area/A = get_area(T)
	if(istype(A, /area/lavaland))
		delay = 0

	if(delay)
		user.visible_message("<span class='notice'>[user] begins injecting [M] with [src]...</span>")
		if(!do_after(user, delay, 1, M, TRUE))
			return
	else
		user.visible_message("<span class='notice'>[user] instantly injects [M] with [src]!</span>")

	return ..()
