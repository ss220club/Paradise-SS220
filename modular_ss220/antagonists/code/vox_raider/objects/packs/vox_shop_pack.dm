/datum/vox_pack
	var/name = "DEBUG Vox Pack"
	var/desc = "Описание отсутствует. Сообщите разработчику."
	var/reference = null
	var/cost = -1	// -1 = hide
	var/limited_stock = -1 // Can you only buy so many? -1 allows for infinite purchases
	var/purchased = 0	// How much have you already bought?
	var/amount
	var/category = VOX_PACK_MISC
	var/list/contains = list()

	var/list/ui_manifest = list()

/datum/vox_pack/New()
	. = ..()
	for(var/path in contains)
		if(!path)
			continue
		var/atom/movable/AM = path
		var/icon/I = icon(initial(AM.icon), initial(AM.icon_state))
		ui_manifest += "[initial(AM.name)]"	// !!!! проверяем отобразится ли иконка
		//ui_manifest += "<big>[bicon(I)]</big> [initial(AM.name)]"	// !!!! проверяем отобразится ли иконка

/datum/vox_pack/proc/create_package(turf/spawn_location, mob/user, put_in_hands = TRUE)
	var/list/items_list = list()
	for(var/typepath in contains)
		if(!typepath)
			continue

		var/atom/atom = new typepath(spawn_location)
		items_list.Add(atom)

		if(amount)
			if(isstack(atom))
				var/obj/item/stack/mats = atom
				mats.amount = amount
			else
				for(var/i in amount-1)
					var/atom/temp_atom = new typepath(spawn_location)
					items_list.Add(temp_atom)

	return items_list

/datum/vox_pack/proc/description()
	if(!desc)
		// Fallback description
		//var/obj/temp = src.item
		//desc = replacetext(initial(temp.desc), "\n", "<br>")
		desc = replacetext(desc, "\n", "<br>")
	return desc
