/obj/machinery/vox_shop
	name = "Киконсоль Закиказов"
	desc = "Технология связывающая воксов на дальних рубежах."
	icon = 'modular_ss220/antagonists/icons/trader_machine.dmi'
	icon_state = "trader-idle-off"
	max_integrity = 5000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = TRUE
	var/cash_stored = 0

	var/list/packs_cats = list()	// Категории по предметам - ui_static_data
	var/list/packs_items = list()	// Все доступные предметы -

	var/list/cart_list
	var/list/cart_data


// ============ DATA ============

/obj/machinery/vox_shop/Initialize(mapload)
	. = ..()
	generate_pack_items()
	generate_pack_lists()

/obj/machinery/vox_shop/proc/generate_pack_items()
	var/list/shop_items = list()
	for(var/path in subtypesof(/datum/vox_pack))
		var/datum/vox_pack/pack = new path
		if(pack.cost < 0)
			continue
		//if(pack.limited_stock >= 0 && pack.purchased >= pack.limited_stock)
		//	continue	// !!!! перенести потом в проверку покупки
		if(!shop_items[pack.category])
			shop_items[pack.category] = list()
		shop_items[pack.category] += pack

	packs_items = shop_items

/obj/machinery/vox_shop/proc/generate_pack_lists()
	var/list/cats = list()
	for(var/category in packs_items)
		cats[++cats.len] = list("cat" = category, "items" = list())
		for(var/datum/vox_pack/pack in packs_items[category])
			cats[cats.len]["items"] += list(list(
				"name" = sanitize(pack.name),
				"desc" = sanitize(pack.description()),
				"cost" = pack.cost,
				"contents" = pack.ui_manifest,
				"obj_path" = pack.reference))
			packs_items[pack.reference] = pack

	packs_cats = cats


// ======= Interaction ==========

/obj/machinery/vox_shop/attack_hand(mob/user)
	if(!check_usable(user))
		return
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/vox_shop/proc/check_usable(mob/user)
	. = FALSE

	if(user) 			// !!!!! времянка
		return TRUE 	// !!!!! времянка

	if(issilicon(user))
		return
	if(!isvox(user))
		to_chat(user, span_notice("Вы осматриваете [src] и не понимаете как оно работает и куда сувать свои пальцы..."))
		return
	return TRUE

/obj/machinery/vox_shop/attack_ai(mob/user)
	return FALSE



/obj/machinery/vox_shop/attackby(obj/item/O, mob/user, params)
	. = ..()
	if(istype(O, /obj/item/stack/vox_cash))
		insert_cash(/obj/item/stack/vox_cash, user)

/obj/machinery/vox_shop/proc/insert_cash(obj/item/stack/vox_cash, mob/user)
	visible_message("<span class='info'>[user] загрузил [vox_cash] в [src].</span>")
	cash_stored += vox_cash.amount
	vox_cash.use(vox_cash.amount)
	return TRUE


// ============= UI =============

/obj/machinery/vox_shop/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Shop", name/*, 900, 800*/)
		ui.open()

/obj/machinery/vox_shop/ui_data(mob/user)
	var/list/data = list()

	data["cash"] = cash_stored
	data["cart"] = generate_tgui_cart()
	data["cart_price"] = calculate_cart_cash()

	var/list/vox_raider_members = list()
	for(var/datum/team/vox_raiders_team/team in subtypesof(/datum/team/vox_raiders_team))
		vox_raider_members.Add(team.members)
	data["vox_members"] = vox_raider_members
	// data["crewmembers"] = GLOB.crew_repository.health_data(viewing_current_z_level)
	// data["critThreshold"] = HEALTH_THRESHOLD_CRIT

	return data

/obj/machinery/vox_shop/ui_static_data(mob/user)
	var/list/static_data = list()

	if(!packs_cats || !packs_items)
		generate_pack_lists(user)
	//static_data["packs"] = packs_items
	static_data["cats"] = packs_cats

	return static_data

/obj/machinery/vox_shop/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return

	. = TRUE

	switch(action)
		if("add_to_cart")
			var/datum/vox_pack/pack = packs_items[params["item"]]
			if(LAZYIN(cart_list, params["item"]))
				to_chat(ui.user, "<span class='warning'>[pack.name] is already in your cart!</span>")
				return
			var/startamount = 1
			LAZYSET(cart_list, params["item"], startamount)
			generate_tgui_cart(TRUE)

		if("remove_from_cart")
			remove_from_cart(params["item"])

		if("set_cart_item_amount")
			var/amount = text2num(params["amount"])
			LAZYSET(cart_list, params["item"], max(amount, 0))
			generate_tgui_cart(TRUE)

		if("purchase_cart")
			if(!LAZYLEN(cart_list))
				return
			if(calculate_cart_cash() > cash_stored)
				to_chat(ui.user, "<span class='warning'>[src] недостаточно кикиридитов! Неси больше!</span>")
				return

			var/list/bought_objects = list()
			for(var/reference in cart_list)
				var/datum/vox_pack/pack = packs_items[reference]
				var/amount = cart_list[reference]
				if(amount <= 0)
					continue
				bought_objects += get_purchase(pack, pack ? pack.reference : "", amount)

			// Сортируем предметы в отдельные емкости
			var/is_heavy = FALSE
			var/list/obj/item/items_for_contain = list()
			for(var/obj/item/item in bought_objects)
				items_for_contain += item
				if(item.w_class >= WEIGHT_CLASS_NORMAL)
					is_heavy = TRUE
			if(length(items_for_contain) > 2)
				var/container_type = is_heavy ? /obj/structure/closet/crate : /obj/item/storage/box
				var/obj/container = new container_type(get_turf(src))
				for(var/obj/item/item as anything in items_for_contain)
					item.forceMove(container)
			else if(length(items_for_contain))
				for(var/obj/item/item as anything in items_for_contain)
					ui.user.put_in_any_hand_if_possible(item)

			empty_cart()
			SStgui.update_uis(src)

		if("empty_cart")
			empty_cart()


// ========== UI Procs ==========

/obj/machinery/vox_shop/proc/get_purchase(datum/vox_pack/pack, reference, amount = 1)
	if(!pack)
		return
	if(amount <= 0)
		return
	var/list/bought_objects = list()
	for(var/i in 1 to amount)
		var/items_list = pack.create_package(src, usr, put_in_hands = FALSE)
		if(!length(items_list))
			break
		bought_objects += items_list

	return bought_objects

/obj/machinery/vox_shop/proc/calculate_cart_cash()
	. = 0
	for(var/reference in cart_list)
		var/datum/vox_pack/item = packs_items[reference]
		var/amount = cart_list[reference]
		. += item.cost * amount

/obj/machinery/vox_shop/proc/generate_tgui_cart(update = FALSE)
	if(!update)
		return cart_data

	if(!length(cart_list))
		cart_list = null
		cart_data = null
		return cart_data

	cart_data = list()
	for(var/reference in cart_list)
		var/datum/vox_pack/pack = packs_items[reference]
		cart_data += list(list(
			"name" = pack.name,
			"desc" = pack.desc,
			"cost" = pack.cost,
			"obj_path" = pack.reference,
			"contents" = pack.ui_manifest,
			"amount" = cart_list[reference],
			"limit" = pack.limited_stock))

		// !!!!!!!!!! разобраться в ошибке с неправильно заносящимися items
		// заношу я как supply_pack, а в .js как в uplink_item

/obj/machinery/vox_shop/proc/remove_from_cart(item_reference)
	LAZYREMOVE(cart_list, item_reference)
	generate_tgui_cart(TRUE)

/obj/machinery/vox_shop/proc/empty_cart()
	cart_list = null
	generate_tgui_cart(TRUE)
