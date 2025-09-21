/obj/item/storage/bag
	var/updates_weight_on_fill = FALSE

/obj/item/storage/bag/bio
	max_combined_w_class = 30
	storage_slots = 30
	updates_weight_on_fill = TRUE
	prefered_slot_flags = ITEM_SLOT_BELT

/obj/item/storage/bag/chemistry
	max_combined_w_class = 30
	storage_slots = 30
	updates_weight_on_fill = TRUE
	prefered_slot_flags = ITEM_SLOT_BELT

/obj/item/storage/bag/plants
	updates_weight_on_fill = TRUE
	prefered_slot_flags = ITEM_SLOT_BELT

/obj/item/storage/bag/trash
	updates_weight_on_fill = TRUE

/obj/item/storage/bag/proc/update_weight()
	if(!updates_weight_on_fill)
	    return
    w_class = length(contents) ? WEIGHT_CLASS_BULKY : WEIGHT_CLASS_SMALL

/obj/item/storage/bag/remove_from_storage(obj/item/I, atom/new_location)
	. = ..()
	update_weight()

/obj/item/storage/bag/can_be_inserted(obj/item/I, stop_messages = FALSE)
	if(!updates_weight_on_fill)
	    return ..()
    if(isstorage(loc) && !istype(loc, /obj/item/storage/backpack/holding))
		to_chat(usr, span_warning("У вас не получается поместить [I] в [src]!"))
		return FALSE
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.l_store == src || H.r_store == src)
			to_chat(usr, span_warning("У вас не получается поместить [I] в [src]!"))
			return FALSE
	return ..()

/obj/item/storage/bag/Initialize(mapload)
	. = ..()
	update_weight()

/obj/item/storage/bag/handle_item_insertion(obj/item/I, mob/user, prevent_warning)
	. = ..()
	update_weight()
