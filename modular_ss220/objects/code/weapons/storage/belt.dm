/obj/item/storage/belt/sheath/saber
	icon = 'modular_ss220/objects/icons/belts.dmi'
	icon_override = 'modular_ss220/mobs/icons/mob/belts.dmi'
	var/base_name = "sheath"
	icon_state = "sheath_classic"
	item_state = "sheath_classic"
	base_icon_state = "sheath_classic"
	can_hold = list(/obj/item/melee/saber)

	/// allows one-time reskinning
	var/is_unique_reskin_available = TRUE
	/// the skin choices
	var/list/options = list("Классика" = "classic", "Церемониальный" = "ceremonial", "Шашка" = "cossack")
	var/current_skin = "classic"

/obj/item/storage/belt/sheath/saber/examine(mob/user)
	. = ..()
	if(is_unique_reskin_available)
		. += span_notice("<b>Ctrl-click</b>, В вашей руке, чтобы единожды выбрать внешний вид.")

/obj/item/storage/belt/sheath/saber/CtrlClick(mob/user)
	. = ..()
	if(!is_unique_reskin_available)
		to_chat(user, span_warning("Внешний вид уже выбран!") )
		return
	if(!user.is_holding(src))
		to_chat(user, span_warning("Вы должны взять пояс в руки, чтобы сделать это."))
		return
	if(user.incapacitated())
		to_chat(user, span_warning("Вы не можете этого сделать прямо сейчас!"))
		return
	if(!length(contents))
		to_chat(user, span_warning("Чтобы это сделать меч должен быть внутри!"))
		return
	reskin(user, contents[1])

/obj/item/storage/belt/sheath/saber/proc/reskin(mob/living/carbon/human/M, obj/item/melee/saber/S)
	var/list/skins = list()
	for(var/I in options)
		skins[I] = image(icon, icon_state = "[base_name]_[options[I]]-sword")
	var/choice = show_radial_menu(M, src, skins, radius = 40, custom_check = CALLBACK(src, PROC_REF(reskin_radial_check), M), require_near = TRUE)

	if(choice)
		current_skin = options[choice]
		S.reskin(current_skin)
		to_chat(M, "[choice] идеально вам подходит.")
		is_unique_reskin_available = FALSE
		base_icon_state = "[base_name]_[current_skin]"
		update_icon()
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/obj/item/storage/belt/sheath/saber/proc/reskin_radial_check(mob/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!src || !H.is_in_hands(src) || HAS_TRAIT(H, TRAIT_HANDS_BLOCKED))
		return FALSE
	return TRUE
