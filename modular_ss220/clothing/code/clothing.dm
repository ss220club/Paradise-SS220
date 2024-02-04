/obj/item/clothing/AltClick(mob/user)
	..()
	var/unique_reskin = FALSE
	var/current_skin
	if(user.incapacitated())
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return
	if(unique_reskin && !current_skin && loc == user)
		reskin_clothing(user)

/obj/item/clothing/proc/reskin_clothing(mob/M)
	var/list/skins = list()
	var/list/options = list()
	var/current_skin
	for(var/I in options)
		skins[I] = image(icon, icon_state = options[I])
	var/choice = show_radial_menu(M, src, skins, radius = 40, custom_check = CALLBACK(src, PROC_REF(reskin_radial_check), M), require_near = TRUE)

	if(choice && reskin_radial_check(M) && !current_skin)
		current_skin = options[choice]
		to_chat(M, "Your clothing is now skinned as [choice]. Say hello to your new drip.")
		update_icon()
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/obj/item/clothing/proc/reskin_radial_check(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!src || !H.is_in_hands(src) || HAS_TRAIT(H, TRAIT_HANDS_BLOCKED))
		return FALSE
	return TRUE
