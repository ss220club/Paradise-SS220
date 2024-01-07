/datum/vox_pack
	var/name = "DEBUG Vox Pack"
	var/desc = "Описание отсутствует. Сообщите разработчику."
	var/reference = null
	var/cost = -1	// -1 = hide
	var/amount
	var/category
	var/list/contains = list()

	var/list/ui_manifest = list()

/datum/vox_pack/New()
	. = ..()
	for(var/path in contains)
		if(!path)
			continue
		var/atom/movable/AM = path
		var/icon/I = icon(initial(AM.icon), initial(AM.icon_state))
		ui_manifest += "<big>[bicon(I)]</big> [initial(AM.name)]"	// !!!! проверяем отобразится ли иконка

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
