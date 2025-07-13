#define GEOTHERMAL_GEN_OUTPUT 300

#define GEOTHERMAL_GEN_BROKEN 1
#define GEOTHERMAL_GEN_CABLES 2
#define GEOTHERMAL_GEN_WRENCH 3
#define GEOTHERMAL_GEN_SCREWDRIVER 4
#define GEOTHERMAL_GEN_ACTIVE 5

/obj/machinery/power/geothermal_generator
	name = "Геотермальный генератор"
	desc = "Стационарный электрогенератор, пассивно вырабатывающий небольшой объём электроэнергии благодаря подземным источникам тепла. Время от времени нуждается в ремонте."
	icon = 'modular_ss220/lazarus/icons/geothermal.dmi'
	icon_state = "geoterm_broken"
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/gen_state = GEOTHERMAL_GEN_BROKEN
	var/break_timer = null

/obj/machinery/power/geothermal_generator/examine(mob/user)
	. = ..()
	switch(gen_state)
		if(GEOTHERMAL_GEN_BROKEN)
			. += "<span class='notice'>Генератор сломан. Крышка прикрыта и из под неё валит пар. Используйте <b>отвёртку</b> для ремонта.</span>"
		if(GEOTHERMAL_GEN_CABLES)
			. += "<span class='notice'>Генератор сломан. Крышка открыта и из под неё висят повреждённые провода. Используйте <b>кусачки</b> для продолжения ремонта.</span>"
		if(GEOTHERMAL_GEN_WRENCH)
			. += "<span class='notice'>Генератор сломан. Крышка открыта и из под неё валит пар. Используйте <b>гаечный ключ</b> для продолжения ремонта.</span>"
		if(GEOTHERMAL_GEN_SCREWDRIVER)
			. += "<span class='notice'>Генератор сломан. Крышка открыта и всё под ней приведено в порядок. Используйте <b>отвёртку</b> для продолжения ремонта.</span>"
		if(GEOTHERMAL_GEN_ACTIVE)
			. += "<span class='notice'>Генератор работает, вырабатывая [GEOTHERMAL_GEN_OUTPUT]W.</span>"
			. += "<span class='warning'>Генератор можно саботировать при помощи монтировки на HARM.</span>"

/obj/machinery/power/geothermal_generator/update_icon_state()
	. = ..()
	switch(gen_state)
		if(GEOTHERMAL_GEN_BROKEN)
			icon_state = "geoterm_broken"
		if(GEOTHERMAL_GEN_CABLES)
			icon_state = "geoterm_1"
		if(GEOTHERMAL_GEN_WRENCH)
			icon_state = "geoterm_2"
		if(GEOTHERMAL_GEN_SCREWDRIVER)
			icon_state = "geoterm_3"
		if(GEOTHERMAL_GEN_ACTIVE)
			icon_state = "geoterm_active"


/obj/machinery/power/geothermal_generator/process()
	if(powernet)
		if(gen_state == GEOTHERMAL_GEN_ACTIVE)
			produce_direct_power(GEOTHERMAL_GEN_OUTPUT)
	else
		break_gen()
	return

/obj/machinery/power/geothermal_generator/screwdriver_act(mob/living/user, obj/item/I)
	if(user.a_intent == INTENT_HELP)
		. = TRUE
		if(!I.tool_use_check(user, 0))
			return
		if(gen_state == GEOTHERMAL_GEN_BROKEN)
			user.visible_message("<span class='notice'>[user] начал открывать крышку сломанного генератора...</span>", "<span class='notice'>Вы начали открывать крышку сломанного генератора</span>")
			if(!I.use_tool(src, user, 8 SECONDS, volume = I.tool_volume))
				return
			user.visible_message("<span class='notice'>[user] открыл крышку сломанного генератора.</span>", "<span class='notice'>Вы открыли крышку сломанного генератора.</span>")
			gen_state = GEOTHERMAL_GEN_CABLES
			update_icon(UPDATE_ICON_STATE)
		else if(gen_state == GEOTHERMAL_GEN_SCREWDRIVER)
			user.visible_message("<span class='notice'>[user] начал закрывать крышку генератора...</span>", "<span class='notice'>Вы начали закрывать крышку генератора</span>")
			if(!I.use_tool(src, user, 8 SECONDS, volume = I.tool_volume))
				return
			user.visible_message("<span class='notice'>[user] закрыл крышку генератора.</span>", "<span class='notice'>Вы закрыли крышку генератора.</span>")
			gen_state = GEOTHERMAL_GEN_ACTIVE
			update_icon(UPDATE_ICON_STATE)
			break_timer = addtimer(CALLBACK(src, PROC_REF(break_gen)), rand(40 MINUTES, 60 MINUTES), TIMER_STOPPABLE)

/obj/machinery/power/geothermal_generator/wrench_act(mob/living/user, obj/item/I)
	if(user.a_intent == INTENT_HELP)
		. = TRUE
		if(!I.tool_use_check(user, 0))
			return
		if(gen_state == GEOTHERMAL_GEN_WRENCH)
			user.visible_message("<span class='notice'>[user] начал закручивать чрезмерную подачу пара.</span>", "<span class='notice'>Вы начали закручивать чрезмерную подачу пара.</span>")
			if(!I.use_tool(src, user, 8 SECONDS, volume = I.tool_volume))
				return
			user.visible_message("<span class='notice'>[user] уменьшил подачу пара до оптимального уровня.</span>", "<span class='notice'>Вы уменьшили подачу пара до оптимального уровня.</span>")
			gen_state = GEOTHERMAL_GEN_SCREWDRIVER
			update_icon(UPDATE_ICON_STATE)

/obj/machinery/power/geothermal_generator/wirecutter_act(mob/living/user, obj/item/I)
	if(user.a_intent == INTENT_HELP)
		. = TRUE
		if(!I.tool_use_check(user, 0))
			return
		if(gen_state == GEOTHERMAL_GEN_CABLES)
			user.visible_message("<span class='notice'>[user] начал заменять повреждённую проводку.</span>", "<span class='notice'>Вы начали заменять повреждённую проводку.</span>")
			if(!I.use_tool(src, user, 8 SECONDS, volume = I.tool_volume))
				return
			user.visible_message("<span class='notice'>[user] заменил повреждённую проводку.</span>", "<span class='notice'>Вы заменили повреждённую проводку.</span>")
			gen_state = GEOTHERMAL_GEN_WRENCH
			update_icon(UPDATE_ICON_STATE)

/obj/machinery/power/geothermal_generator/crowbar_act(mob/living/user, obj/item/I)
	if(user.a_intent == INTENT_HARM)
		. = TRUE
		if(!I.tool_use_check(user, 0))
			return
		if(gen_state == GEOTHERMAL_GEN_ACTIVE)
			user.visible_message("<span class='warning'>[user] повреждает панели генератора монтировкой!</span>", "<span class='notice'>Вы начали саботаж геотермального генератора.</span>")
			if(!I.use_tool(src, user, 8 SECONDS, volume = I.tool_volume))
				return
			user.visible_message("<span class='notice'>[user] вывел генератор из строя!</span>", "<span class='notice'>Вы успешно повредили генератор.</span>")
			break_gen()

/obj/machinery/power/geothermal_generator/proc/break_gen()
	gen_state = GEOTHERMAL_GEN_BROKEN
	update_icon(UPDATE_ICON_STATE)
	if(break_timer)
		deltimer(break_timer)
		break_timer = null

#undef GEOTHERMAL_GEN_OUTPUT

#undef GEOTHERMAL_GEN_BROKEN
#undef GEOTHERMAL_GEN_CABLES
#undef GEOTHERMAL_GEN_WRENCH
#undef GEOTHERMAL_GEN_SCREWDRIVER
#undef GEOTHERMAL_GEN_ACTIVE
