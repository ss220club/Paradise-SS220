// =================================
// Награды выдаваемые за часы проведенные в отделе
// =================================
/obj/item/clothing/accessory/rank
	name = "голографические погоны"
	desc = "Погоны выдаваемые при выслуге лет. Наденьте их и каждый увидит ваше звание."
	icon = 'modular_ss220/ranks/icons/clothing/attachments.dmi'
	icon_override = 'modular_ss220/ranks/icons/clothing/mob/attachments_overlay.dmi'
	icon_state = "holobadge"
	item_state = "" // No inhands
	item_color = "holobadge"
	slot_flags = SLOT_FLAG_TIE
	w_class = WEIGHT_CLASS_TINY
	slot = ACCESSORY_SLOT_DECOR
	allow_duplicates = FALSE // Allow accessories of the same type.
	var/datum/mind/owner
	var/saved_real_name
	var/list/exp_types
	var/add_job_req_exp = FALSE
	var/list/rank_exp_order_dict // Rank and exp map hours from which it will be awarded

/obj/item/clothing/accessory/rank/Initialize(mapload)
	. = ..()
	inv_overlay = image("icon" = 'modular_ss220/ranks/icons/clothing/mob/attachments_overlay.dmi', "icon_state" = "[item_color? "[item_color]" : "[icon_state]"]")
	if(!length(rank_exp_order_dict) || !(length(exp_types)))
		qdel(src)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		owner = H.mind
		get_rank_name(H)

// ============= Attach&Pick =============
/obj/item/clothing/under/attach_accessory(obj/item/clothing/accessory/A, mob/user, unequip = FALSE)
	if(istype(A, /obj/item/clothing/accessory/rank))
		var/obj/item/clothing/accessory/rank/attachment = A
		if(!attachment.check_allowed_to_attach(user))
			to_chat(user, span_warning("При приближении к цели, [src.name] деактивируется!"))
			return FALSE
	. = ..()

/obj/item/clothing/accessory/rank/attack(mob/living/carbon/human/H, mob/living/user)
	. = TRUE
	if(!check_allowed_to_attach(H))
		to_chat(user, span_warning("При приближении к [H], [src.name] деактивируется!"))
		return FALSE
	. = ..()

// Clothing equip at human
/obj/item/clothing/accessory/rank/attached_equip(mob/user)
	saved_real_name = user.real_name
	user.rename_character(user.real_name, get_rank_name(user))

	. = ..()

// Clothing drop from human
/obj/item/clothing/accessory/rank/attached_unequip(mob/user)
	user.rename_character(user.real_name, saved_real_name)

	. = ..()

/obj/item/clothing/accessory/rank/on_attached(obj/item/clothing/under/S, mob/user as mob)
	attached_equip(user)
	. = ..()

/obj/item/clothing/accessory/rank/on_removed(mob/user)
	attached_unequip(user)
	. = ..()

/obj/item/clothing/accessory/rank/proc/check_allowed_to_attach(mob/user)
	if(!user.mind)
		to_chat(user, span_warning("[src.name] слетели с [user], не зафиксировав в нём отклика разума."))
		return FALSE

	if(!owner)
		owner = user.mind
		return TRUE

	if(user.mind == owner)
		return TRUE

	return FALSE

// ============= Initial Name =============
/obj/item/clothing/accessory/rank/proc/get_rank_name(mob/user)
	var/exp_sum = 0
	var/datum/job/job_req
	if(add_job_req_exp)
		job_req = SSjobs.GetJob(user.job)
	var/list/play_records = params2list(user.client.prefs.exp)
	for(var/exp_type in exp_types)
		if(!(exp_type in play_records))
			continue
		exp_sum += (text2num(play_records[exp_type]) - (job_req ? job_req.exp_map[exp_type] : 0)) / 60 // Конвертируем из минус в часы

	var/choosen_rank
	for(var/rank in rank_exp_order_dict)
		if(exp_sum >= rank_exp_order_dict[rank])
			choosen_rank = rank
		else
			break

	var/rank_name = "[choosen_rank] [user.real_name]"
	name = "[initial(name)] [rank_name]"
	return rank_name
