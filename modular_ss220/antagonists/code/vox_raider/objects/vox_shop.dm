/obj/machinery/vox_shop
	name = "Киконсоль Закиказов"
	desc = "Технология связывающая воксов на дальних рубежах."
	icon = 'modular_ss220/antagonists/icons/trader_machine.dmi'
	icon_state = "trader-idle-off"
	max_integrity = 5000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = TRUE
	var/insert_points = 0

/obj/machinery/vox_shop/attack_hand(mob/user)
	if(!check_usable(user))
		return
	add_fingerprint(user)
	INVOKE_ASYNC(src, PROC_REF(do_trade, user))


/obj/machinery/vox_trader/proc/check_usable(mob/user)
	. = FALSE

	if(issilicon(user))
		return

	if(!isvox(user))
		to_chat(user, span_notice("Вы осматриваете [src] и не понимаете как оно работает и куда сувать свои пальцы..."))
		return

	return TRUE

/obj/machinery/vox_shop/attack_ai(mob/user)
	return FALSE

/obj/machinery/computer/supplycomp/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "VoxShop", name, 900, 800, master_ui, state)
		ui.open()

/obj/machinery/computer/supplycomp/ui_data(mob/user)
	var/list/data = list()

	data["equipments"] =
	data["raider_equipments"] =
	data["mercenary_equipments"] =
	data["goods"] =
	data["points"] = insert_points

	return data

/obj/machinery/computer/supplycomp/ui_static_data(mob/user)
	var/list/static_data = list()
	var/list/packs_list = list()

	for(var/pack_type in subtypesof(/datum/vox_pack))
		var/datum/vox_pack/pack = new pack_type
		if((pack.hidden))
			packs_list.Add(list(list(
				"name" = pack.name,
				"cost" = pack.cost,
				"ref" = "[pack.UID()]",
				"contents" = pack.ui_manifest,
				"cat" = pack.group)))

	static_data["supply_packs"] = packs_list

	var/list/categories = list()
	for(var/category in SSeconomy.all_supply_groups)
		categories.Add(list(list("name" = get_supply_group_name(category), "category" = category)))

	static_data["categories"] = categories

	return static_data



/obj/machinery/computer/supplycomp/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return

	var/mob/user = ui.user

	// If its not a public console, and they aint authed, dont let them use this
	if(!is_public && !is_authorized(user))
		return

	. = TRUE
	add_fingerprint(user)

	switch(action)
		if("moveShuttle")
			move_shuttle(user)
