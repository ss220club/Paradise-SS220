/mob/living/silicon/robot/examine(mob/user)
	. = ..()

	var/msg = "<span class='notice'>"
	if(module)
		msg += "У [ru_p_theirs()] загружен [module.declent_ru(NOMINATIVE)].\n"
	var/obj/act_module = get_active_hand()
	if(act_module)
		msg += "[ru_p_they(TRUE)] [ru_p_hold()] [bicon(act_module)] [act_module].\n"
	msg += "<span class='warning'>"
	if(getBruteLoss())
		if(getBruteLoss() < maxHealth*0.5)
			msg += "[ru_p_them(TRUE)] корпус немного повреждён.\n"
		else
			msg += "<b>[ru_p_them(TRUE)] корпус серьёзно повреждён!</b>\n"
	if(getFireLoss())
		if(getFireLoss() < maxHealth*0.5)
			msg += "[ru_p_them(TRUE)] проводка немного обгорела.\n"
		else
			msg += "<b>[ru_p_them(TRUE)] проводка сильно обгорела и деформировалась!</b>\n"
	if(health < -maxHealth*0.5)
		msg += "[ru_p_they(TRUE)] на грани отключения.\n"
	if(fire_stacks < 0)
		msg += "[ru_p_them(TRUE)] корпус выглядит промокшим.\n"
	else if(fire_stacks > 0)
		msg += "[ru_p_them(TRUE)] корпус покрыт чем-то горючим.\n"
	msg += "</span>"

	if(opened)
		msg += "[SPAN_WARNING("[ru_p_them(TRUE)] панель техобслуживания открыта. Внутри [cell ? "установлена" : "отсутствует"] батарея.")]\n"
	else
		msg += "[ru_p_them(TRUE)] панель техобслуживания закрыта[locked ? "" : ", однако доступ к ней был снят"].\n"

	if(cell && cell.charge <= 0)
		msg += "[SPAN_WARNING("[ru_p_them(TRUE)] индикатор батареи мигает красным!")]\n"

	switch(stat)
		if(CONSCIOUS)
			if(!client)
				msg += "Похоже что [ru_p_they()] в режиме ожидания.\n" //afk
		if(UNCONSCIOUS)
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] система переведена в спящий режим.")]\n"
		if(DEAD)
			if(!suiciding)
				msg += "[SPAN_DEADSAY("Похоже что [ru_p_them()] внутренние системы нуждаются в углубленном ремонте по замене компонентов.")]\n"
			else
				msg += "[SPAN_WARNING("Похоже что [ru_p_them()] система критически повреждена. Надежды на восстановление работоспособности нет.")]\n"
	msg += "</span>"

	if(print_flavor_text())
		msg += "\n[print_flavor_text()]\n"

	if(pose)
		if(findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0)
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[ru_p_they(TRUE)] [pose]"

	. += msg
	user.showLaws(src)
