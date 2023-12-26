/obj/machinery/vox_trader
	name = "Расчичетчикик"
	desc = "Приемная и расчетная связная машина для ценностей. Проста также как еда воксов."
	// icon = 'icons/obj/recycling.dmi'
	// icon_state = "grinder-o0"
	icon = 'modular_ss220/antagonists/icons/trader_machine.dmi'
	icon_state = "trader-idle"
	max_integrity = 5000
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = FALSE

	var/cooldown = 3 SECONDS
	var/cooldown_for_each_item = 1 SECONDS
	var/is_trading_now = FALSE

	var/list/connected_instruments = list()

	// Забавные взаимодействия
	var/angry_count = 0
	var/list/blacklist = list()

	// Данные для подсчета драгоценностей выполнения задачи.
	// Обновляются при первом взаимодействии если есть воксы-рейдеры.
	var/precious_collected_names_list = list()
	var/precious_collected_value = 0
	var/precious_value
	var/collected_access_list = list()
	var/collected_tech_dict = list()

	var/list = special_precious_objects_list = list(
		/obj/item/areaeditor/blueprints/ce,
		/obj/item/disk/nuclear,
		/obj/item/clothing/suit/armor/reactive,
		/obj/item/documents,
	)

	// ========= МНОЖИТЕЛИ =========

	// произведения за параметры
	var/tech_mult = 3
	var/weight_mult = 3
	var/force_mult = 5

	// делители за параметры
	var/armor_div = 10
	var/stack_div = 4
	var/temp_div = 5
	var/no_unique_tech_div = 4

	// дополнительные бонусы
	var/integrity_reward = 5
	var/electroprotect_reward = 50
	var/permeability_reward	= 20
	var/highrisk_reward = 300
	var/valuable_highrisk_reward = 500
	var/value_access_reward = 100
	var/valuable_access_reward = 500
	var/unique_tech_level_reward = 50

	// дополнительные списки
	var/highrisk_list = list()
	var/valuable_access_list = list()
	var/valuable_tech_list = list("bluespace", "syndicate", "combat", "abductor")

	// =============================

/obj/machinery/vox_trader/New()
	. = ..()
	for(var/theft_type in subtypesof(/datum/theft_objective))
		highrisk_list += new theft_type
	valuable_access_list += get_region_accesses(REGION_COMMAND) + get_all_centcom_access() + get_all_syndicate_access() + get_all_misc_access()

/obj/machinery/vox_trader/attack_hand(mob/user)
	if(!check_usable(user))
		return
	add_fingerprint(user)
	INVOKE_ASYNC(src, PROC_REF(do_trade, user))

/obj/machinery/vox_trader/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/hand_valuer))
		var/obj/item/hand_valuer/valuer = I
		to_chat(span_green("Устройство [valuer.connected_trader ? "пере" : ""]инициализировано в системе."))
		valuer.connected_trader = src

/obj/machinery/vox_trader/attack_ai(mob/user)
	return FALSE	// Ха-ха, глупая железяка не понимает как пользоваться технологиями ВОКСов!

/obj/machinery/vox_trader/proc/check_usable(mob/user)
	. = FALSE

	if(issilicon(user))
		return

	if(!isvox(user))
		to_chat(user, span_notice("Вы осматриваете [src] и не понимаете как оно работает и куда сувать свои пальцы..."))
		return

	if(is_trading_now)
		to_chat(user, span_warning("[src] обрабатываем и пересчитывает ценности. Ожидайте."))
		return

	if(length(blacklist) && (user in blacklist))
		to_chat(user, span_warning("Вы пытаетесь связаться с [src], но никто не отзывается."))
		return

	return TRUE

/obj/machinery/vox_trader/proc/sparks()
	do_sparks(5, 1, get_turf(src))

/obj/machinery/vox_trader/proc/do_trade(mob/user)
	playsound(get_turf(src), 'sound/weapons/flash.ogg', 25, 1)
	is_trading_now = TRUE

	sparks()
	wait(cooldown)	// кулдаун чтобы не спамили нажатиями и звук успел проиграться

	var/list/items_list = get_turf(src)

	if(!length(items))
		sparks()
		is_trading_now = FALSE
		angry_count++
		switch(angry_count)
			if(3)
				atom_say(span_warning("Вами очень недовольны. Где товар?!"))
			if(4)
				atom_say(span_warning("Вами ОЧЕНЬ недовольны... Нам нужен реальный товар!"))
			if(5)
				atom_say(span_warning("Отправляй товар!"))
			if(6)
				atom_say(span_warning("Что ты щелкаешь как дятел?!"))
			if(7)
				atom_say(span_warning("Или ты будешь отправлять товар или не будешь больше отправлять ничего!"))
			if(8)
				atom_say(span_warning("Я не буду с тобой торговать пока ты не дашь товар!"))
			if(9)
				atom_say(span_warning("Ты шутки шутишь? Товар. Последнее предупреждение."))
			if(10)
				atom_say(span_warning("[user.name], [src] больше не будет с вами торговать!"))
				blacklist.Add(user)	// Докикикировался.
			else
				atom_say(span_warning("Вами недовольны. Где товар?"))

		return

	angry_count = 0
	atom_say(span_notice("Вами довольны. Начат пересчет ценностей, ожидайте."))

	var/cooldown_items_time = length(items) * cooldown_for_each_item
	wait(cooldown_items_time)	// делаем вид что происходит пересчет

	if(!src || QDELETED(src))
		is_trading_now = FALSE
		return

	flick("trader-beam", src)
	playsound(get_turf(src), 'sound/weapons/contractorbatonhit.ogg', 25, TRUE)

	var/values_sum = get_value(user, items_list, TRUE)
	if(values_sum > 100)
		atom_say(span_greenannounce("Расчет окончен. [values_sum > 2000 ? "Крайне ценно!" : "Ценно!"] Ваша доля [values_sum]"))
	else
		atom_say(span_notice("Расчет окончен. Вы бы еще консервных банок насобирали! Ваша доля [values_sum]"))

/obj/machinery/vox_trader/proc/get_value(mob/user, list/items_list, is_need_grading = FALSE)
	var/values_sum = 0
	var/accepted_access = list()

	// проверка для бонусной диалоговой строки
	var/is_weight = FALSE
	var/is_equip = FALSE
	var/is_tech = FALSE
	var/is_tech_valuable = FALSE
	var/is_tech_unique = FALSE
	var/is_access_unique = FALSE

	for(var/obj/I in items_list)
		if(I.anchored)
			continue

		if(!isspacecash()) // воксам не нужны деньги мяса.
			continue

		var/temp_values_sum = 0

		// целостность объекта
		if(I.obj_integrity > 0)
			temp_values_sum += round((I.obj_integrity / I.max_integrity) * integrity_mult)

		// бонус за весомость
		if(I.w_class)
			temp_values_sum += I.w_class * weight_mult
			is_weight = TRUE

		if(length(I.armor))
			var/temp_val = 0
			for(var/param in I.armor)
				var/temp_param = I.armor[param] == INFINITY ? 500 : I.armor[param]
				var/div = 1
				if(param in list(FIRE, ACID))
					div = armor_div	// избегаем легких очков за часто встречаемые свойства.
				temp_val += div > 1 ? round(temp_val / div) : temp_val
			if(temp_val)
				temp_values_sum += temp_val
				is_equip = TRUE

		if(I.force || I.throwforce)
			temp_values_sum += round((I.force + I.throwforce) * force_mult + (throw_speed * throw_range))

		if(istype(I, /obj/item/disk/tech_disk))
			var/obj/item/disk/tech_disk/disk = I
			var/datum/tech/tech = disk.stored
			I.origin_tech = "[tech.id]=[tech.level]"

		if(I.origin_tech)
			var/list/tech_list = params2list(I.origin_tech)
			for(var/tech in tech_list)
				var/temp_mult = 1
				if(tech in collected_tech_dict)
					if(collected_tech_dict[tech] < tech_list[tech])
						temp_values_sum += unique_tech_level_reward * (tech_list[tech] - collected_tech_dict[tech])
						collected_tech_dict[tech] = tech_list[tech]
						is_tech_unique = TRUE
				else
					temp_values_sum += unique_tech_level_reward * tech_list[tech]
					collected_tech_dict.Add(list(tech = tech_list[tech]))
					is_tech_unique = TRUE
				if(tech in valuable_tech_list)
					temp_mult = tech_list[tech]
					is_tech_valuable = TRUE
				if(!is_tech_unique)	// ценим уникальные разработки, а не спам продукцией абдукторов из протолата
					temp_mult /= no_unique_tech_div
				var/excess_mult = tech_list[tech] > 7 ? 2 : 1	// переизбыток
				temp_values_sum += round(tech_list[tech] * tech_mult * temp_mult * excess_mult)
				is_tech = TRUE

		if(istype(I, /obj/item/stack))
			var/obj/item/stack/stack = I
			temp_values_sum *= round(stack.amount / stack_div)

		if(isstorage(I))
			var/obj/item/storage/storage = I
			var/test = storage.contents
			 // !!!! ПРОТЕСТИРОВАТЬ ЧТО НЕ ЗАЦИКЛИЛОСЬ И ДО ЭТОГО НЕ ВКЛЮЧАЛОСЬ В ПОИСКЕ ПО ТЮРФУ
			var/test2 = storage.contents
			//temp_values_sum += get_value(storage.contents)

		if(istype(I, /obj/item/card/id))
			var/obj/item/card/id/id
			for(var/access in id.access)
				if(access in collected_access_list)
					continue
				if(access in valuable_access_list)
					temp_values_sum += valuable_access_reward
					is_access_unique = TRUE
				else
					temp_values_sum += value_access_reward
				accepted_access.Add(access)

		if(isitem(I))
			var/temp_value = 0
			var/obj/item/item = I
			temp_value += temp_values_sum / item.toolspeed
			if(I.max_heat_protection_temperature)
				temp_value += I.max_heat_protection_temperature / temp_div
			if(I.siemens_coefficient)
				temp_value += electroprotect_reward * (1 - I.siemens_coefficient)
			if(I.permeability_coefficient)
				temp_value += permeability_reward * (1 - I.permeability_coefficient)
			temp_values_sum += round(temp_value)

		for(var/datum/theft_objective/objective in highrisk_list)
			if(!istype(I, objective.type))
				continue
			if(istype(I, /obj/item/aicard))
				for(var/mob/living/silicon/ai/A in I)
					if(!(isAI(A) && A.stat != 2)) //See if any AI's are alive inside that card.
						continue
			var/temp_value = highrisk_reward
			if(objective.special_equipment)
				temp_value *= 2
			if(objective.protected_jobs)
				for(var/job in objective.protected_jobs)
					switch(job)
						if("Captain", "Head Of Security")
							temp_value *= 2
						else
							temp_value *= 1.5
			temp_values_sum += temp_value

		if(I in special_precious_objects_list)
			temp_values_sum += valuable_highrisk_reward

		//Оцениваем драгоценность для задания
		if(is_need_grading)
			precious_grading(user, I, temp_values_sum)

		// ____________________________
		// Завершаем рассчет
		values_sum += temp_values_sum
		qdel(I)

	// Заносим наши принятые списки
	if(!is_need_grading)
		collected_access_list += accepted_access

	var/addition_text = ""
	if(accepted_access)
		addition_text += span_boldnotice("\nОценка не имеющихся доступов: \n")
		for(var/access in accepted_access)
			addition_text += span_notice("[get_access_desc(A)]; ")
		if(is_access_unique)
			addition_text += span_good("\nИмеются ценные доступы. Очень ценно!")
	if(is_weight)
		addition_text += span_notice("\nТяжесть - значит надежность.")
	if(is_equip)
		addition_text += span_notice("\nХорошее снаряжение. Ценно.")
	if(is_tech)
		addition_text += span_notice("\nТехнологии - ценно!")
	if(is_tech_unique)
		addition_text += span_notice("\nНовые технологии! Очень ценно! Необходимо!")
	if(is_tech_valuable)
		addition_text += span_notice("\nЦенные технологии! Крайне ценно!")
	if(addition_text != "")
		to_chat(user, addition_text)

 	// Деноминируем кикикридиты и забираем небольшой процент в семью.
	values_sum /= 10				// деноминируем
	values_sum -= values_sum % 10	// забираем процентик
	return round(values_sum)

/obj/machinery/vox_trader/proc/precious_grading(mob/user, obj/I, value)
	if(!user)
		return
	if(!precious_value)
		var/datum/antagonist/vox_raider/raider = user.mind?.has_antag_datum(/datum/antagonist/vox_raider)
		if(!raider)
			return
		precious_value = raider.precious_value
	if(value >= precious_value)
		precious_collected_names_list.Add(I.name)
		precious_collected_value += value
