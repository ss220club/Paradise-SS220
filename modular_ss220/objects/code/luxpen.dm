/obj/item/reagent_containers/hypospray/autoinjector/lux //Является модулем

	name = "lux medipen"
	desc = "An advanced multi-purpose medical pen containing a powerful cocktail of high-end reagents."
	icon = 'modular_ss220/objects/icons/luxpen.dmi'
	icon_state = "luxpen"
	volume = 40
	amount_per_transfer_from_this = 40
	list_reagents = list("adv_lava_extract" = 10, "teporone" = 10, "salbutamol" = 10, "hydrocodone" = 10)

/obj/item/reagent_containers/hypospray/autoinjector/lux/apply(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return

	var/turf/T = get_turf(user)
	var/delay = 100 // 10  SECONDS

	if(isspaceturf(T))
		delay = 0

	var/area/A = get_area(T)
	if(istype(A, /area/lavaland))
		delay = 0

	if(lavaland_equipment_pressure_check(T))
		delay = 0

	if(delay)
		user.visible_message("<span class='notice'>[user] begins injecting [M] with [src]...</span>")
		if(!do_after(user, delay, 1, M, TRUE))
			return
	else
		user.visible_message("<span class='notice'>[user] instantly injects [M] with [src]!</span>")

	return ..()
