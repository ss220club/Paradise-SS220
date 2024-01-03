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

	var/list/packs_list = list()
	var/list/packs_data = list()

	var/list/packs_cats = list()

	var/list/cart_list
	var/list/cart_data

/obj/machinery/vox_shop/Initialize(mapload)
	. = ..()
	generate_packs_list()

/obj/machinery/vox_shop/generate_packs_list()
	packs_list = subtypesof(/datum/vox_pack)

	for(var/pack_type in packs_list)
		var/datum/vox_pack/pack = new pack_type
		if(pack.cost < 0)
			continue
		packs_data.Add(list(list(
			"name" = pack.name,
			"desc" = pack.desc,
			"cost" = pack.cost,
			"ref" = "[pack.UID()]",
			"contents" = pack.ui_manifest,
			"category" = pack.category,
			)))

	for(var/category in VOX_PACK_AMOUNT)
		packs_cats.Add(list(list("name" = get_category_name(category), "category" = category)))

/obj/machinery/vox_shop/proc/get_category_name(category)
	switch(category)
		if(VOX_PACK_CONSUMABLES)
			return "Расходники"
		if(VOX_PACK_EQUIPMENT)
			return "Экипировка"
		if(VOX_PACK_RAIDER)
			return "Снаряжение Рейдеров"
		if(VOX_PACK_MERCENARIES)
			return "Снаряжение Наемников"
		if(VOX_PACK_GOODS)
			return "Товары"

/obj/machinery/vox_shop/attack_hand(mob/user)
	if(!check_usable(user))
		return
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/vox_shop/proc/check_usable(mob/user)
	. = FALSE
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

/obj/machinery/vox_shop/proc/insert_cash(obj/item/stack/vox_cash/cash_insert, mob/user)
	visible_message("<span class='info'>[user] загрузил [cash_insert] в [src].</span>")
	cash_stored += cash_insert.amount
	cash_insert.use(cash_insert.amount)
	return TRUE

/obj/machinery/vox_shop/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "VoxShop", name, 900, 800, master_ui, state)
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

	static_data["packs"] = packs_data
	static_data["cats"] = packs_cats

	return static_data

/obj/machinery/vox_shop/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return

	. = TRUE

	switch(action)
		if("add_to_cart")
			var/datum/vox_pack/pack = packs_list[params["item"]]
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
				var/datum/vox_pack/pack = packs_list[reference]
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
		var/datum/vox_pack/item = packs_list[reference]
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
		var/datum/vox_pack/pack = packs_list[reference]
		cart_data += list(list(
			"name" = pack.name,
			"desc" = pack.desc,
			"cost" = pack.cost,
			"ref" = "[pack.UID()]",
			"contents" = pack.ui_manifest,
			"category" = pack.category,
			"amount" = cart_list[reference]))

/obj/machinery/vox_shop/proc/remove_from_cart(item_reference) // i want to make it eventually remove all instances
	LAZYREMOVE(cart_list, item_reference)
	generate_tgui_cart(TRUE)

/obj/machinery/vox_shop/proc/empty_cart()
	cart_list = null
	generate_tgui_cart(TRUE)

