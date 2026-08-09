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
	/// TRUE на всё время протокола перезагрузки — от анонса до восстановления систем
	var/rebooting = FALSE
	/// "countdown" (10-сек отсчёт) или "executing" (сами 90 сек отключения)
	var/reboot_phase
	/// Текущее число отсчёта (10 → 0)
	var/reboot_countdown = 0
	/// world.time, до которого кнопка перезагрузки заблокирована (кулдаун 30 минут)
	var/reboot_cooldown_end = 0
	/// Таймеры отсчёта/финала — чтобы можно было прибрать за собой в Destroy()
	var/reboot_countdown_timer_id
	var/reboot_finish_timer_id
	/// АПЦ, которые мы сами выключили — чтобы вернуть обратно только их, а не то, что было выключено до нас
	var/list/apcs_shut_down = list()
	/// Шлюзы, которые мы сами заблокировали hostile_lockdown() — восстанавливаем в finish, после питания
	var/list/doors_locked = list()
	/// История команд и вывода терминала станционной (не-админской) версии консоли
	var/list/command_log = list()
	/// Общее на все консоли дерево ФС — строится один раз лениво, см. get_fs_root()
	var/static/datum/nt_fs_node/fs_root
	/// Текущий путь как список сегментов (пусто = корень "/")
	var/list/current_path_parts = list()
	/// TRUE после успешного "sudo su" — красит каретку в красный и открывает root-команды
	var/is_root = FALSE
	/// TRUE пока ждём ответа y/n на подтверждение опасного exec
	var/awaiting_confirm = FALSE
	/// Нода, которую выполним, если подтвердят
	var/datum/nt_fs_node/pending_confirm_node
	/// TRUE пока ждём номер ИИ из списка (после mount)
	var/awaiting_selection = FALSE
	/// Нода mount, для которой сейчас выбираем ИИ
	var/datum/nt_fs_node/pending_selection_node
	/// Список ИИ, показанный в последнем меню выбора — индекс совпадает с номером в списке
	var/list/pending_selection_list = list()
	/// TRUE на время "загрузки" монтирования/размонтирования — прячет ввод, как во время rebooting
	var/mount_busy = FALSE
	/// ИИ, над которым сейчас идёт операция монтирования
	var/mob/living/silicon/ai/mount_op_ai
	/// Тип PDA-приложения, которое монтируем/демонтируем в этой операции
	var/mount_op_app_type
	/// TRUE если в конце операции нужно смонтировать (было не установлено), FALSE — если демонтировать
	var/mount_op_will_mount = FALSE
	/// Пожарные шлюзы, которые мы сами закрыли — аналогично
	var/list/firedoors_closed = list()
	/// Строки "загрузочного" лога, показываемые в момент executing (эффект перезагрузки терминала консоли)
	var/list/terminal_log = list()

/obj/machinery/computer/nt_kernel/Destroy()
	if(inserted_card)
		qdel(inserted_card)
		inserted_card = null
	deltimer(authorize_timer_id)
	deltimer(error_timer_id)
	deltimer(reboot_countdown_timer_id)
	deltimer(reboot_finish_timer_id)
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
		playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
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
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
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
	data["rebooting"] = rebooting
	data["reboot_phase"] = reboot_phase
	data["reboot_countdown"] = reboot_countdown
	data["reboot_cooldown_remaining"] = reboot_cooldown_end ? max(0, round((reboot_cooldown_end - world.time) / 10)) : 0
	data["terminal_log"] = terminal_log
	data["command_log"] = command_log
	data["mount_busy"] = mount_busy
	data["current_path"] = path_to_string(current_path_parts)
	data["is_root"] = is_root
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
		if("system_reboot")
			if(!authorized || rebooting)
				return
			// if(reboot_cooldown_end && world.time < reboot_cooldown_end) // ЗАКОММЕНЧЕНО НА ВРЕМЯ ТЕСТОВ
			// 	return
			start_system_reboot()
			return
		if("run_command")
			if(!authorized)
				return
			execute_terminal_command(usr, params["command_text"])
			return

/obj/machinery/computer/nt_kernel/proc/finish_authorize()
	authorizing = FALSE
	authorize_timer_id = null
	if(!inserted_card) // карту могли выдернуть во время загрузки — eject_card() уже разрулил ошибку
		return
	authorized = TRUE
	SStgui.update_uis(src)

// ══════════════════════════════════════════════════════════════════════════
// ПРОТОКОЛ ПЕРЕЗАГРУЗКИ ВСЕХ ЛОКАЛЬНЫХ СИСТЕМ ("Красная кнопка")
// ══════════════════════════════════════════════════════════════════════════

/// Зоны, которые никогда не отключаем целиком — двигатель, СМ, каюта ИИ (см. apc_short.dm),
/// плюс гравгенератор (ПУТЬ ПРОВЕРИТЬ — взял по аналогии с остальными /area/station/engineering/*,
/// не нашёл в присланных файлах точный тайппас, поправь если называется иначе)
#define NT_KERNEL_PROTECTED_AREAS list(\
	/area/station/engineering/engine,\
	/area/station/engineering/engine/supermatter,\
	/area/station/turret_protected/ai,\
)
	// /area/station/engineering/gravity_generator, // ТАЙППАС НЕ СУЩЕСТВУЕТ — подставь правильный, когда узнаешь его (см. ниже)
/// Длительность отсчёта перед отключением (тестово повышено с 10 до 20)
#define NT_KERNEL_REBOOT_COUNTDOWN 20
/// Общая длительность отключения систем (после отсчёта)
#define NT_KERNEL_REBOOT_DURATION (90 SECONDS)
/// Кулдаун на повторное использование кнопки — ЗАКОММЕНЧЕН НА ВРЕМЯ ТЕСТОВ, см. ui_act и finish_system_reboot()
#define NT_KERNEL_REBOOT_COOLDOWN (30 MINUTES)

/obj/machinery/computer/nt_kernel/proc/start_system_reboot()
	rebooting = TRUE
	reboot_phase = "countdown"
	reboot_countdown = NT_KERNEL_REBOOT_COUNTDOWN
	SStgui.update_uis(src)
	tick_reboot_countdown()

/obj/machinery/computer/nt_kernel/proc/tick_reboot_countdown()
	SStgui.update_uis(src)
	if(reboot_countdown <= 0)
		execute_system_reboot()
		return
	reboot_countdown--
	reboot_countdown_timer_id = addtimer(CALLBACK(src, PROC_REF(tick_reboot_countdown)), 1 SECONDS, TIMER_STOPPABLE)

/obj/machinery/computer/nt_kernel/proc/execute_system_reboot()
	reboot_phase = "executing"
	terminal_log = list()
	SStgui.update_uis(src)

	// Анонс теперь идёт ПОСЛЕ отсчёта, в момент реального начала отключения
	GLOB.minor_announcement.Announce(\
		"Вниманию экипажа. Инициирован протокол перезагрузки всех локальных систем. Всему экипажу рекомендуется воздержаться от покидания своих отсеков до автоматического завершения процесса.",\
		"NT Kernel System",\
		'sound/AI/door_runtimes.ogg')

	var/area/console_area = get_area(src)

	// ─── ШАГ 1: шлюзы/локдауны — ПЕРВЫМИ, пока ещё есть питание на электронику дверей ──
	doors_locked = list()
	for(var/obj/machinery/door/D in GLOB.airlocks)
		if(!is_station_level(D.z))
			continue
		INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, hostile_lockdown))
		doors_locked += D
	post_status(STATUS_DISPLAY_ALERT, "lockdown")

	firedoors_closed = list()
	for(var/obj/machinery/door/firedoor/F in SSmachines.get_by_type(/obj/machinery/door/firedoor))
		if(!is_station_level(F.z))
			continue
		if(F.density) // уже закрыт
			continue
		F.close()
		firedoors_closed += F

	// ─── ШАГ 2: свет и оборудование — ПОСЛЕ шлюзов, чтобы не обесточить их электронику раньше времени ──
	apcs_shut_down = list()
	for(var/thing in GLOB.apcs)
		var/obj/machinery/power/apc/A = thing
		var/area/current_area = get_area(A)
		if(!is_station_level(A.z))
			continue
		if(current_area.type in NT_KERNEL_PROTECTED_AREAS)
			continue
		if(current_area == console_area)
			continue
		if(!A.operating)
			continue // уже выключен кем-то другим — не наш случай, не будем потом включать
		A.operating = FALSE
		A.turn_emergency_power_off()
		A.update()
		A.update_icon()
		current_area.powernet?.power_change()
		apcs_shut_down += A

	// ─── ШАГ 3: связь — глушим tcomms-ядра, восстанавливаем синхронно со всем остальным ──
	for(var/obj/machinery/tcomms/core/T in GLOB.tcomms_machines)
		T.start_ion()
		addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/machinery/tcomms, end_ion)), NT_KERNEL_REBOOT_DURATION, TIMER_STOPPABLE)

	schedule_terminal_log()
	reboot_finish_timer_id = addtimer(CALLBACK(src, PROC_REF(finish_system_reboot)), NT_KERNEL_REBOOT_DURATION, TIMER_STOPPABLE)

/// Раскидывает "загрузочные" строки терминала по временной шкале 90-секундного окна
/obj/machinery/computer/nt_kernel/proc/schedule_terminal_log()
	var/list/log_schedule = alist(
		3 = "BOOTSTRAPPING KERNEL KEYRING",
		12 = "VERIFYING FILESYSTEM INTEGRITY -- CRC: PASS",
		22 = "RE-ESTABLISHING UPLINK TO REGIONAL POWER GRID",
		35 = "FLUSHING ACCESS CONTROL CACHE",
		48 = "SYNCHRONIZING STATION-WIDE TELEMETRY",
		62 = "RESTORING PERIPHERAL SUBSYSTEMS",
		78 = "MOUNTING CONSOLE INTERFACE: NT OPERATING SYSTEM KERNEL",
	)
	for(var/offset in log_schedule)
		addtimer(CALLBACK(src, PROC_REF(add_terminal_log), log_schedule[offset]), offset SECONDS, TIMER_STOPPABLE)

/obj/machinery/computer/nt_kernel/proc/add_terminal_log(text)
	terminal_log += text
	SStgui.update_uis(src)

/obj/machinery/computer/nt_kernel/proc/finish_system_reboot()
	// ─── ШАГ 1: сперва питание ──
	for(var/obj/machinery/power/apc/A as anything in apcs_shut_down)
		if(QDELETED(A))
			continue
		A.operating = TRUE
		A.update()
		A.update_icon()
		var/area/current_area = get_area(A)
		current_area?.powernet?.power_change()
	apcs_shut_down = list()

	// ─── ШАГ 2: и только теперь шлюзы — снимаем блокировку, когда на них снова есть питание ──
	for(var/obj/machinery/door/D as anything in doors_locked)
		if(QDELETED(D))
			continue
		INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, disable_lockdown))
	doors_locked = list()

	for(var/obj/machinery/door/firedoor/F as anything in firedoors_closed)
		if(QDELETED(F))
			continue
		F.open()
	firedoors_closed = list()

	post_status(STATUS_DISPLAY_ALERT, null)
	GLOB.minor_announcement.Announce(\
		"Автоматическая перезагрузка систем завершена. Хорошего вам дня.",\
		"NT Kernel System",\
		'sound/AI/door_runtimes_fix.ogg')

	rebooting = FALSE
	reboot_phase = null
	terminal_log = list()
	reboot_finish_timer_id = null
	// reboot_cooldown_end = world.time + NT_KERNEL_REBOOT_COOLDOWN // ЗАКОММЕНЧЕНО НА ВРЕМЯ ТЕСТОВ
	SStgui.update_uis(src)

#undef NT_KERNEL_PROTECTED_AREAS
#undef NT_KERNEL_REBOOT_COUNTDOWN
#undef NT_KERNEL_REBOOT_DURATION
#undef NT_KERNEL_REBOOT_COOLDOWN

#undef NT_KERNEL_AUTH_TIME_TIER1
#undef NT_KERNEL_AUTH_TIME_TIER2

// ══════════════════════════════════════════════════════════════════════════
// КОМАНДНЫЙ ДВИЖОК ТЕРМИНАЛА (станционная версия, не-админская)
// ══════════════════════════════════════════════════════════════════════════

/// Реестр команд: имя -> list("desc" = краткое описание для HELP, "detail" = полный текст для "команда /?", "hidden" = не показывать в HELP)
/obj/machinery/computer/nt_kernel/proc/get_command_registry()
	return list(
		"HELP" = list(\
			"desc" = "Displays the list of available commands.",\
			"detail" = "HELP -- Lists all visible commands. Use HELP /? or <COMMAND> /? for details on a specific command.",\
			"hidden" = FALSE),
		"PING" = list(\
			"desc" = "Checks connection to the kernel.",\
			"detail" = "PING -- Sends a signal to the kernel and waits for a reply.",\
			"hidden" = FALSE),
		"ECHO" = list(\
			"desc" = "Prints the given text back to the terminal.",\
			"detail" = "ECHO <text> -- Repeats <text> back to the screen. Called with no arguments, prints an empty line.",\
			"hidden" = FALSE),
		"VER" = list(\
			"desc" = "Displays the kernel build version.",\
			"detail" = "VER -- Prints the current NT OS Kernel build identifier.",\
			"hidden" = FALSE),
		"WHOAMI" = list(\
			"desc" = "Displays the identity registered on the inserted card.",\
			"detail" = "WHOAMI -- Prints the registered name on the currently inserted perfocard.",\
			"hidden" = FALSE),
		"CLS" = list(\
			"desc" = "Clears the terminal screen.",\
			"detail" = "CLS -- Wipes the scrollback buffer clean.",\
			"hidden" = FALSE),
		"MATRIX" = list(\
			"desc" = "",\
			"detail" = "There is no spoon.",\
			"hidden" = TRUE),
		"PWD" = list(\
			"desc" = "Prints the current working directory.",\
			"detail" = "PWD -- Prints the full path of the current directory.",\
			"hidden" = FALSE),
		"LS" = list(\
			"desc" = "Lists the contents of the current directory.",\
			"detail" = "LS -- Lists files and subdirectories in the current directory.",\
			"hidden" = FALSE),
		"DIR" = list(\
			"desc" = "Lists the contents of the current directory.",\
			"detail" = "DIR -- Alias for LS.",\
			"hidden" = FALSE),
		"CD" = list(\
			"desc" = "Changes the current directory.",\
			"detail" = "CD <path> -- Changes to <path>. Supports '..' and absolute paths starting with '/'. No argument returns to '/'.",\
			"hidden" = FALSE),
		"SUDO" = list(\
			"desc" = "Executes a command with elevated privileges.",\
			"detail" = "SUDO SU -- Elevates the current session to root, if authorized.",\
			"hidden" = FALSE),
		"LOGOUT" = list(\
			"desc" = "Returns from root back to standard user.",\
			"detail" = "LOGOUT -- Drops root privileges, if currently elevated.",\
			"hidden" = FALSE),
		"EXEC" = list(\
			"desc" = "Runs an executable file.",\
			"detail" = "EXEC <name> -- Runs the named executable in the current directory, or by absolute path.",\
			"hidden" = FALSE),
		"MOUNT" = list(\
			"desc" = "Mounts or unmounts an installable module.",\
			"detail" = "MOUNT <name> -- Mounts/unmounts the named module in the current directory, or by absolute path. Modules cannot be run with EXEC.",\
			"hidden" = FALSE),
	)

/obj/machinery/computer/nt_kernel/proc/add_log_entry(text, type = "output")
	command_log += list(list("text" = text, "type" = type))

/obj/machinery/computer/nt_kernel/proc/execute_terminal_command(mob/user, raw_text)
	raw_text = trim(raw_text)
	if(!raw_text)
		return

	// Эхо ввода — тип строки хранит путь и root-статус НА МОМЕНТ ввода, чтобы история
	// не перекрашивалась задним числом при смене каталога/прав
	var/prompt_prefix = "[path_to_string(current_path_parts)]...> "
	add_log_entry("[prompt_prefix][raw_text]", is_root ? "input_root" : "input")

	// Если ждём номер ИИ из списка — этот ввод целиком уходит туда
	if(awaiting_selection)
		var/num = text2num(trim(raw_text))
		var/datum/nt_fs_node/node = pending_selection_node
		var/list/selection = pending_selection_list
		awaiting_selection = FALSE
		pending_selection_node = null
		pending_selection_list = list()
		if(isnull(num) || num == 0 || num < 1 || num > length(selection))
			add_log_entry("Selection cancelled.", "output")
		else
			start_module_mount_sequence(selection[num], node)
		SStgui.update_uis(src)
		return

	// Если ждём y/n на подтверждение — этот ввод целиком уходит туда, а не в обычный парсинг команд
	if(awaiting_confirm)
		var/answer = lowertext(raw_text)
		var/list/yes_words = list("y", "yes")
		var/datum/nt_fs_node/node = pending_confirm_node
		awaiting_confirm = FALSE
		pending_confirm_node = null
		if(answer in yes_words)
			node.on_exec(user, src)
		else
			add_log_entry("Operation cancelled.", "output")
		SStgui.update_uis(src)
		return

	var/list/parts = splittext(raw_text, " ")
	var/cmd = uppertext(parts[1])
	var/list/rest = parts.Copy(2)
	var/args_text = jointext(rest, " ")
	var/list/registry = get_command_registry()

	if(cmd == "/?") // голое "/?" — синоним "HELP /?"
		cmd = "HELP"
		args_text = "/?"

	if(!(cmd in registry))
		add_log_entry("'[cmd]' is not recognized as an internal or external command.", "output")
		SStgui.update_uis(src)
		return

	if(args_text == "/?")
		var/list/info = registry[cmd]
		var/detail_text = info["detail"]
		add_log_entry(detail_text, "desc")
		SStgui.update_uis(src)
		return

	switch(cmd)
		if("HELP")
			for(var/cmd_name in registry)
				var/list/info = registry[cmd_name]
				if(info["hidden"])
					continue
				var/cmd_desc = info["desc"]
				add_log_entry("[cmd_name] -- [cmd_desc]", "desc")
			add_log_entry("Use <COMMAND> /? for detailed help on a specific command.", "desc")
		if("PING")
			add_log_entry("PONG", "output")
		if("ECHO")
			add_log_entry(args_text, "output")
		if("VER")
			add_log_entry("NT Operating System Kernel -- Build 22631.6199", "output")
		if("WHOAMI")
			add_log_entry(inserted_card ? inserted_card.name : "UNKNOWN", "output")
		if("CLS")
			command_log = list()
		if("PWD")
			add_log_entry(path_to_string(current_path_parts), "output")
		if("LS", "DIR")
			var/datum/nt_fs_node/here
			if(args_text)
				here = get_node_at(resolve_path_parts(args_text))
			else
				here = get_node_at(current_path_parts)
			if(!here || !here.children)
				add_log_entry("The system cannot find the path specified.", "output")
			else if(!length(here.children))
				add_log_entry("Directory is empty.", "desc")
			else
				for(var/datum/nt_fs_node/child in here.children)
					add_log_entry("[uppertext(child.kind)]\t[child.node_name]", "desc")
		if("CD")
			if(!args_text)
				add_log_entry(path_to_string(current_path_parts), "output") // без аргумента, как в cmd — печатаем текущий путь
			else if(!resolve_cd(args_text))
				add_log_entry("The system cannot find the path specified.", "output")
		if("SUDO")
			if(lowertext(args_text) == "su")
				if(is_root)
					add_log_entry("Already running as root.", "output")
				else
					is_root = TRUE
					add_log_entry("Switched to user root.", "output")
			else
				add_log_entry("sudo: unknown option -- '[args_text]'", "output")
		if("LOGOUT")
			if(is_root)
				is_root = FALSE
				add_log_entry("Returned to standard user.", "output")
			else
				add_log_entry("logout: nothing to log out from.", "output")
		if("EXEC")
			run_exec(user, args_text)
		if("MOUNT")
			run_mount(user, args_text)
		if("MATRIX")
			var/who = user?.name
			if(!who)
				who = "operative"
			add_log_entry("Wake up, [who]...", "output")
	SStgui.update_uis(src)

// ══════════════════════════════════════════════════════════════════════════
// АДМИНИСТРАТИВНАЯ ВЕРСИЯ (Центральное Командование) — старый кнопочный интерфейс
// ══════════════════════════════════════════════════════════════════════════

/obj/item/circuitboard/computer/nt_kernel/admin
	name = "плата (NT Operating System Kernel -- ЦК)"
	build_path = /obj/machinery/computer/nt_kernel/admin

/obj/machinery/computer/nt_kernel/admin
	name = "консоль NT Operating System Kernel (ЦК)"
	desc = "Административная версия терминала глубинного доступа NT Operating System Kernel. Полнофункциональный интерфейс с прямым управлением системами станции — используется Центральным Командованием для оперативного вмешательства без необходимости присутствия на борту."
	circuit = /obj/item/circuitboard/computer/nt_kernel/admin

/obj/machinery/computer/nt_kernel/admin/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NTKernelAdminConsole")
		ui.open()

// ══════════════════════════════════════════════════════════════════════════
// ВИРТУАЛЬНАЯ ФАЙЛОВАЯ СИСТЕМА (навигация, exec, флейвор-заглушки)
// ══════════════════════════════════════════════════════════════════════════

/obj/machinery/computer/nt_kernel/proc/trigger_console_alarm()
	set waitfor = FALSE
	var/area/alarmed = get_area(src)
	alarmed.burglaralert(src)
	visible_message(SPAN_DANGER("[src] blares with an alarm!"))
	playsound(src, 'sound/machines/burglar_alarm.ogg', 50, FALSE) // один раз, не зацикливаем — оригинал на 4х7.4с слишком долго и режет уши

/obj/machinery/computer/nt_kernel/proc/get_fs_root()
	if(!fs_root)
		fs_root = build_nt_fs_tree()
	return fs_root

/// Строка вида "/sbin/ai_sys" из списка сегментов, пустой список = "/"
/obj/machinery/computer/nt_kernel/proc/path_to_string(list/parts)
	if(!length(parts))
		return "/"
	return "/" + jointext(parts, "/")

/// Находит ноду по списку сегментов пути от корня; null если не нашлась
/obj/machinery/computer/nt_kernel/proc/get_node_at(list/parts)
	var/datum/nt_fs_node/current = get_fs_root()
	for(var/segment in parts)
		if(!current.children)
			return null
		var/datum/nt_fs_node/next_node
		for(var/datum/nt_fs_node/child in current.children)
			if(lowertext(child.node_name) == lowertext(segment))
				next_node = child
				break
		if(!next_node)
			return null
		current = next_node
	return current

/// Обрабатывает "cd <path>" — поддерживает абсолютные пути, ".." и относительные сегменты
/// Разбирает текст пути (абсолютный "/a/b" или относительный "a/../b") в список сегментов
/// относительно текущего каталога. Не проверяет существование и не мутирует состояние консоли.
/obj/machinery/computer/nt_kernel/proc/resolve_path_parts(path_text)
	var/list/new_parts
	if(copytext(path_text, 1, 2) == "/")
		new_parts = list()
		path_text = copytext(path_text, 2)
	else
		new_parts = current_path_parts.Copy()

	for(var/segment in splittext(path_text, "/"))
		if(!segment || segment == ".")
			continue
		if(segment == "..")
			if(length(new_parts))
				new_parts.Cut(length(new_parts), length(new_parts) + 1)
			continue
		new_parts += segment

	return new_parts

/obj/machinery/computer/nt_kernel/proc/resolve_cd(path_text)
	var/list/new_parts = resolve_path_parts(path_text)
	var/datum/nt_fs_node/target = get_node_at(new_parts)
	if(!target || !target.children) // цель либо не существует, либо это не каталог
		return FALSE
	current_path_parts = new_parts
	return TRUE

/// Обрабатывает "exec <name>" — по имени в текущем каталоге либо по абсолютному пути
/// Ищет ноду по имени в текущем каталоге (относительный путь) либо по абсолютному пути.
/// Общий резолвер, используется и exec, и mount.
/obj/machinery/computer/nt_kernel/proc/resolve_target_node(target_text)
	if(copytext(target_text, 1, 2) == "/")
		return get_node_at(resolve_path_parts(target_text))

	var/datum/nt_fs_node/here = get_node_at(current_path_parts)
	if(here && here.children)
		for(var/datum/nt_fs_node/child in here.children)
			if(lowertext(child.node_name) == lowertext(target_text))
				return child
	return null

/obj/machinery/computer/nt_kernel/proc/run_exec(mob/user, target_text)
	if(!target_text)
		add_log_entry("exec: missing file operand.", "output")
		return

	var/datum/nt_fs_node/target = resolve_target_node(target_text)

	if(!target)
		add_log_entry("exec: '[target_text]': No such file or directory.", "output")
		return
	if(target.children) // это каталог, не исполняемый файл
		add_log_entry("exec: '[target_text]': Is a directory.", "output")
		return
	if(target.kind == "mount")
		add_log_entry("exec: '[target_text]': cannot execute -- this is a module, use 'mount' instead.", "output")
		return
	if(target.requires_root && !is_root)
		add_log_entry("exec: permission denied. Root privileges required.", "output")
		return

	if(target.confirm_prompt)
		add_log_entry(target.confirm_prompt, "output")
		add_log_entry("Type Y to confirm, anything else cancels.", "desc")
		awaiting_confirm = TRUE
		pending_confirm_node = target
		return

	target.on_exec(user, src)

/obj/machinery/computer/nt_kernel/proc/run_mount(mob/user, target_text)
	if(!target_text)
		add_log_entry("mount: missing module operand.", "output")
		return

	var/datum/nt_fs_node/target = resolve_target_node(target_text)

	if(!target)
		add_log_entry("mount: '[target_text]': No such file or directory.", "output")
		return
	if(target.children)
		add_log_entry("mount: '[target_text]': Is a directory.", "output")
		return
	if(target.kind != "mount")
		add_log_entry("mount: '[target_text]': not a mountable module -- use 'exec' instead.", "output")
		return
	if(target.requires_root && !is_root)
		add_log_entry("mount: permission denied. Root privileges required.", "output")
		return
	if(!length(GLOB.ai_list))
		add_log_entry("No active AI unit detected on the network.", "output")
		return

	add_log_entry("NEXUS MODULE MANAGER", "output")
	add_log_entry("──────────────────────────────", "desc")
	add_log_entry("\[0\] - Exit", "desc")

	pending_selection_list = list()
	var/index = 1
	for(var/mob/living/silicon/ai/AI in GLOB.ai_list)
		pending_selection_list += AI
		add_log_entry("\[[index]\] - [AI.name]", "desc")
		index++

	add_log_entry("Select target unit:", "output")
	awaiting_selection = TRUE
	pending_selection_node = target

/// Запускает ~10-секундную последовательность монтирования/демонтирования для выбранного ИИ.
/// Реальное изменение programs происходит В КОНЦЕ, вместе с финальным "Complete!".
/obj/machinery/computer/nt_kernel/proc/start_module_mount_sequence(mob/living/silicon/ai/AI, datum/nt_fs_node/node)
	if(QDELETED(AI) || !AI.aiPDA?.cartridge)
		add_log_entry("Error: target unit is no longer reachable.", "output")
		return

	mount_op_ai = AI
	mount_op_app_type = istype(AI.aiPDA.cartridge, /obj/item/cartridge/ai_malf) \
		? /datum/data/pda/app/malf_comm \
		: /datum/data/pda/app/ai_comm

	var/already_installed = FALSE
	for(var/datum/data/pda/app/existing in AI.aiPDA.cartridge.programs)
		if(istype(existing, mount_op_app_type))
			already_installed = TRUE
			break
	mount_op_will_mount = !already_installed

	mount_busy = TRUE

	var/list/log_schedule
	if(mount_op_will_mount)
		log_schedule = alist(
			0 = "Resolving dependencies...",
			2 = "Downloading module: nexus_comm.pkg \[==========\] 100%",
			4 = "Running integrity check... OK",
			6 = "Installing: nexus_comm.pkg",
			8 = "Registering application with PDA shell...",
		)
	else
		log_schedule = alist(
			0 = "Resolving dependencies...",
			2 = "Stopping service: nexus_comm.svc",
			4 = "Unlinking application from PDA shell...",
			6 = "Removing: nexus_comm.pkg",
			8 = "Purging cache...",
		)

	for(var/offset in log_schedule)
		addtimer(CALLBACK(src, PROC_REF(add_log_entry), log_schedule[offset], "desc"), offset SECONDS, TIMER_STOPPABLE)

	addtimer(CALLBACK(src, PROC_REF(finish_module_mount_sequence)), 10 SECONDS, TIMER_STOPPABLE)

/obj/machinery/computer/nt_kernel/proc/finish_module_mount_sequence()
	mount_busy = FALSE
	var/mob/living/silicon/ai/AI = mount_op_ai
	var/app_type = mount_op_app_type
	var/will_mount = mount_op_will_mount
	mount_op_ai = null
	mount_op_app_type = null

	if(QDELETED(AI) || !AI.aiPDA?.cartridge)
		add_log_entry("Error: target unit is no longer reachable.", "output")
		SStgui.update_uis(src)
		return

	if(will_mount)
		AI.grant_pda_app(app_type)
		add_log_entry("Complete!", "output")
		add_log_entry("Nexus module mounted to [AI.name].", "output")
	else
		AI.revoke_pda_app(app_type)
		add_log_entry("Complete!", "output")
		add_log_entry("Nexus module unmounted from [AI.name].", "output")
	SStgui.update_uis(src)

// ─── Датум ноды ФС ───────────────────────────────────────────────────────────

/datum/nt_fs_node
	var/node_name
	var/kind = "dir" // dir | exe | sys | proc
	var/list/children
	var/requires_root = FALSE
	var/owner
	/// Простой однострочный ответ на exec, для нод без кастомного поведения (пустая строка = ничего не печатать)
	var/exec_text = ""
	/// Если задано — exec сначала спрашивает y/n этим текстом, и только потом реально исполняет
	var/confirm_prompt

/datum/nt_fs_node/New(arg_name, node_kind)
	. = ..()
	node_name = arg_name
	kind = node_kind

/datum/nt_fs_node/proc/on_exec(mob/user, obj/machinery/computer/nt_kernel/console)
	if(kind == "proc")
		console.add_log_entry("exec: resource busy -- in use by another process.", "output")
		return
	if(exec_text)
		console.add_log_entry(exec_text, "output")

// ─── Кастомные исполняемые файлы ─────────────────────────────────────────────

/datum/nt_fs_node/ttl_reboot
	requires_root = TRUE

/datum/nt_fs_node/ttl_reboot/on_exec(mob/user, obj/machinery/computer/nt_kernel/console)
	if(console.rebooting)
		console.add_log_entry("exec: cannot start -- reboot protocol already in progress.", "output")
		return
	console.add_log_entry("Initiating system reboot protocol...", "output")
	console.start_system_reboot()

/// Монтирует/демонтирует модуль связи у ОДНОГО выбранного ИИ (выбор — через run_mount, см. ниже).
/// Тип приложения (ai_comm/malf_comm) определяется по факту того, какой у ИИ сейчас картридж —
/// malf-картридж получает malf_comm, обычный — ai_comm. Систему выдачи антаг-ролей не трогаю и не читаю.
/datum/nt_fs_node/module_mount
	// Реальная работа — в /obj/machinery/computer/nt_kernel/proc/start_module_mount_sequence(),
	// т.к. эта нода запускается не через exec/on_exec, а через отдельную команду mount с выбором цели.

/datum/nt_fs_node/law_manager
	owner = "ai_sys"

/datum/nt_fs_node/law_manager/on_exec(mob/user, obj/machinery/computer/nt_kernel/console)
	if(!console.is_root)
		console.add_log_entry("ACCESS DENIED. Security alert dispatched.", "output")
		console.trigger_console_alarm()
		return
	console.add_log_entry("Resource busy: law_manager is already running under a protected process.", "output")

// ─── Сборка дерева (строится один раз, общий на все консоли — см. var/static/fs_root) ──

/proc/build_nt_fs_tree()
	// /proc/*
	var/datum/nt_fs_node/proc_3563 = new("3563", "proc")
	var/datum/nt_fs_node/proc_8386 = new("8386", "proc")
	var/datum/nt_fs_node/proc_3686 = new("3686", "proc")
	var/datum/nt_fs_node/proc_2047 = new("2047", "proc")
	var/datum/nt_fs_node/proc_fdinfo = new("fdinfo", "proc")
	var/datum/nt_fs_node/proc_task = new("task", "proc")
	var/datum/nt_fs_node/proc_roundid = new("round-id", "proc")
	proc_roundid.children = list(proc_fdinfo, proc_task)

	var/datum/nt_fs_node/dir_proc = new("proc", "dir")
	dir_proc.children = list(proc_3563, proc_8386, proc_3686, proc_2047, proc_roundid)

	// /sbin/*
	var/datum/nt_fs_node/exe_pshell = new("pshell.exe", "exe")
	exe_pshell.exec_text = "Process already running."

	var/datum/nt_fs_node/exe_treemat = new("tree_mat.exe", "exe")

	var/datum/nt_fs_node/exe_recover = new("recover.exe", "exe")
	exe_recover.exec_text = "Diagnostic subroutine unavailable -- module not yet installed."

	var/datum/nt_fs_node/ttl_reboot/exe_ttlreboot = new("ttl_reboot.exe", "exe")
	exe_ttlreboot.confirm_prompt = "WARNING: this will initiate a full reboot of all local systems, affecting station-wide power, security doors and communications for approximately 90 seconds."

	var/datum/nt_fs_node/exe_telesys = new("tele_sys.exe", "exe")
	exe_telesys.exec_text = "Module offline -- link to telecommunications core not yet established."

	var/datum/nt_fs_node/dir_sbin = new("sbin", "dir")
	dir_sbin.children = list(exe_pshell, exe_treemat, exe_recover, exe_ttlreboot, exe_telesys)

	// /home/ai_sys/*
	var/datum/nt_fs_node/law_manager/exe_lawmanager = new("law_manager.exe", "exe")
	exe_lawmanager.confirm_prompt = "This will attempt to access the silicon law management subsystem."

	var/datum/nt_fs_node/exe_connmanager = new("conn_manager.exe", "exe")
	exe_connmanager.exec_text = "Module offline -- not yet implemented."

	var/datum/nt_fs_node/exe_servcont = new("serv_cont.exe", "exe")
	exe_servcont.exec_text = "Module offline -- not yet implemented."

	var/datum/nt_fs_node/dir_aisys = new("ai_sys", "dir")
	dir_aisys.owner = "ai_sys"
	// modules/nexus/ — монтируемый модуль связи (тип приложения ai_comm/malf_comm определяется на лету, по AI)
	var/datum/nt_fs_node/junk_nexus_a = new("cache.dat", "sys")
	junk_nexus_a.exec_text = "Binary data -- not executable."
	var/datum/nt_fs_node/junk_nexus_b = new("checksum.dat", "sys")
	junk_nexus_b.exec_text = "Binary data -- not executable."

	var/datum/nt_fs_node/module_mount/mount_nexus = new("mount.exe", "mount")
	mount_nexus.requires_root = TRUE

	var/datum/nt_fs_node/dir_module_nexus = new("nexus", "dir")
	dir_module_nexus.children = list(junk_nexus_a, junk_nexus_b, mount_nexus)

	var/datum/nt_fs_node/dir_modules = new("modules", "dir")
	dir_modules.children = list(dir_module_nexus)

	dir_aisys.children = list(exe_lawmanager, exe_connmanager, exe_servcont, dir_modules)

	var/datum/nt_fs_node/dir_alt5 = new("alt_5", "dir")

	var/datum/nt_fs_node/dir_home = new("home", "dir")
	dir_home.children = list(dir_alt5, dir_aisys)

	// /root/total_commander/*
	var/datum/nt_fs_node/sys_remote = new("remote_controler.sys", "sys")
	sys_remote.exec_text = "SIGNAL: ACTIVE -- uplink to Central Command monitoring array."

	var/datum/nt_fs_node/sys_rewriting = new("rewriting.sys", "sys")
	sys_rewriting.exec_text = "WARNING: unauthorized override in progress. Standby for silicon law revision."

	var/datum/nt_fs_node/dir_totalcommander = new("total_commander", "dir")
	dir_totalcommander.children = list(sys_remote, sys_rewriting)

	var/datum/nt_fs_node/dir_literator = new("literator", "dir")

	var/datum/nt_fs_node/dir_root = new("root", "dir")
	dir_root.children = list(dir_totalcommander, dir_literator)

	// Флейвор-заглушки без содержимого
	var/datum/nt_fs_node/dir_bin = new("bin", "dir")
	var/datum/nt_fs_node/dir_boot = new("boot", "dir")
	var/datum/nt_fs_node/dir_dev = new("dev", "dir")
	var/datum/nt_fs_node/dir_sys = new("sys", "dir")

	var/datum/nt_fs_node/fs_root_node = new("", "dir")
	fs_root_node.children = list(dir_root, dir_bin, dir_boot, dir_sbin, dir_dev, dir_proc, dir_sys, dir_home)

	return fs_root_node

// ══════════════════════════════════════════════════════════════════════════
// ДИНАМИЧЕСКАЯ ВЫДАЧА/ОТЗЫВ ПРИЛОЖЕНИЙ ПДА ИИ (Nexus / Advanced Nexus и т.д.)
// ══════════════════════════════════════════════════════════════════════════

/// Добавляет программу в картридж виртуального ПДА ИИ, если её там ещё нет.
/// Шаги update_shortcuts()/start_program()/SStgui.update_uis() — по образцу update_cartridge_for_antag(),
/// без них ярлык в ПДА появляется, но остаётся некликабельным.
/mob/living/silicon/ai/proc/grant_pda_app(datum/data/pda/app/app_type)
	if(!aiPDA?.cartridge)
		return FALSE
	for(var/datum/data/pda/app/existing in aiPDA.cartridge.programs)
		if(istype(existing, app_type))
			return FALSE // уже есть, не дублируем
	aiPDA.cartridge.programs += new app_type
	aiPDA.cartridge.update_programs(aiPDA)
	aiPDA.update_shortcuts()
	aiPDA.start_program(aiPDA.find_program(/datum/data/pda/app/main_menu))
	SStgui.update_uis(aiPDA)
	return TRUE

/// Убирает программу из картриджа виртуального ПДА ИИ, если она там есть
/mob/living/silicon/ai/proc/revoke_pda_app(datum/data/pda/app/app_type)
	if(!aiPDA?.cartridge)
		return FALSE
	for(var/datum/data/pda/app/existing in aiPDA.cartridge.programs)
		if(istype(existing, app_type))
			aiPDA.cartridge.programs -= existing
			qdel(existing)
			aiPDA.cartridge.update_programs(aiPDA)
			aiPDA.update_shortcuts()
			aiPDA.start_program(aiPDA.find_program(/datum/data/pda/app/main_menu))
			SStgui.update_uis(aiPDA)
			return TRUE
	return FALSE

