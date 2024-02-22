/datum/vox_pack
	var/name = "DEBUG Vox Pack"
	var/desc = "Описание отсутствует. Сообщите разработчику."
	var/reference = null
	var/cost = -1	// -1 = hide
	var/limited_stock = -1 // Can you only buy so many? -1 allows for infinite purchases
	var/purchased = 0	// How much have you already bought?
	var/amount = 1
	var/category = VOX_PACK_MISC
	var/list/contains = list()

	var/list/ui_manifest = list()

/datum/vox_pack/proc/get_items_list(mob/user, put_in_hands = TRUE)
	var/list/items_list = list()
	for(var/typepath in contains)
		if(!typepath)
			continue
		for(var/i in 1 to amount)
			items_list.Add(typepath)
	return items_list

/datum/vox_pack/proc/description()
	if(!desc)
		desc = replacetext(desc, "\n", "<br>")
	return desc

// /datum/vox_pack/New()
// 	. = ..()
// 	make_ui_manifest()

/datum/vox_pack/proc/make_ui_manifest()
	for(var/path in contains)
		if(!path)
			continue
		var/atom/movable/AM = path
		var/I = "[icon2base64(icon(initial(AM.icon), initial(AM.icon_state), SOUTH, 1))]"
		ui_manifest.Add(list(initial(AM.name) = I))
		//var/icon/I = icon(initial(AM.icon), initial(AM.icon_state))
		//ui_manifest.Add(list(initial(AM.name) = I))
