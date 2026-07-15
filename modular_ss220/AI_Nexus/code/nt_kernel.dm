/obj/machinery/computer/nt_kernel
	name = "консоль NT Operating System Kernel"
	desc = "Терминал глубинного доступа к системам управления станцией. Требует физический ключ доступа."
	icon_keyboard = "id_key"
	icon_screen = "id"
	circuit = /obj/item/circuitboard/nt_kernel // заведёшь плату отдельно

	/// Вставленная перфокарта
	var/obj/item/perfocard/inserted_card
	/// TRUE пока идёт процесс авторизации
	var/authorizing = FALSE
	/// TRUE после успешной проверки — доступно главное меню
	var/authorized = FALSE

/obj/machinery/computer/nt_kernel/Destroy()
	if(inserted_card)
		qdel(inserted_card)
		inserted_card = null
	return ..()

/obj/machinery/computer/nt_kernel/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/perfocard))
		if(inserted_card)
			to_chat(user, SPAN_WARNING("В консоли уже установлена перфокарта."))
			return ITEM_INTERACT_COMPLETE
		used.forceMove(src)
		inserted_card = used
		to_chat(user, SPAN_NOTICE("Вы вставляете перфокарту в считыватель."))
		updateUsrDialog()
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/machinery/computer/nt_kernel/proc/eject_card(mob/user)
	if(!inserted_card)
		return
	authorized = FALSE
	authorizing = FALSE
	inserted_card.forceMove(get_turf(src))
	if(user && Adjacent(user))
		user.put_in_hands(inserted_card)
	inserted_card = null

/obj/machinery/computer/nt_kernel/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/computer/nt_kernel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NTKernelConsole")
		ui.open()

/obj/machinery/computer/nt_kernel/ui_data(mob/user)
	var/list/data = list()
	data["card_inserted"] = !!inserted_card
	data["card_name"] = inserted_card?.name
	data["authorizing"] = authorizing
	data["authorized"] = authorized
	return data

/obj/machinery/computer/nt_kernel/ui_act(action, list/params)
	if(..())
		return
	. = TRUE
	switch(action)
		if("eject_card")
			eject_card(usr)
			return
		if("authorize")
			if(!inserted_card || authorizing || authorized)
				return
			authorizing = TRUE
			addtimer(CALLBACK(src, PROC_REF(finish_authorize)), 10 SECONDS)
			return
		if("logout")
			authorized = FALSE
			return

/obj/machinery/computer/nt_kernel/proc/finish_authorize()
	authorizing = FALSE
	if(!inserted_card) // карту могли выдернуть во время загрузки
		return
	authorized = TRUE

// ─────────────────────────────────────────
// CIRCUIT BOARDS
// ─────────────────────────────────────────

/obj/item/circuitboard/nt_kernel
	board_name = "консоль NT Operating System Kernel"
	icon_state = "command"
	build_path = /obj/machinery/computer/nt_kernel
	origin_tech = "programming=5;engineering=5"

/obj/item/circuitboard/nt_kernel_broken
	board_name = "консоль NT Operating System Kernel"
	desc = SPAN_WARNING("The board is charred and smells of burnt plastic. It has been rendered useless.")
	icon_state = "command_broken"
