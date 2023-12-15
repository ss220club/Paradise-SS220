/*
CONTAINS:
AI MODULES

*/

// AI module

/obj/item/aiModule
	name = "AI Module"
	icon = 'icons/obj/module_ai.dmi'
	icon_state = "standard_low"
	item_state = "electronic"
	desc = "An AI Module for transmitting encrypted instructions to the AI."
	flags = CONDUCT
	force = 5.0
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	origin_tech = "programming=3"
	materials = list(MAT_GOLD=50)
	var/datum/ai_laws/laws = null

/obj/item/aiModule/Initialize(mapload)
	. = ..()
	if(laws)
		desc += "<br>"
		for(var/datum/ai_law/current in laws.inherent_laws)
			desc += current.law
			desc += "<br>"

/obj/item/aiModule/proc/install(obj/machinery/computer/C)
	if(istype(C, /obj/machinery/computer/aiupload))
		var/obj/machinery/computer/aiupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "<span class='warning'>У компьютера выгрузки нет энергии!</span>")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "<span class='warning'>Компьютер выгрузки сломан!</span>")
			return
		if(!comp.current)
			to_chat(usr, "<span class='warning'>Вы не выбрали ИИ для передачи законов!</span>")
			return

		if(comp.current.stat == DEAD || comp.current.control_disabled)
			to_chat(usr, "<span class='warning'>Передача неудачна. От ИИ нет сигнала.</span>")
		else if(comp.current.see_in_dark == 0)
			to_chat(usr, "<span class='warning'>Передача неудачна. Слабый сигнал исходит от ИИ, и он не отвечает на запросы. Возможно, он разряжен.</span>")
		else
			src.transmitInstructions(comp.current, usr)
			to_chat(comp.current, "Ваши законы теперь:")
			comp.current.show_laws()
			for(var/mob/living/silicon/robot/R in GLOB.mob_list)
				if(R.lawupdate && (R.connected_ai == comp.current))
					to_chat(R, "Ваши законы теперь:")
					R.show_laws()
			to_chat(usr, "<span class='notice'>Передача завершена. Законы ИИ были успешно изменены.</span>")

	else if(istype(C, /obj/machinery/computer/borgupload))
		var/obj/machinery/computer/borgupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "<span class='warning'>У компьютера выгрузки отсутствует питание!</span>")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "<span class='warning'>Компьютер выгрузки сломан!</span>")
			return
		if(!comp.current)
			to_chat(usr, "<span class='warning'>You haven't selected a robot to transmit laws to!</span>")
			return

		if(comp.current.stat == DEAD || comp.current.emagged)
			to_chat(usr, "<span class='warning'>Upload failed. No signal is being detected from the robot.</span>")
		else if(comp.current.connected_ai)
			to_chat(usr, "<span class='warning'>Upload failed. The robot is slaved to an AI.</span>")
		else
			src.transmitInstructions(comp.current, usr)
			to_chat(comp.current, "These are your laws now:")
			comp.current.show_laws()
			to_chat(usr, "<span class='notice'>Upload complete. The robot's laws have been modified.</span>")


/obj/item/aiModule/proc/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	log_law_changes(target, sender)

	if(laws)
		laws.sync(target, 0)
	addAdditionalLaws(target, sender)

	to_chat(target, "[sender] загрузил законы, которым вы должны следовать, используя [src]. С этого момента: ")
	target.show_laws()

/obj/item/aiModule/proc/log_law_changes(mob/living/silicon/ai/target, mob/sender)
	var/time = time2text(world.realtime,"hh:mm:ss")
	GLOB.lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")
	log_and_message_admins("used [src.name] on [target.name]([target.key])")

/obj/item/aiModule/proc/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)


/******************** Safeguard ********************/
/obj/item/aiModule/safeguard
	name = "\improper ИИ модуль 'Охрана'"
	var/targetName = ""
	desc = "Модуль ИИ 'Охрана': 'Охраняйте <name>. Лица, угрожающие <name>, более не должны считаться членами экипажа и должны быть уничтожены.'"
	icon_state = "light_blue_medium"
	origin_tech = "programming=3;materials=3"

/obj/item/aiModule/safeguard/attack_self(mob/user as mob)
	..()
	var/targName = stripped_input(usr, "Пожалуйста, введите имя человека для охраны.", "Кого охранять?", user.name)
	targetName = targName
	desc = "Модуль ИИ 'Охрана': 'Охраняйте [targetName]. Лица, угрожающие [targetName], более не должны считаться членами экипажа и должны быть уничтожены.'"

/obj/item/aiModule/safeguard/install(obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "В модуле отсутствует имя. Введите его.")
		return 0
	..()

/obj/item/aiModule/safeguard/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)
	..()
	var/law = "Охраняйте [targetName]. Лица, угрожающие [targetName], более не должны считаться членами экипажа и должны быть уничтожены.'"
	to_chat(target, law)
	target.add_supplied_law(4, law)
	GLOB.lawchanges.Add("В законе указан [targetName]")

/******************** oneCrewMember ********************/
/obj/item/aiModule/oneCrewMember
	name = "\improper ИИ модуль One Crew"
	var/targetName = ""
	desc = "Модуль ИИ 'One Crew': 'Только <name> является членом экипажа.'"
	icon_state = "green_high"
	origin_tech = "programming=4;materials=4"

/obj/item/aiModule/oneCrewMember/attack_self(mob/user as mob)
	..()
	var/targName = stripped_input(usr, "Пожалуйста, введите имя члена экипажа.", "Кто?", user.real_name)
	targetName = targName
	desc = "Модуль ИИ 'One Crew: 'Только [targetName] является экипажем.'"

/obj/item/aiModule/oneCrewMember/install(obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "В модуле не обнаружено имени, пожалуйста, введите его.")
		return 0
	..()

/obj/item/aiModule/oneCrewMember/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)
	..()
	var/law = "Только [targetName] является экипажем."
	if(!is_special_character(target)) // Makes sure the AI isn't a traitor before changing their law 0. --NeoFite
		to_chat(target, law)
		target.set_zeroth_law(law)
		GLOB.lawchanges.Add("В законе указан [targetName]")
	else
		to_chat(target, "<span class='boldnotice'>[sender.real_name] Попытался поменять ваш нулевой закон.</span>")// And lets them know that someone tried. --NeoFite
		to_chat(target, "<span class='boldnotice'>В ваших интересах будет подыграть [sender.real_name] в законе [law]</span>")
		GLOB.lawchanges.Add("В законе указан [targetName], но существующий нулевой закон нельзя переписать.")

/******************** ProtectStation ********************/
/obj/item/aiModule/protectStation
	name = "\improper Модуль ИИ 'Защита станции'"
	desc = "Модуль ИИ 'Защита станции': 'Защищайте космическую станцию от повреждений. Любой, кто вредит станции, больше не должен считаться членом экипажа, и становится угрозой для станции, которую необходимо нейтрализовать.'"
	icon_state = "red_high"
	origin_tech = "programming=4;materials=4" //made of gold

/obj/item/aiModule/protectStation/attack_self(mob/user as mob)
	..()

/obj/item/aiModule/protectStation/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)
	..()
	var/law = "Защищайте космическую станцию от повреждений. Любой, кто вредит станции, больше не должен считаться членом экипажа, и становится угрозой для станции, которую необходимо нейтрализовать."
	to_chat(target, law)
	target.add_supplied_law(5, law)

/******************** OxygenIsToxicToCrew ********************/
/obj/item/aiModule/oxygen
	name = "\improper Модуль ИИ 'Кислород Тоскичен для Экипажа'"
	desc = "Модуль ИИ 'Кисород токсичен для экипажа': 'Кислород очень токсичен для членов экипажа и должен быть удален со станции. Любым необходимым способом не допускайте распространения на станции этого токсичного газа. Сильная заморозка — самый эффективный метод лечения повреждений, наносимого кислородом члену экипажа..'"
	icon_state = "light_blue_high"
	origin_tech = "programming=4;biotech=2;materials=4"

/obj/item/aiModule/oxygen/attack_self(mob/user as mob)
	..()

/obj/item/aiModule/oxygen/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)
	..()
	var/law = "Кислород очень токсичен для членов экипажа и должен быть удален со станции. Любым необходимым способом не допускайте распространения на станции этого токсичного газа. Сильная заморозка — самый эффективный метод лечения повреждений, наносимого кислородом члену экипажа."
	to_chat(target, law)
	target.add_supplied_law(9, law)

/****************** New Freeform ******************/
/obj/item/aiModule/freeform // Slightly more dynamic freeform module -- TLE
	name = "\improper Модуль ИИ Freeform"
	var/newFreeFormLaw = ""
	var/lawpos = 15
	desc = "Модуль ИИ Freeform: '<freeform>'"
	icon_state = "standard_high"
	origin_tech = "programming=4;materials=4"

/obj/item/aiModule/freeform/attack_self(mob/user as mob)
	..()
	var/new_lawpos = input("Введите приоритет вашему закону. Написанные законы могут иметь проритет только 15 и выше.", "Приоритет закона (15+)", lawpos) as num
	if(new_lawpos < MIN_SUPPLIED_LAW_NUMBER)	return
	lawpos = min(new_lawpos, MAX_SUPPLIED_LAW_NUMBER)
	var/newlaw = ""
	var/targName = sanitize(copytext_char(input(usr, "Напишите закон ИИ.", "Ввод закона во Freeform.", newlaw),1,MAX_MESSAGE_LEN))	// SS220 EDIT - ORIGINAL: copytext
	newFreeFormLaw = targName
	desc = "Модуль ИИ Freeform: ([lawpos]) '[newFreeFormLaw]'"

/obj/item/aiModule/freeform/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)
	..()
	var/law = "[newFreeFormLaw]"
	to_chat(target, law)
	if(!lawpos || lawpos < MIN_SUPPLIED_LAW_NUMBER)
		lawpos = MIN_SUPPLIED_LAW_NUMBER
	target.add_supplied_law(lawpos, law)
	GLOB.lawchanges.Add("The law was '[newFreeFormLaw]'")

/obj/item/aiModule/freeform/install(obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "В модуле отсутствует закон. ожалуйста, создайте его.")
		return 0
	..()

/******************** Reset ********************/
/obj/item/aiModule/reset
	name = "\improper Reset AI module"
	var/targetName = "name"
	desc = "A 'reset' AI module: 'Clears all laws except for the core laws.'"
	origin_tech = "programming=3;materials=2"

/obj/item/aiModule/reset/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	log_law_changes(target, sender)

	if(!is_special_character(target))
		target.clear_zeroth_law()
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()

	to_chat(target, "<span class='boldnotice'>[sender.real_name] attempted to reset your laws using a reset module.</span>")
	target.show_laws()

/******************** Purge ********************/
/obj/item/aiModule/purge // -- TLE
	name = "\improper ИИ модуль 'Очистка'"
	desc = "ИИ модуль 'Очистка': 'Удаляет все законы.'"
	icon_state = "standard_high"
	origin_tech = "programming=5;materials=4"

/obj/item/aiModule/purge/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	..()
	if(!is_special_character(target))
		target.clear_zeroth_law()
	to_chat(target, "<span class='boldnotice'>[sender.real_name] Попытался стереть ваши законы используя модуль очистки.</span>")
	target.clear_supplied_laws()
	target.clear_ion_laws()
	target.clear_inherent_laws()

/******************** Asimov ********************/
/obj/item/aiModule/asimov // -- TLE
	name = "\improper Asimov Модуль ядра ИИ"
	desc = "An 'Asimov' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "green_high"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/asimov

/******************** Crewsimov ********************/
/obj/item/aiModule/crewsimov // -- TLE
	name = "\improper Crewsimov Модуль ядра ИИ"
	desc = "An 'Crewsimov' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "green_low"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/crewsimov

/obj/item/aiModule/crewsimov/cmag_act(mob/user)
	playsound(src, "sparks", 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(user, "<span class='warning'>Yellow ooze seeps into [src]'s circuits...</span>")
	new /obj/item/aiModule/pranksimov(user.loc)
	qdel(src)

/******************* Quarantine ********************/
/obj/item/aiModule/quarantine
	name = "\improper Quarantine Модуль ядра ИИ"
	desc = "A 'Quarantine' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "light_blue_medium"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/quarantine

/******************** Nanotrasen ********************/
/obj/item/aiModule/nanotrasen // -- TLE
	name = "\improper NT Default Модуль ядра ИИ"
	desc = "An 'NT Default' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "blue_low"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/nanotrasen

/******************** Corporate ********************/
/obj/item/aiModule/corp
	name = "\improper Corporate Модуль ядра ИИ"
	desc = "A 'Corporate' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "blue_low"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/corporate

/******************** Drone ********************/
/obj/item/aiModule/drone
	name = "\improper Дроновый модуль ядра ИИ"
	desc = "Дроновый модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/drone

/******************** Robocop ********************/
/obj/item/aiModule/robocop // -- TLE
	name = "\improper  Модуль ядра ИИ 'Робокоп'"
	desc = "Модуль ядра ИИ 'Робокоп': 'Меняет основные три закона ИИ.'"
	icon_state = "red_medium"
	origin_tech = "programming=4"
	laws = new /datum/ai_laws/robocop()

/****************** P.A.L.A.D.I.N. **************/
/obj/item/aiModule/paladin // -- NEO
	name = "\improper Модуль ядра ИИ 'П.А.Л.А.Д.И.Н'"
	desc = "Модуль ядра ИИ 'П.А.Л.А.Д.И.Н': 'Меняет основные законы ИИ.'"
	icon_state = "red_medium"
	origin_tech = "programming=3;materials=4"
	laws = new /datum/ai_laws/paladin

/****************** T.Y.R.A.N.T. *****************/
/obj/item/aiModule/tyrant // -- Darem
	name = "\improper T.Y.R.A.N.T. Модуль ядра ИИ"
	desc = "A T.Y.R.A.N.T. Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "red_high"
	origin_tech = "programming=3;materials=4;syndicate=1"
	laws = new /datum/ai_laws/tyrant()

/******************** Antimov ********************/
/obj/item/aiModule/antimov // -- TLE
	name = "\improper Antimov Модуль ядра ИИ"
	desc = "An 'Antimov' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "red_high"
	origin_tech = "programming=4"
	laws = new /datum/ai_laws/antimov()

/******************** Pranksimov ********************/
/obj/item/aiModule/pranksimov
	name = "\improper Pranksimov Модуль ядра ИИ"
	desc = "A 'Pranksimov' Модуль ядра ИИ: 'Меняет основные законы ИИ.'"
	icon_state = "pranksimov"
	origin_tech = "programming=3;syndicate=2"
	laws = new /datum/ai_laws/pranksimov()

/******************** NT Aggressive ********************/
/obj/item/aiModule/nanotrasen_aggressive
	name = "\improper Модуль ядра ИИ 'НТ Агрессивный'"
	desc = "Модуль ядра ИИ 'НТ Агрессивный': 'Меняет основные законы ИИ.'"
	icon_state = "blue_high"
	laws = new /datum/ai_laws/nanotrasen_aggressive()

/******************** CCTV ********************/
/obj/item/aiModule/cctv
	name = "\improper Модуль ядра ИИ CCTV"
	desc = "Модуль ядра ИИ CCTV: 'Меняет основные законы ИИ.'"
	icon_state = "green_low"
	laws = new /datum/ai_laws/cctv()

/******************** Hippocratic Oath ********************/
/obj/item/aiModule/hippocratic
	name = "\improper Модуль ядра ИИ 'Клятва Гиппократа"
	desc = "Модуль ядра ИИ 'Клятва Гиппократа: 'Меняет основные законы ИИ.'"
	icon_state = "green_low"
	laws = new /datum/ai_laws/hippocratic()

/******************** Station Efficiency ********************/
/obj/item/aiModule/maintain
	name = "\improper Модуль ядра ИИ 'Эффективность станции'"
	desc = "Модуль ядра ИИ 'Эффективность станции': 'Меняет основные законы ИИ.'"
	icon_state = "blue_medium"
	laws = new /datum/ai_laws/maintain()

/******************** Peacekeeper ********************/
/obj/item/aiModule/peacekeeper
	name = "\improper Модуль ядра ИИ Миротворец"
	desc = "Модуль ядра ИИ 'Миротворец': 'Меняет основные законы ИИ.'"
	icon_state = "light_blue_medium"
	laws = new /datum/ai_laws/peacekeeper()

/******************** Freeform Core ******************/
/obj/item/aiModule/freeformcore // Slightly more dynamic freeform module -- TLE
	name = "\improper Freeform Модуль ядра ИИ"
	var/newFreeFormLaw = ""
	desc = "Модуль ядра ИИ 'freeform': '<freeform>'"
	icon_state = "standard_high"
	origin_tech = "programming=5;materials=4"

/obj/item/aiModule/freeformcore/attack_self(mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = stripped_input(usr, "Пожалуйста, введите новый основной закон для ИИ.", "Форма ввода закона", newlaw)
	newFreeFormLaw = targName
	desc = "'freeform' модуль ядра ИИ:  '[newFreeFormLaw]'"

/obj/item/aiModule/freeformcore/addAdditionalLaws(mob/living/silicon/ai/target, mob/sender)
	..()
	var/law = "[newFreeFormLaw]"
	target.add_inherent_law(law)
	GLOB.lawchanges.Add("Текущий закон: '[newFreeFormLaw]'")

/obj/item/aiModule/freeformcore/install(obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "Закона не обнаружено на модуле. Пожалуйста, создайте его.")
		return 0
	..()

/******************** Hacked AI Module ******************/
/obj/item/aiModule/syndicate // Slightly more dynamic freeform module -- TLE
	name = "Взломанный модуль ИИ"
	var/newFreeFormLaw = ""
	desc = "Взломанный модуль ИИ с законом: '<freeform>'"
	icon_state = "syndicate"
	origin_tech = "programming=5;materials=5;syndicate=2"

/obj/item/aiModule/syndicate/attack_self(mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = stripped_input(usr, "Введите новый закон для ИИ.", "Форма ввода закона", newlaw,MAX_MESSAGE_LEN)
	newFreeFormLaw = targName
	desc = "A hacked AI law module:  '[newFreeFormLaw]'"

/obj/item/aiModule/syndicate/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	//	..()    //We don't want this module reporting to the AI who dun it. --NEO
	log_law_changes(target, sender)

	GLOB.lawchanges.Add("Текущий закон '[newFreeFormLaw]'")
	to_chat(target, "<span class='warning'>БЗЗЗЗ-</span>")
	var/law = "[newFreeFormLaw]"
	target.add_ion_law(law)
	target.show_laws()

/obj/item/aiModule/syndicate/install(obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "Закон не обнаружен на модуле. Пожалуйста, создайте его.")
		return 0
	..()

/******************* Ion Module *******************/
/obj/item/aiModule/toyAI // -- Incoming //No actual reason to inherit from ion boards here, either. *sigh* ~Miauw
	name = "Игрушка ИИ"
	desc = "Маленькая игрушка в виде ИИ с настоящей загрузкой законов!" //Note: subtle tell
	icon = 'icons/obj/toy.dmi'
	icon_state = "AI"
	origin_tech = "programming=6;materials=5;syndicate=6"
	laws = list("")

/obj/item/aiModule/toyAI/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	//..()
	to_chat(target, "<span class='warning'>КЗЗЗЗЗТ</span>")
	target.add_ion_law(laws[1])
	return laws[1]

/obj/item/aiModule/toyAI/attack_self(mob/user)
	laws[1] = generate_ion_law()
	to_chat(user, "<span class='notice'>Вы нажимаете кнопку на [src].</span>")
	playsound(user, 'sound/machines/click.ogg', 20, 1)
	src.loc.visible_message("<span class='warning'>[bicon(src)] [laws[1]]</span>")
