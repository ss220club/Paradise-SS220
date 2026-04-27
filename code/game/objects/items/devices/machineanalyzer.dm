/obj/item/robotanalyzer
	name = "machine analyzer"
	desc = "Ручной сканер, способный проверять повреждения синтетиков и состояние оборудования."
	icon = 'icons/obj/device.dmi'
	icon_state = "robotanalyzer"
	inhand_icon_state = "analyzer"
	flags = CONDUCT
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = "magnets=1;biotech=1"

/obj/item/robotanalyzer/proc/handle_clumsy(mob/living/user)
	var/list/msgs = list()
	user.visible_message(SPAN_WARNING("[user] анализирует компоненты пола!"), SPAN_WARNING("Вы по-глупому пытаетесь проанализировать компоненты пола!"))
	msgs += SPAN_NOTICE("Анализ результатов для пола: \n\t Общее состояние: Неизвестно")
	msgs += SPAN_NOTICE("	 Детализация повреждений: <font color='#FFA500'>[0]</font>/<font color='red'>[0]</font>")
	msgs += SPAN_NOTICE("Основные: <font color='#FFA500'>Ожоги</font><font color ='red'>/Ушибы</font>")
	msgs += SPAN_NOTICE("Температура шасси: ???")
	to_chat(user, chat_box_healthscan(msgs.Join("<br>")))

/obj/item/robotanalyzer/attack_obj__legacy__attackchain(obj/machinery/M, mob/living/user) // Scanning a machine object
	if(!ismachinery(M))
		return
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || user.getBrainLoss() >= 60) && prob(50))
		handle_clumsy(user)
		return
	user.visible_message(SPAN_NOTICE("[user] анализирует компоненты [M.declent_ru(GENITIVE)] с помощью [src.declent_ru(INSTRUMENTAL)]."), SPAN_NOTICE("Вы анализируете компоненты [M.declent_ru(GENITIVE)] с помощью [src.declent_ru(INSTRUMENTAL)]."))
	machine_scan(user, M)
	add_fingerprint(user)

/obj/item/robotanalyzer/proc/machine_scan(mob/user, obj/machinery/M)
	if(M.obj_integrity == M.max_integrity)
		to_chat(user, SPAN_NOTICE("[M.declent_ru(NOMINATIVE)] полностью работоспособен."))
		return
	to_chat(user, SPAN_NOTICE("Обнаружены структурные повреждения! Общая целостность [M.declent_ru(GENITIVE)] - [round((M.obj_integrity / M.max_integrity) * 100)]%."))
	if(M.stat & BROKEN) // Displays alongside above message. Machines with a "broken" state do not become broken at 0% HP - anything that reaches that point is destroyed
		to_chat(user, SPAN_WARNING("Дополнительный анализ: Обнаружен полный отказ компонента! Требуется полная реконструкция [M.declent_ru(GENITIVE)] для ремонта."))

/obj/item/robotanalyzer/attack__legacy__attackchain(mob/living/M, mob/living/user) // Scanning borgs, IPCs/augmented crew, and AIs
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || user.getBrainLoss() >= 60) && prob(50))
		handle_clumsy(user)
		return
	user.visible_message(SPAN_NOTICE("[user] анализирует компоненты [M.declent_ru(GENITIVE)] с помощью [src.declent_ru(INSTRUMENTAL)]."), SPAN_NOTICE("Вы анализируете компоненты [M.declent_ru(GENITIVE)] с помощью [src.declent_ru(INSTRUMENTAL)]."))
	robot_healthscan(user, M)
	add_fingerprint(user)

/proc/robot_healthscan(mob/user, mob/living/M)
	var/scan_type
	var/list/msgs = list()
	if(isrobot(M))
		scan_type = "robot"
	else if(ishuman(M))
		scan_type = "prosthetics"
	else if(is_ai(M))
		scan_type = "ai"
	else
		to_chat(user, SPAN_WARNING("Вы не можете анализировать нероботизированные объекты!"))
		return
	switch(scan_type)
		if("robot")
			var/burn = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
			var/brute = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
			msgs += SPAN_NOTICE("Результат анализа для [M.declent_ru(GENITIVE)]: \n\t Общее состояние: [M.stat == DEAD ? "полностью отключён" : "Работоспособность [M.health]%"]")
			msgs += "	 Основные: <font color='#FFA500'>Электроника</font>/<font color='red'>Механика</font>"
			msgs += "	 Детализация повреждений: <font color='#FFA500'>[burn]</font> - <font color='red'>[brute]</font>"
			if(M.timeofdeath && M.stat == DEAD)
				msgs += SPAN_NOTICE("Время отключения: [station_time_timestamp("hh:mm:ss", M.timeofdeath)]")
			var/mob/living/silicon/robot/H = M
			var/list/damaged = H.get_damaged_components(TRUE, TRUE, TRUE) // Get all except the missing ones
			var/list/missing = H.get_missing_components()
			msgs += SPAN_NOTICE("Локальные повреждения:")
			if(!LAZYLEN(damaged) && !LAZYLEN(missing))
				msgs += SPAN_NOTICE("	 Состояние компонентов - OK.")
			else
				if(LAZYLEN(damaged))
					for(var/datum/robot_component/org in damaged)
						msgs += text("<span class='notice'>	 []: [][] - [] - [] - []</span>",	\
						capitalize(org.name),					\
						(org.is_destroyed())	?	"<font color='red'><b>УНИЧТОЖЕН</b></font> "							:"",\
						(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	:0,	\
						(org.brute_damage > 0)	?	"<font color='red'>[org.brute_damage]</font>"							:0,		\
						(org.toggled)	?	"Переключен на ВКЛ"	:	"<font color='red'>Переключен на ВЫКЛ</font>",\
						(org.powered)	?	"Питание ВКЛ"		:	"<font color='red'>Питание ВЫКЛ</font>")
				if(LAZYLEN(missing))
					for(var/datum/robot_component/org in missing)
						msgs += SPAN_WARNING("	 [capitalize(org.name)]: ПОТЕРЯН")
				if(H.emagged && prob(5))
					msgs += SPAN_WARNING("	 ОШИБКА: ВНУТРЕННИЕ СИСТЕМЫ СКОМПРОМЕТИРОВАНЫ")
		if("prosthetics")
			var/mob/living/carbon/human/H = M
			var/is_ipc = ismachineperson(H)
			msgs += "<span class='notice'>Анализ результатов для [M.declent_ru(GENITIVE)]: [is_ipc ? "\n\t Общее состояние: [H.stat == DEAD ? "полностью отключён" : "Работоспособность [H.health]%"]</span><hr>" : "<hr>"]" //for the record im sorry
			msgs += "	 Основные: <font color='#FFA500'>Электроника</font>/<font color='red'>Механика</font>"
			msgs += SPAN_NOTICE("Внешние протезы:")
			var/organ_found
			if(LAZYLEN(H.internal_organs))
				for(var/obj/item/organ/external/E in H.bodyparts)
					if(!E.is_robotic() || (is_ipc && (E.get_damage() == 0))) //Non-IPCs have their cybernetics show up in the scan, even if undamaged
						continue
					organ_found = TRUE
					msgs += "[E.name]: <font color='red'>[E.brute_dam]</font> <font color='#FFA500'>[E.burn_dam]</font>"
			if(!organ_found)
				msgs += SPAN_WARNING("Протезы не обнаружены.")
			msgs += "<hr>"
			msgs += SPAN_NOTICE("Внутренние протезы:")
			organ_found = null
			if(LAZYLEN(H.internal_organs))
				for(var/obj/item/organ/internal/O in H.internal_organs)
					if(!O.is_robotic() || istype(O, /obj/item/organ/internal/cyberimp) || O.stealth_level > 1)
						continue
					organ_found = TRUE
					msgs += "[capitalize(O.name)]: <font color='red'>[O.damage]</font>"
			if(!organ_found)
				msgs += SPAN_WARNING("Протезы не обнаружены.")
			msgs += "<hr>"
			msgs += SPAN_NOTICE("Кибернетические импланты:")
			organ_found = null
			if(LAZYLEN(H.internal_organs))
				for(var/obj/item/organ/internal/cyberimp/I in H.internal_organs)
					if(I.stealth_level > 1)
						continue
					organ_found = TRUE
					msgs += "[capitalize(I.name)]: <font color='red'>[I.crit_fail ? "КРИТИЧЕСКАЯ НЕИСПРАВНОСТЬ" : I.damage]</font>"
			if(!organ_found)
				msgs += SPAN_WARNING("Импланты не обнаружены.")
			msgs += "<hr>"
			if(is_ipc)
				msgs.Add(get_chemscan_results(user, H))
			msgs += SPAN_NOTICE("Температура субъекта: [round(H.bodytemperature-T0C, 0.01)]&deg;C ([round(H.bodytemperature*1.8-459.67, 0.01)]&deg;F)")
		if("ai")
			var/mob/living/silicon/ai/A = M
			var/burn = A.getFireLoss() > 50 	? 	"<b>[A.getFireLoss()]</b>" 		: A.getFireLoss()
			var/brute = A.getBruteLoss() > 50 	? 	"<b>[A.getBruteLoss()]</b>" 	: A.getBruteLoss()
			msgs += SPAN_NOTICE("Анализ результатов для [M.declent_ru(GENITIVE)]: \n\t Общее состояние: [A.stat == DEAD ? "полностью отключён" : "Работоспособность [A.health]%"]")
			msgs += "	 Основные: <font color='#FFA500'>Электроника</font>/<font color='red'>Механика</font>"
			msgs += "	 Детализация повреждений: <font color='#FFA500'>[burn]</font> - <font color='red'>[brute]</font>"
	to_chat(user, chat_box_healthscan(msgs.Join("<br>")))
