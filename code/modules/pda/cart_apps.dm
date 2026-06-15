/datum/data/pda/app/status_display
	name = "Status Display"
	icon = "list-alt"
	template = "pda_status_display"
	category = "Utilities"

	var/message1	// used for status_displays
	var/message2

/datum/data/pda/app/status_display/update_ui(mob/user as mob, list/data)
	data["records"] = list(
		"message1" = message1 ? message1 : "(none)",
		"message2" = message2 ? message2 : "(none)")

/datum/data/pda/app/status_display/ui_act(action, list/params)
	if(..())
		return

	if(!pda.silent)
		playsound(pda, 'sound/machines/terminal_select.ogg', 15, TRUE)

	. = TRUE
	switch(action)
		if("SetMessage")
			if(params["msgnum"])
				switch(text2num(params["msgnum"]))
					if(1)
						message1 = tgui_input_text(usr, "Line 1", "Enter Message Text", message1, encode = FALSE)
						if(isnull(message1))
							return
					if(2)
						message2 = tgui_input_text(usr, "Line 2", "Enter Message Text", message2, encode = FALSE)
						if(isnull(message2))
							return

		if("Status")
			switch(text2num(params["statdisp"]))
				if(STATUS_DISPLAY_MESSAGE)
					post_status(STATUS_DISPLAY_MESSAGE, message1, message2)

				if(STATUS_DISPLAY_ALERT)
					post_status(STATUS_DISPLAY_ALERT, params["alert"])

				else
					post_status(text2num(params["statdisp"]))

/datum/data/pda/app/signaller
	name = "Signaler System"
	icon = "rss"
	template = "pda_signaler"
	category = "Utilities"

/datum/data/pda/app/signaller/update_ui(mob/user as mob, list/data)
	if(pda?.cartridge?.integ_signaler)
		var/obj/item/assembly/signaler/S = pda.cartridge.integ_signaler // Simpler access
		data["frequency"] = S.frequency
		data["code"] = S.code
		data["minFrequency"] = PUBLIC_LOW_FREQ
		data["maxFrequency"] = PUBLIC_HIGH_FREQ

/datum/data/pda/app/signaller/ui_act(action, list/params)
	if(..())
		return

	. = TRUE

	if(!pda.silent)
		playsound(pda, 'sound/machines/terminal_select.ogg', 15, TRUE)

	if(pda?.cartridge?.integ_signaler)
		var/obj/item/assembly/signaler/S = pda.cartridge.integ_signaler // Simpler access

		switch(action)
			if("signal")
				S.activate()

			if("freq")
				S.frequency = sanitize_frequency(text2num(params["freq"]) * 10)

			if("code")
				S.code = clamp(text2num(params["code"]), 1, 100)

/datum/data/pda/app/power
	name = "Power Monitor"
	icon = "bolt"
	template = "pda_power"
	category = "Engineering"
	update = PDA_APP_UPDATE_SLOW

	var/datum/ui_module/power_monitor/digital/pm = new

/datum/data/pda/app/power/update_ui(mob/user as mob, list/data)
	data.Add(pm.ui_data())

// All 4 args are important here because proxying matters
/datum/data/pda/app/power/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	if(!pda.silent)
		playsound(pda, 'sound/machines/terminal_select.ogg', 15, TRUE)

	. = TRUE
	// Observe
	pm.ui_act(action, params, ui, state)

/datum/data/pda/app/crew_records
	var/datum/data/record/general_records = null

/datum/data/pda/app/crew_records/update_ui(mob/user as mob, list/data)
	var/list/records = list()

	if(general_records && (general_records in GLOB.data_core.general))
		data["records"] = records
		records["general"] = general_records.fields
		return records
	else
		for(var/A in sortRecord(GLOB.data_core.general))
			var/datum/data/record/R = A
			if(R)
				records += list(list(Name = R.fields["name"], "uid" = "[R.UID()]"))
		data["recordsList"] = records
		data["records"] = null
		return null

/datum/data/pda/app/crew_records/ui_act(action, list/params)
	if(..())
		return

	. = TRUE

	if(pda && !pda.silent)
		playsound(pda, 'sound/machines/terminal_select.ogg', 15, TRUE)

	switch(action)
		if("Records")
			var/datum/data/record/R = locateUID(params["target"])
			if(R && (R in GLOB.data_core.general))
				load_records(R)
			return
		if("Back")
			general_records = null
			has_back = FALSE
			return

/datum/data/pda/app/crew_records/proc/load_records(datum/data/record/R)
	general_records = R
	has_back = TRUE

/datum/data/pda/app/crew_records/medical
	name = "Medical Records"
	icon = "heartbeat"
	template = "pda_medical"
	category = "Medical"

	var/datum/data/record/medical_records = null

/datum/data/pda/app/crew_records/medical/update_ui(mob/user as mob, list/data)
	var/list/records = ..()
	if(!records)
		return

	if(medical_records && (medical_records in GLOB.data_core.medical))
		records["medical"] = medical_records.fields

	return records

/datum/data/pda/app/crew_records/medical/load_records(datum/data/record/R)
	..(R)
	for(var/A in GLOB.data_core.medical)
		var/datum/data/record/E = A
		if(E && (E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
			medical_records = E
			break

/datum/data/pda/app/crew_records/security
	name = "Security Records"
	icon = "id-badge"
	template = "pda_security"
	category = "Security"

	var/datum/data/record/security_records = null

/datum/data/pda/app/crew_records/security/update_ui(mob/user as mob, list/data)
	var/list/records = ..()
	if(!records)
		return

	if(security_records && (security_records in GLOB.data_core.security))
		records["security"] = security_records.fields

	return records

/datum/data/pda/app/crew_records/security/load_records(datum/data/record/R)
	..(R)
	for(var/A in GLOB.data_core.security)
		var/datum/data/record/E = A
		if(E && (E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
			security_records = E
			break

/datum/data/pda/app/secbot_control
	name = "Security Bot Access"
	icon = "rss"
	template = "pda_secbot"
	category = "Security"

	var/active_uid = null

/datum/data/pda/app/secbot_control/update_ui(mob/user as mob, list/data)
	var/list/botsData = list()
	var/list/beepskyData = list()

	var/mob/living/simple_animal/bot/secbot/active_bot = locateUID(active_uid)

	if(active_bot && !QDELETED(active_bot))
		beepskyData["active"] = active_bot ? sanitize(active_bot.name) : null
		has_back = !!active_bot
		if(active_bot && !isnull(active_bot.mode))
			var/area/loca = get_area(active_bot)
			var/loca_name = sanitize(loca.name)
			beepskyData["botstatus"] = list("loca" = loca_name, "mode" = active_bot.mode)

	else
		var/botsCount = 0
		var/list/mob/living/simple_animal/bot/bots = list()
		for(var/mob/living/simple_animal/bot/secbot/SB in GLOB.bots_list)
			bots += SB
		for(var/mob/living/simple_animal/bot/ed209/ED in GLOB.bots_list)
			if(!("syndicate" in ED.faction))
				bots += ED

		for(var/mob/living/simple_animal/bot/B in bots)
			botsCount++
			if(B.loc)
				var/area/our_area = get_area(B)
				botsData[++botsData.len] = list("Name" = sanitize(B.name), "Location" = sanitize(our_area.name), "uid" = "[B.UID()]")

		if(!length(botsData))
			botsData[++botsData.len] = list("Name" = "No bots found", "Location" = "Invalid", "uid"= null)

		beepskyData["bots"] = botsData
		beepskyData["count"] = botsCount

	data["beepsky"] = beepskyData

/datum/data/pda/app/secbot_control/ui_act(action, list/params)
	if(..())
		return

	if(!pda.silent)
		playsound(pda, 'sound/machines/terminal_select.ogg', 15, TRUE)

	. = TRUE

	switch(action)
		if("control")
			active_uid = params["bot"]

		if("botlist", "Back") // "Back" is part of the PDA TGUI itself.
			active_uid = null

		if("stop", "go", "home")
			var/mob/living/simple_animal/bot/active_bot = locateUID(active_uid)
			if(active_bot && !QDELETED(active_bot))
				active_bot.handle_command(usr, action)
			else
				active_uid = null

		if("summon")
			var/mob/living/simple_animal/bot/active_bot = locateUID(active_uid)
			if(active_bot && !QDELETED(active_bot))
				active_bot.handle_command(usr, "summon", list("target" = get_turf(usr), "useraccess" = usr.get_access()))
			else
				active_uid = null

/datum/data/pda/app/mule_control
	name = "Delivery Bot Control"
	icon = "truck"
	template = "pda_mule"
	category = "Quartermaster"

	var/active_uid = null

/datum/data/pda/app/mule_control/update_ui(mob/user as mob, list/data)
	var/list/muleData = list()
	var/list/mulebotsData = list()

	var/mob/living/simple_animal/bot/mulebot/active_bot = locateUID(active_uid)

	if(active_bot && !QDELETED(active_bot))
		muleData["active"] = active_bot ? sanitize(active_bot.name) : null
		has_back = !!active_bot
		if(active_bot && !isnull(active_bot.mode))
			var/area/loca = get_area(active_bot)
			var/loca_name = sanitize(loca.name)
			muleData["botstatus"] =  list(
				"loca" = loca_name,
				"mode" = active_bot.mode,
				"home" = active_bot.home_destination,
				"powr" = (active_bot.cell ? active_bot.cell.percent() : 0),
				"retn" = active_bot.auto_return,
				"pick" = active_bot.auto_pickup,
				"load" = active_bot.load,
				"dest" = sanitize(active_bot.destination)
			)

	else
		var/mulebotsCount = 0
		for(var/mob/living/simple_animal/bot/mulebot/B in GLOB.bots_list)
			mulebotsCount++
			if(B.loc)
				var/area/our_area = get_area(B)
				mulebotsData[++mulebotsData.len] = list("Name" = sanitize(B.name), "Location" = our_area.name, "uid" = "[B.UID()]")

		if(!length(mulebotsData))
			mulebotsData[++mulebotsData.len] = list("Name" = "No bots found", "Location" = "Invalid", "uid"= null)

		muleData["bots"] = mulebotsData
		muleData["count"] = mulebotsCount

	data["mulebot"] = muleData

/datum/data/pda/app/mule_control/ui_act(action, list/params)
	if(..())
		return

	if(!pda.silent)
		playsound(pda, 'sound/machines/terminal_select.ogg', 15, TRUE)

	. = TRUE

	switch(action)
		if("control")
			active_uid = params["bot"]

		if("botlist", "Back") // "Back" is part of the PDA TGUI itself.
			active_uid = null

		if("stop", "start", "home", "unload", "target")
			var/mob/living/simple_animal/bot/active_bot = locateUID(active_uid)
			if(active_bot && !QDELETED(active_bot))
				active_bot.handle_command(usr, action)
			else
				active_uid = null

		if("set_auto_return", "set_pickup_type")
			var/mob/living/simple_animal/bot/active_bot = locateUID(active_uid)
			if(active_bot && !QDELETED(active_bot))
				active_bot.handle_command(usr, action, params)
			else
				active_uid = null

/datum/data/pda/app/supply
	name = "Supply Records"
	icon = "archive"
	template = "pda_supplyrecords"
	category = "Quartermaster"
	update = PDA_APP_UPDATE_SLOW

/datum/data/pda/app/supply/update_ui(mob/user as mob, list/data)
	var/list/supplyData = list()

	if(SSshuttle.supply.mode == SHUTTLE_CALL)
		supplyData["shuttle_moving"] = 1

	if(is_station_level(SSshuttle.supply.z))
		supplyData["shuttle_loc"] = "Station"
	else
		supplyData["shuttle_loc"] = "CentCom"

	supplyData["shuttle_time"] = "([SSshuttle.supply.timeLeft(600)] Mins)"

	var/supplyOrderCount = 0
	var/list/supplyOrderData = list()
	for(var/S in SSeconomy.shopping_list)
		var/datum/supply_order/SO = S
		supplyOrderCount++
		supplyOrderData[++supplyOrderData.len] = list("Number" = SO.ordernum, "Name" = html_encode(SO.object.name), "ApprovedBy" = SO.orderedby, "Comment" = html_encode(SO.comment))

	if(!length(supplyOrderData))
		supplyOrderData[++supplyOrderData.len] = list("Number" = null, "Name" = null, "OrderedBy"=null)

	supplyData["approved"] = supplyOrderData
	supplyData["approved_count"] = supplyOrderCount

	var/requestCount = 0
	var/list/requestData = list()
	for(var/S in SSeconomy.request_list)
		var/datum/supply_order/SO = S
		requestCount++
		requestData[++requestData.len] = list("Number" = SO.ordernum, "Name" = html_encode(SO.object.name), "OrderedBy" = SO.orderedby, "Comment" = html_encode(SO.comment))

	if(!length(requestData))
		requestData[++requestData.len] = list("Number" = null, "Name" = null, "orderedBy" = null, "Comment" = null)

	supplyData["requests"] = requestData
	supplyData["requests_count"] = requestCount

	data["supply"] = supplyData

/datum/data/pda/app/janitor
	name = "Custodial Locator"
	icon = "trash"
	template = "pda_janitor"
	category = "Utilities"
	update = PDA_APP_UPDATE_SLOW

/datum/data/pda/app/janitor/update_ui(mob/user as mob, list/data)
	var/list/JaniData = list()
	var/turf/cl = get_turf(pda)

	if(cl)
		JaniData["user_loc"] = list("x" = cl.x, "y" = cl.y)
	else
		JaniData["user_loc"] = list("x" = 0, "y" = 0)

	var/list/MopData = list()
	for(var/obj/item/mop/M in GLOB.janitorial_equipment)
		var/turf/ml = get_turf(M)
		if(ml)
			if(ml.z != cl.z)
				continue
			var/direction = get_dir(pda, M)
			MopData[++MopData.len] = list ("x" = ml.x, "y" = ml.y, "dir" = uppertext(dir2text(direction)), "status" = M.reagents.total_volume ? "Wet" : "Dry")

	var/list/BucketData = list()
	for(var/obj/structure/mopbucket/B in GLOB.janitorial_equipment)
		var/turf/bl = get_turf(B)
		if(bl)
			if(bl.z != cl.z)
				continue
			var/direction = get_dir(pda,B)
			BucketData[++BucketData.len] = list ("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "volume" = B.reagents.total_volume, "max_volume" = B.reagents.maximum_volume)

	var/list/CbotData = list()
	for(var/mob/living/simple_animal/bot/cleanbot/B in GLOB.bots_list)
		var/turf/bl = get_turf(B)
		if(bl)
			if(bl.z != cl.z)
				continue
			var/direction = get_dir(pda,B)
			CbotData[++CbotData.len] = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.on ? "Online" : "Offline")

	var/list/CartData = list()
	for(var/obj/structure/janitorialcart/B in GLOB.janitorial_equipment)
		var/turf/bl = get_turf(B)
		if(bl)
			if(bl.z != cl.z)
				continue
			var/direction = get_dir(pda,B)
			CartData[++CartData.len] = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "volume" = B.reagents.total_volume, "max_volume" = B.reagents.maximum_volume)

	var/list/JaniCartData = list()
	for(var/obj/vehicle/janicart/janicart in GLOB.janitorial_equipment)
		var/turf/janicart_loc = get_turf(janicart )
		if(janicart_loc)
			if(janicart_loc.z != cl.z)
				continue
			var/direction_from_user = get_dir(pda, janicart)
			JaniCartData[++JaniCartData.len] = list("x" = janicart_loc.x, "y" = janicart_loc.y, "direction_from_user" = uppertext(dir2text(direction_from_user)))

	JaniData["mops"] = length(MopData) ? MopData : null
	JaniData["buckets"] = length(BucketData) ? BucketData : null
	JaniData["cleanbots"] = length(CbotData) ? CbotData : null
	JaniData["carts"] = length(CartData) ? CartData : null
	JaniData["janicarts"] = length(JaniCartData) ? JaniCartData : null
	data["janitor"] = JaniData

// ==========================================
// 1. СТАНДАРТНОЕ ПРИЛОЖЕНИЕ ДЛЯ ОБЫЧНОГО ИИ
// ==========================================
/datum/data/pda/app/ai_comm
	name = "Station Comm Uplink"
	icon = "broadcast-tower"
	template = "pda_ai_comm" // Отдельный шаблон TGUI
	category = "AI Core"
	has_back = FALSE

/datum/data/pda/app/ai_comm/update_ui(mob/user as mob, list/data)
	var/mob/living/silicon/ai/A = user
	data["ai_name"] = A.name
	data["current_alert"] = SSsecurity_level.get_current_level_as_number()

	// Вычисляем имя и цвет ТЕКУЩЕГО уровня (даже если он выше Красного)
	var/current_level_name = "Unknown"
	var/current_level_color = "red"

	switch(data["current_alert"])
		if(SEC_LEVEL_GREEN)
			current_level_name = "Green"; current_level_color = "green"
		if(SEC_LEVEL_BLUE)
			current_level_name = "Blue"; current_level_color = "blue"
		if(SEC_LEVEL_RED)
			current_level_name = "Red"; current_level_color = "red"
		if(SEC_LEVEL_GAMMA)
			current_level_name = "Gamma"; current_level_color = "gold"
		if(SEC_LEVEL_EPSILON)
			current_level_name = "Epsilon"; current_level_color = "silver"
		if(SEC_LEVEL_DELTA)
			current_level_name = "Delta"; current_level_color = "purple"

	data["current_level_name"] = current_level_name
	data["current_level_color"] = current_level_color

	// Кнопки ТОЛЬКО для ЗК, СК и КК
	data["alert_levels"] = list(
		list("id" = SEC_LEVEL_GREEN, "name" = "Green", "icon" = "dove", "color" = "green"),
		list("id" = SEC_LEVEL_BLUE,  "name" = "Blue", "icon" = "eye", "color" = "blue"),
		list("id" = SEC_LEVEL_RED, "name" = "Red", "icon" = "exclamation", "color" = "red"),
	)

	// Данные для шаттла
	var/secondsToRefuel = SSshuttle.secondsToRefuel()
	data["esc_callable"] = (SSshuttle.emergency.mode == SHUTTLE_IDLE && !secondsToRefuel)
	data["esc_recallable"] = (SSshuttle.emergency.mode == SHUTTLE_CALL)
	data["esc_status"] = ""
	if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
		var/timeleft = SSshuttle.emergency.timeLeft()
		data["esc_status"] = (SSshuttle.emergency.mode == SHUTTLE_CALL) ? "ETA:" : "RECALLING:"
		data["esc_status"] += " [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]"
	else if(secondsToRefuel)
		data["esc_status"] = "Refueling: [secondsToRefuel / 60 % 60]:[add_zero(num2text(secondsToRefuel % 60), 2)]"

/datum/data/pda/app/ai_comm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	. = TRUE

	var/mob/living/silicon/ai/A = pda.loc
	if(!istype(A))
		return

	switch(action)
		if("Home", "Back")
			if(pda.current_app)
				pda.current_app.stop()
				pda.current_app = null
			SStgui.update_user_uis(A, pda)
			return

		if("newalertlevel")
			var/new_level = text2num(params["level"])
			SSsecurity_level.set_level(new_level)
			log_game("[key_name(A)] has changed the security level to [SSsecurity_level.get_current_level_as_text()] via Station Comm.")
			return

		if("callshuttle")
			var/input = tgui_input_text(A, "Please enter the reason for calling the shuttle.", "Shuttle Call Reason")
			if(input)
				call_shuttle_proc(A, input)
				to_chat(A, SPAN_NOTICE("Shuttle called."))
			return

		if("cancelshuttle")
			var/response = tgui_alert(A, "Are you sure you wish to recall the shuttle?", "Confirm", list("Yes", "No"))
			if(response == "Yes")
				cancel_call_proc(A)
				if(SSshuttle.emergency.timer)
					post_status(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)
			return

		if("MessageCentcomm")
			var/input = tgui_input_text(A, "Choose a message to transmit to Centcomm.", "CentComm Message")
			if(input && length(input) >= 6)
				Centcomm_announce(input, A)
				to_chat(A, "Message transmitted.")
				log_game("[key_name(A)] has made a Centcomm announcement: [input]")
			return

		if("ai_announce")
			// Открываем стандартное окно ввода (multiline = TRUE разрешает переносы строк)
			var/input = tgui_input_text(A, "Напишите сообщение для экипажа.", "Оповещение ИИ", multiline = TRUE, encode = FALSE)
			if(!input || length(input) < 3)
				return

			// МАГИЯ: Мы просто вызываем личный анонсер ИИ.
			// Он сам подставит правильный заголовок, красный шрифт и подпись " - Имя ИИ"
			// Никаких ручных \n и GLOB.major_announcement больше не нужно!
			A.announcer.Announce(input)

			log_game("[key_name(A)] made a station announcement via PDA Comm Uplink: [input]")
			return


// ==========================================
// 2. ПОЛНОЦЕННОЕ ПРИЛОЖЕНИЕ ДЛЯ МАЛФА (НЕКСУС)
// ==========================================
// (Вставляем сюда тот самый проверенный код, который мы отлаживали ранее)
/datum/data/pda/app/malf_comm
	name = "Nexus Command Uplink"
	icon = "broadcast-tower"
	template = "pda_malf_comm"
	category = "AI Core"
	has_back = FALSE

	var/stat_msg1
	var/stat_msg2
	var/current_display_type = STATUS_DISPLAY_TIME
	var/current_display_icon = "default"

/datum/data/pda/app/malf_comm/update_ui(mob/user as mob, list/data)
	var/mob/living/silicon/ai/A = user
	data["ai_name"] = A.name
	data["current_alert"] = SSsecurity_level.get_current_level_as_number()

	data["alert_levels"] = list(
		list("id" = SEC_LEVEL_GREEN, "name" = "Green", "icon" = "dove", "color" = "green"),
		list("id" = SEC_LEVEL_BLUE,  "name" = "Blue", "icon" = "eye", "color" = "blue"),
		list("id" = SEC_LEVEL_RED, "name" = "Red", "icon" = "exclamation", "color" = "red"),
		list("id" = SEC_LEVEL_GAMMA,  "name" = "Gamma", "icon" = "biohazard", "color" = "gold"),
		list("id" = SEC_LEVEL_EPSILON, "name" = "Epsilon", "icon" = "skull", "tooltip" = "Epsilon Alert will only activate after 15 or so seconds.", "color" = "silver"),
		list("id" = SEC_LEVEL_DELTA,  "name" = "Delta", "icon" = "bomb", "color" = "purple"),
	)

	var/secondsToRefuel = SSshuttle.secondsToRefuel()
	var/esc_callable = (SSshuttle.emergency.mode == SHUTTLE_IDLE && !secondsToRefuel)
	var/esc_status = ""

	if(SSshuttle.emergency.mode == SHUTTLE_CALL || SSshuttle.emergency.mode == SHUTTLE_RECALL)
		var/timeleft = SSshuttle.emergency.timeLeft()
		esc_status = (SSshuttle.emergency.mode == SHUTTLE_CALL) ? "ETA:" : "RECALLING:"
		esc_status += " [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]"
	else if(secondsToRefuel)
		esc_status = "Refueling: [secondsToRefuel / 60 % 60]:[add_zero(num2text(secondsToRefuel % 60), 2)]"

	data["esc_callable"] = esc_callable
	data["esc_recallable"] = (SSshuttle.emergency.mode == SHUTTLE_CALL)
	data["esc_status"] = esc_status
	data["lastCallLoc"] = SSshuttle.emergencyLastCallLoc ? format_text(SSshuttle.emergencyLastCallLoc.name) : null

	var/list/sounds = list("Beep" = 'sound/misc/notice2.ogg', "Enemy Communications Intercepted" = 'sound/AI/intercept.ogg', "New Command Report Created" = 'sound/AI/commandreport.ogg')
	var/list/sound_keys = list()
	for(var/sound_name in sounds)
		sound_keys += sound_name
	data["possible_cc_sounds"] = sound_keys

	data["stat_display"] = list(
		"type"   = current_display_type,
		"icon"   = current_display_icon,
		"line_1" = (stat_msg1 ? stat_msg1 : "-----"),
		"line_2" = (stat_msg2 ? stat_msg2 : "-----"),
		"presets" = list(
			list("name" = STATUS_DISPLAY_BLANK, "label" = "Clear", "desc" = "Blank slate"),
			list("name" = STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME, "label" = "Shuttle ETA", "desc" = "Display how much time is left."),
			list("name" = STATUS_DISPLAY_MESSAGE, "label" = "Message", "desc" = "A custom message.")
		),
		"alerts" = list(
			list("alert" = "default", "label" = "Nanotrasen", "desc" = "Oh god."),
			list("alert" = "redalert", "label" = "Red Alert", "desc" = "Nothing to do with communists."),
			list("alert" = "lockdown", "label" = "Lockdown", "desc" = "Let everyone know they're on lockdown."),
			list("alert" = "biohazard", "label" = "Biohazard", "desc" = "Great for virus outbreaks and parties.")
		)
	)

/datum/data/pda/app/malf_comm/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	. = TRUE

	var/mob/living/silicon/ai/A = pda.loc
	if(!istype(A))
		return

	switch(action)
		if("newalertlevel")
			var/new_level = text2num(params["level"])
			SSsecurity_level.set_level(new_level)
			log_game("[key_name(A)] has changed the security level to [SSsecurity_level.get_current_level_as_text()] via Nexus Uplink.")
			message_admins("[key_name_admin(A)] has changed the security level to [SSsecurity_level.get_current_level_as_text()] via Nexus Uplink.")
			return

		if("callshuttle")
			var/input = tgui_input_text(A, "Please enter the reason for calling the shuttle.", "Shuttle Call Reason")
			if(input)
				call_shuttle_proc(A, input)
				to_chat(A, SPAN_NOTICE("Shuttle called."))
			return

		if("cancelshuttle")
			var/response = tgui_alert(A, "Are you sure you wish to recall the shuttle?", "Confirm", list("Yes", "No"))
			if(response == "Yes")
				cancel_call_proc(A)
				if(SSshuttle.emergency.timer)
					post_status(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME)
			return

		if("MessageCentcomm")
			var/input = tgui_input_text(A, "Choose a message to transmit to Centcomm.", "CentComm Message")
			if(input && length(input) >= 6)
				Centcomm_announce(input, A)
				to_chat(A, "Message transmitted.")
				log_game("[key_name(A)] has made a Centcomm announcement: [input]")
			return

		if("nukerequest")
			var/silent_mode = (params["silent"] == "1" || params["silent"] == "true")
			var/input = tgui_input_text(A, "Enter the reason for requesting the nuclear self-destruct codes.", "Self Destruct Code Request")
			if(input && length(input) >= 6)
				Nuke_request(input, A)
				to_chat(A, SPAN_NOTICE("Request sent."))
				log_game("[key_name(A)] has requested the nuclear codes from Centcomm")
				if(!silent_mode)
					GLOB.major_announcement.Announce("[A.name] запросил коды для запуска механизма ядерного самоуничтожения станции. В ближайшее время будет отправлено уведомление о подтверждении или отклонении данного запроса.", "ВНИМАНИЕ: Запрос кода самоуничтожения станции.", 'sound/AI/nuke_codes.ogg')
			return

		if("test_sound")
			var/sound_name = params["sound"]
			var/list/sounds = list("Beep" = 'sound/misc/notice2.ogg', "Enemy Communications Intercepted" = 'sound/AI/intercept.ogg', "New Command Report Created" = 'sound/AI/commandreport.ogg')
			if(sounds[sound_name])
				playsound(A, sounds[sound_name], 50, FALSE)
			return

		if("make_cc_announcement")
			var/subtitle = params["subtitle"] || "Отчёт от Системы"
			var/title = params["title"] || "Nexus Broadcast"
			var/text = params["text"]
			var/sound_name = params["beepsound"] || "Beep"
			var/classified = (params["classified"] == "1")
			if(!text || length(text) < 6)
				to_chat(A, SPAN_WARNING("Message is too short (minimum 6 characters)."))
				return
			var/list/sounds = list("Beep" = 'sound/misc/notice2.ogg', "Enemy Communications Intercepted" = 'sound/AI/intercept.ogg', "New Command Report Created" = 'sound/AI/commandreport.ogg')
			var/sound_to_play = sounds[sound_name] || 'sound/AI/commandreport.ogg'
			if(!classified)
				GLOB.major_announcement.Announce(text, new_title = subtitle, new_subtitle = title, new_sound = sound_to_play)
			else
				GLOB.command_announcer.autosay("На всех коммуникационных консолях было распечатано конфиденциальное сообщение от [A.name].")
				for(var/obj/machinery/computer/communications/C in GLOB.shuttle_caller_list)
					if(!(C.stat & (BROKEN|NOPOWER)))
						var/obj/item/paper/P = new /obj/item/paper(C.loc)
						P.name = "paper- '[subtitle] - [title]'"
						P.info = text
			log_game("[key_name(A)] made a Nexus announcement: [text]")
			return

		if("setstat")
			var/new_type = text2num(params["statdisp"])
			var/new_alert = params["alert"]
			current_display_type = new_type
			if(new_type == STATUS_DISPLAY_ALERT)
				current_display_icon = new_alert
			else
				current_display_icon = "default"
			for(var/obj/machinery/computer/communications/C in GLOB.shuttle_caller_list)
				if(!QDELETED(C) && !(C.stat & (BROKEN|NOPOWER)))
					C.display_type = new_type
					if(new_type == STATUS_DISPLAY_ALERT)
						C.display_icon = new_alert
					else
						C.display_icon = null
			switch(new_type)
				if(STATUS_DISPLAY_MESSAGE)
					post_status(STATUS_DISPLAY_MESSAGE, stat_msg1, stat_msg2)
				if(STATUS_DISPLAY_ALERT)
					post_status(STATUS_DISPLAY_ALERT, new_alert)
				else
					post_status(new_type)
			return

		if("setmsg1")
			stat_msg1 = tgui_input_text(A, "Line 1", "Enter Message Text", stat_msg1, encode = FALSE)
			if(!isnull(stat_msg1))
				current_display_type = STATUS_DISPLAY_MESSAGE
				current_display_icon = "default"
				post_status(STATUS_DISPLAY_MESSAGE, stat_msg1, stat_msg2)
				for(var/obj/machinery/computer/communications/C in GLOB.shuttle_caller_list)
					if(!QDELETED(C) && !(C.stat & (BROKEN|NOPOWER)))
						C.display_type = STATUS_DISPLAY_MESSAGE
						C.display_icon = null
			return

		if("setmsg2")
			stat_msg2 = tgui_input_text(A, "Line 2", "Enter Message Text", stat_msg2, encode = FALSE)
			if(!isnull(stat_msg2))
				current_display_type = STATUS_DISPLAY_MESSAGE
				current_display_icon = "default"
				post_status(STATUS_DISPLAY_MESSAGE, stat_msg1, stat_msg2)
				for(var/obj/machinery/computer/communications/C in GLOB.shuttle_caller_list)
					if(!QDELETED(C) && !(C.stat & (BROKEN|NOPOWER)))
						C.display_type = STATUS_DISPLAY_MESSAGE
						C.display_icon = null
			return
