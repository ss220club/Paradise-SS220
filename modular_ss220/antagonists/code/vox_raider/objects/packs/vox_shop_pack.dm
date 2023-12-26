/datum/vox_pack
	var/name = "DEBUG Vox Pack"
	var/desc = "Описание отсутствует. Сообщите разработчику."
	var/cost = 0
	var/amount
	var/list/contains = list()
	/// name = icon
	var/list/ui_manifest = list()

/datum/vox_pack/New()
	. = ..()
	for(var/path in contains)
		if(!path)
			continue
		var/atom/movable/AM = path
		ui_manifest += list("[initial(AM.name)]" = initial(AM.item_color))

/datum/supply_packs/proc/create_package(turf/spawn_location)
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
