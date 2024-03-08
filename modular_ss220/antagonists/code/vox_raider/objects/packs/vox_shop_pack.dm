/datum/vox_pack
	var/name = "DEBUG Vox Pack"
	var/desc = "Описание отсутствует. Сообщите разработчику."
	var/reference = null
	var/cost = -1	// -1 = hide
	var/is_need_trader_cost = TRUE // Is need an additional cost on top of the cost from the “trader machine”
	var/limited_stock = -1 // Can you only buy so many? -1 allows for infinite purchases
	var/purchased = 0	// How much have you already bought?
	var/amount = 1
	var/category = VOX_PACK_MISC
	var/list/contains = list()

/datum/vox_pack/proc/get_items_list(mob/user, put_in_hands = TRUE)
	var/list/items_list = list()
	for(var/typepath in contains)
		if(!typepath)
			continue
		for(var/i in 1 to amount)
			items_list.Add(typepath)
	return items_list

/datum/vox_pack/proc/check_possible_buy(amount)
	if(limited_stock >= 0 && (purchased + amount > limited_stock))
		return FALSE
	return TRUE

/datum/vox_pack/proc/description()
	if(!desc)
		desc = replacetext(desc, "\n", "<br>")
	return desc
