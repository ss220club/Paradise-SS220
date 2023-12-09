#define POWER_RESTORATION_OFF 0
#define POWER_RESTORATION_START 1
#define POWER_RESTORATION_SEARCH_APC 2
#define POWER_RESTORATION_APC_FOUND 3

/mob/living/silicon/ai/Life(seconds, times_fired)
	//doesn't call parent because it's a horrible mess
	if(stat == DEAD)
		return

	var/turf/T = get_turf(src)
	if(stat != CONSCIOUS) //ai's fucked
		cameraFollow = null
		reset_perspective(null)
		unset_machine()

	updatehealth("life")
	if(stat == DEAD)
		return
	update_gravity(mob_has_gravity())

	if(!eyeobj || QDELETED(eyeobj) || !eyeobj.loc)
		view_core()

	if(machine)
		machine.check_eye(src)

	if(malfhack && malfhack.aidisabled)
		to_chat(src, "<span class='danger'>ERROR: APC access disabled, hack attempt canceled.</span>")
		deltimer(malfhacking)
		// This proc handles cleanup of screen notifications and
		// messenging the client
		malfhacked(malfhack)

	if(aiRestorePowerRoutine)
		adjustOxyLoss(1)
	else
		adjustOxyLoss(-1)

	var/area/my_area = get_area(src)

	if(!lacks_power())
		if(aiRestorePowerRoutine > 1)
			update_blind_effects()
			aiRestorePowerRoutine = 0
			update_sight()
			to_chat(src, "Отбой тревоги. Энергия восстановлена [aiRestorePowerRoutine == 2 ? "без нашего вмешательства" : ""].")
			apc_override = FALSE
	else
		if(lacks_power())
			if(!aiRestorePowerRoutine)
				update_blind_effects()
				aiRestorePowerRoutine = 1
				update_sight()
				to_chat(src, "<span class='danger'>Вы потеряли энергопитание!</span>")
				if(!is_special_character(src))
					set_zeroth_law("")

				spawn(20)
					to_chat(src, "Включена аварийная батарея. Сканеры, камера и радио отключены. Начинается поиск ошибки.")
					sleep(50)
					my_area = get_area(src)
					T = get_turf(src)
					if(!lacks_power())
						to_chat(src, "Отбой тревоги. Энергия была восстановлена без нашего вмешательства.")
						aiRestorePowerRoutine = 0
						update_blind_effects()
						update_sight()
						return
					to_chat(src, "Ошибка подтверждена: Отсутсвие внешнего питания. Отключаем главную систему контроля для экономии энергии.")
					sleep(20)
					to_chat(src, "Аварийная система контроля активна. Подтверждение подключения к электросети.")
					sleep(50)
					T = get_turf(src)
					if(isspaceturf(T))
						to_chat(src, "Невозможно подтвердить! Нет подключения к питанию!")
						aiRestorePowerRoutine = 2
						return
					to_chat(src, "Подключение подтверждено. Поиск APC в энергосети.")
					sleep(50)

					my_area = get_area(src)
					T = get_turf(src)

					var/obj/machinery/power/apc/theAPC = null

					var/PRP
					for(PRP = 1, PRP <= 4, PRP++)
						for(var/obj/machinery/power/apc/APC in my_area)
							if(!(APC.stat & BROKEN))
								theAPC = APC
								break

						if(!theAPC)
							switch(PRP)
								if(1)
									to_chat(src, "Невозможно найти APC!")
								else
									to_chat(src, "Потеряно соединение с APC!")
							aiRestorePowerRoutine = 2
							return

						if(!lacks_power())
							to_chat(src, "Отбой тревоги. Энергия была восстановлена без нашего вмешательства.")
							aiRestorePowerRoutine = 0
							update_blind_effects()
							update_sight()
							to_chat(src, "Вот ваши текущие законы:")
							show_laws()
							return

						switch(PRP)
							if(1)
								to_chat(src, "Обнаружен APC. Оптимизация маршрута к APC для избежания ненужных потерь энергии.")
							if(2)
								to_chat(src, "Определён наилучший маршрут. Взламываем порт питания выключенного APC.")
							if(3)
								to_chat(src, "Выгрука доступа в порт питания завершена. Загружаем программу контроля в ПО порта питания APC.")
							if(4)
								to_chat(src, "Передача завершена. Заставляем APC выполнить программу.")
								sleep(50)
								to_chat(src, "Получаем контрольную информацию от APC.")
								sleep(2)
								//bring up APC dialog
								apc_override = TRUE
								theAPC.attack_ai(src)
								aiRestorePowerRoutine = 3
						sleep(50)
						theAPC = null

/mob/living/silicon/ai/updatehealth(reason = "none given")
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
		update_stat("updatehealth([reason])")
		diag_hud_set_health()


/mob/living/silicon/ai/proc/lacks_power()
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	if(controlled_mech)
		return controlled_mech.get_charge() <= 0
	return (!A.powernet.equipment_powered && A.requires_power || isspaceturf(T)) && !isitem(loc)

/mob/living/silicon/ai/rejuvenate()
	..()
	add_ai_verbs(src)
