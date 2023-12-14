/mob/living/silicon/ai/examine(mob/user)
	. = ..()
	var/msg = "<span class='info'>"
	if(src.stat == DEAD)
		msg += "<span class='deadsay'>Оно выглядит отключённым.</span>\n"
	else
		msg += "<span class='warning'>"
		if(src.getBruteLoss())
			if(src.getBruteLoss() < 30)
				msg += "Оно выглядит слегка помятым.\n"
			else
				msg += "<B>Оно выглядит очень помятым!</B>\n"
		if(src.getFireLoss())
			if(src.getFireLoss() < 30)
				msg += "Оно выглядит слегка поджаренным.\n"
			else
				msg += "<B>Его оболочка расплавлена и искажена от тепла!</B>\n"
		if(src.stat == UNCONSCIOUS)
			msg += "Оно не отвечает и высвечивает текст: \"RUNTIME: Перегрузка сенсоров, стэк 26/3\".\n"
		if(!shunted && !client)
			msg += "[src]Core.exe перестал отвечать! NTOS ищет решение проблемы...\n"
		msg += "</span>"
	msg += "</span>"

	. += msg
	user.showLaws(src)


/mob/proc/showLaws(mob/living/silicon/S)
	return

/mob/dead/observer/showLaws(mob/living/silicon/S)
	if(antagHUD || check_rights(R_ADMIN, 0, src))
		S.laws.show_laws(src)
