/**
 * NT Operating System Kernel — консоль управления системами станции (КУД).
 *
 * Перфокарта (/obj/item/perfocard) определена отдельно в perfocards.dm.
 *
 * Этап 1: только каркас — вставка/извлечение карты, авторизация с задержкой,
 * заглушка главного меню. Логика "Модулей ИИ" и "Красной кнопки" — следующий этап.
 */

// ══════════════════════════════════════════════════════════════════════════
// ПЛАТА КОНСОЛИ
// ══════════════════════════════════════════════════════════════════════════

/obj/item/circuitboard/computer/nt_kernel
	name = "плата (NT Operating System Kernel)"
	build_path = /obj/machinery/computer/nt_kernel
	origin_tech = "programming=4;engineering=4"

// ══════════════════════════════════════════════════════════════════════════
// КОНСОЛЬ КУД
// ══════════════════════════════════════════════════════════════════════════

/// Время авторизации по умолчанию (для перфокарты 1 уровня)
#define NT_KERNEL_AUTH_TIME_TIER1 (10 SECONDS)
/// Время авторизации для перфокарты 2 уровня (Т2)
#define NT_KERNEL_AUTH_TIME_TIER2 (15 SECONDS)

/obj/machinery/computer/nt_kernel
	name = "консоль NT Operating System Kernel"
	desc = "Терминал глубинного доступа к системам управления станцией. Требует физический ключ доступа."
	icon_keyboard = "id_key"
	icon_screen = "id"
	circuit = /obj/item/circuitboard/computer/nt_kernel

	/// Вставленная перфокарта
	var/obj/item/perfocard/inserted_card
	/// TRUE пока идёт процесс авторизации
	var/authorizing = FALSE
	/// TRUE после успешной проверки — доступно главное меню
	var/authorized = FALSE
	/// Таймер текущей авторизации (чтобы можно было отменить при выдёргивании карты)
	var/authorize_timer_id
	/// TRUE на пару секунд, если карту выдернули прямо во время авторизации — показывает экран ошибки
	var/error_state = FALSE
	/// Таймер сброса экрана ошибки
	var/error_timer_id

/obj/machinery/computer/nt_kernel/Destroy()
	if(inserted_card)
		qdel(inserted_card)
		inserted_card = null
	deltimer(authorize_timer_id)
	deltimer(error_timer_id)
	return ..()

/obj/machinery/computer/nt_kernel/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/perfocard))
		if(inserted_card)
			to_chat(user, SPAN_WARNING("В консоли уже установлена перфокарта."))
			return ITEM_INTERACT_COMPLETE
		user.drop_item()
		used.forceMove(src)
		inserted_card = used
		to_chat(user, SPAN_NOTICE("Вы вставляете перфокарту в считыватель."))
		SStgui.update_uis(src)
		return ITEM_INTERACT_COMPLETE
	return ..()

/obj/machinery/computer/nt_kernel/proc/eject_card(mob/user)
	if(!inserted_card)
		return
	var/was_authorizing = authorizing
	authorized = FALSE
	authorizing = FALSE
	deltimer(authorize_timer_id)
	authorize_timer_id = null
	inserted_card.forceMove(get_turf(src))
	if(user && ishuman(user) && Adjacent(user) && !user.get_active_hand())
		user.put_in_hands(inserted_card)
	inserted_card = null
	if(was_authorizing)
		trigger_error()
	else
		SStgui.update_uis(src)

/// Показывает на экране красный экран ошибки на пару секунд, затем сбрасывает на начальный экран
/obj/machinery/computer/nt_kernel/proc/trigger_error()
	error_state = TRUE
	deltimer(error_timer_id)
	error_timer_id = addtimer(CALLBACK(src, PROC_REF(clear_error)), 2 SECONDS, TIMER_STOPPABLE)
	SStgui.update_uis(src)

/obj/machinery/computer/nt_kernel/proc/clear_error()
	error_state = FALSE
	error_timer_id = null
	SStgui.update_uis(src)

/obj/machinery/computer/nt_kernel/attack_hand(mob/user)
	if(..())
		return
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("Консоль обесточена!"))
		return
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("Консоль сломана!"))
		return
	add_fingerprint(user)
	ui_interact(user)

/// Быстрое извлечение перфокарты альт-кликом — без открытия интерфейса
/obj/machinery/computer/nt_kernel/AltClick(mob/user)
	. = ..()
	if(!istype(user) || user.incapacitated() || !Adjacent(user))
		return
	if(!inserted_card)
		return
	if(stat & (NOPOWER | BROKEN))
		return
	eject_card(user)

/obj/machinery/computer/nt_kernel/attack_ghost(mob/user)
	return ui_interact(user)

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
	data["card_icon"] = inserted_card ? "[inserted_card.icon]" : null
	data["card_icon_state"] = inserted_card?.icon_state
	data["authorizing"] = authorizing
	data["authorized"] = authorized
	data["error_state"] = error_state
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
			var/auth_time = (inserted_card.access_tier >= 2) ? NT_KERNEL_AUTH_TIME_TIER2 : NT_KERNEL_AUTH_TIME_TIER1
			authorize_timer_id = addtimer(CALLBACK(src, PROC_REF(finish_authorize)), auth_time, TIMER_STOPPABLE)
			return
		if("logout")
			authorized = FALSE
			return

/obj/machinery/computer/nt_kernel/proc/finish_authorize()
	authorizing = FALSE
	authorize_timer_id = null
	if(!inserted_card) // карту могли выдернуть во время загрузки — eject_card() уже разрулил ошибку
		return
	authorized = TRUE
	SStgui.update_uis(src)

#undef NT_KERNEL_AUTH_TIME_TIER1
#undef NT_KERNEL_AUTH_TIME_TIER2
