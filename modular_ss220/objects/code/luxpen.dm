#define INJECTION_TIME 10 SECONDS

/obj/item/reagent_containers/hypospray/autoinjector/lux //Является модулем

	name = "Люкс медипен"
	desc = "Продвинутая версия survival medipen, содержащая высококачественные реагенты. Из-за давления внутри медипена рекомендуется использовать в среде с пониженым давлением  *WARNING не использовать больше двух медипенов одновременно, возможен риск остановки сердца*"
	icon = 'modular_ss220/objects/icons/luxpen.dmi'
	icon_state = "luxpen"
	volume = 40
	amount_per_transfer_from_this = 40
	list_reagents = list("adv_lava_extract" = 10, "teporone" = 10, "salbutamol" = 10, "hydrocodone" = 10)

/obj/item/reagent_containers/hypospray/autoinjector/lux/apply(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("[src] is empty!"))
		return

	var/turf/T = get_turf(user)
	var/delay = INJECTION_TIME

	if(isspaceturf(T))
		delay = 0

	var/area/A = get_area(T)
	if(istype(A, /area/lavaland))
		delay = 0

	if(lavaland_equipment_pressure_check(T))
		delay = 0

	if(delay)
		user.visible_message(SPAN_NOTICE("[user] begins injecting [M] with [src]..."))
		if(!do_after(user, delay, 1, M, TRUE))
			return
	else
		user.visible_message(SPAN_NOTICE("[user] instantly injects [M] with [src]!"))

	return ..()

#undef INJECTION_TIME
