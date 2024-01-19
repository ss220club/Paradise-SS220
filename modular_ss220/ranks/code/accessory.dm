// =================================
// Награды выдаваемые за часы проведенные в отделе
// =================================

/obj/item/clothing/accessory/rank
	name = "голографические погоны"
	desc = "Погоны выдаваемые при выслуге лет. Наденьте их и каждый увидит ваше звание."
	icon = 'modular_ss220/ranks/icons/clothing/attachments.dmi'
	icon_state = "holobadge"
	item_state = ""	//no inhands
	item_color = "holobadge"
	slot_flags = SLOT_FLAG_TIE
	w_class = WEIGHT_CLASS_TINY
	slot = ACCESSORY_SLOT_DECOR
	allow_duplicates = FALSE 	// Allow accessories of the same type.
	var/datum/mind/owner
	var/saved_real_name
	var/list/exp_types
	var/add_job_req_exp = FALSE
	var/list/rank_exp_order_dict	// Rank and exp map hours from which it will be awarded

/obj/item/clothing/accessory/rank/Initialize(mapload)
	. = ..()
	inv_overlay = image("icon" = 'modular_ss220/ranks/icons/clothing/mob/attachments_overlay.dmi', "icon_state" = "[item_color? "[item_color]" : "[icon_state]"]")
	if(!length(rank_exp_order_dict) || !(length(exp_types)))
		QDEL(src)


// ============= Attach&Pick =============
/obj/item/clothing/accessory/rank/pickup(mob/living/user)
	. = ..()
	check_allowed_to_attach(user)

/obj/item/clothing/accessory/on_attached(obj/item/clothing/under/S, mob/user as mob)
	. = ..()
	if(!check_allowed_to_attach(user))
		return

	saved_real_name = user.real_name
	user.rename_character(M.real_name, get_rank_name(user))

/obj/item/clothing/accessory/on_removed(mob/user)
	. = ..()
	user.rename_character(M.real_name, saved_real_name)

/obj/item/clothing/accessory/rank/attached_equip(mob/user)
	. = ..()
	if(!check_allowed_to_attach(user))
		return

	saved_real_name = user.real_name
	user.rename_character(M.real_name, get_rank_name(user))

/obj/item/clothing/accessory/rank/attached_unequip(mob/user)
	. = ..()
	user.rename_character(M.real_name, saved_real_name)

/obj/item/clothing/accessory/rank/proc/check_allowed_to_attach(mob/user)
	if(user.mind)
		to_chat(user, span_warning("[src.name] слетели с [user], не зафиксировав в нём отклика разума."))
		return FALSE
	if(!owner)
		owner = user.mind
		to_chat(user, span_notice("[src.name] привязались к [user]."))
	if(user.mind == owner)
		return TRUE
	to_chat(user, span_warning("[src.name] слетели!"))
	user.Confused(2 SECONDS)
	user.Jitter(1 SECONDS)
	if(has_suit)
		has_suit.detach_accessory(src, null)
	return FALSE


// ============= Initial Name =============
/obj/item/clothing/accessory/rank/proc/get_rank_name(mob/user)
	var/exp_sum = 0
	var/list/play_records = params2list(user.client.prefs.exp)
	for(var/exp_type in exp_types)
		if(!(exp_type in play_records))
			continue
		exp_sum += text2num(play_records[exp_type])

	var/choosen_rank
	for(var/rank in rank_exp_order_dict)
		if(exp_sum >= rank_exp_order_dict[rank])
			choosen_rank = rank
		else
			break

	var/rank_name = "[choosen_rank] [user.real_name]"
	name = "[initial(name)] [rank_name]"
	return rank_name
