/obj/item/card/id/syndicate
	dna_hash = null
	blood_type = null
	fingerprint_hash = null
	var/mob/living/carbon/human/registered_human
	var/static/list/appearances
	var/static/list/departments = list(
				"Assistant" = null,
				"Engineering" = GLOB.engineering_positions,
				"Medical" = GLOB.medical_positions,
				"Science" = GLOB.science_positions,
				"Security" = GLOB.security_positions,
				"Support" = GLOB.service_positions,
				"Command" = GLOB.command_positions,
				"Special" = (get_all_solgov_jobs() + get_all_soviet_jobs() + get_all_centcom_jobs()),
				"Custom" = null,
			)

/obj/item/card/id/syndicate/New()
	. = ..()
	var/static/list/final_appearances = list()

	if(length(final_appearances) == 0)
		var/static/list/restricted_skins = list("admin", "deathsquad", "clownsquad", "data", "ERT_empty", "silver", "gold", "TDred", "TDgreen")
		var/static/list/raw_appearances = GLOB.card_skins_ss220 + GLOB.card_skins_special_ss220 + GLOB.card_skins_donor_ss220 - restricted_skins
		for(var/skin in raw_appearances)
			final_appearances[skin] = "[icon2base64(icon(initial(icon), skin, SOUTH, 1))]"

	appearances = final_appearances

/obj/item/card/id/syndicate/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	if(!registered_human)
		return
	. = TRUE
	switch(action)
		if("delete_info")
			delete_info()
		if("clear_access")
			clear_access()
		if("change_ai_tracking")
			change_ai_tracking()
		if("change_name")
			change_name()
		if("change_photo")
			change_photo()
		if("change_appearance")
			change_appearance(params)
		if("change_sex")
			change_sex()
		if("change_age")
			change_age()
		if("change_occupation")
			change_occupation()
		if("change_money_account")
			change_money_account()
		if("change_blood_type")
			change_blood_type()
		if("change_dna_hash")
			change_dna_hash()
		if("change_fingerprints")
			change_fingerprints()
	RebuildHTML()

/obj/item/card/id/syndicate/ui_data(mob/user)
	var/list/data = list()
	data["registered_name"] = registered_name
	data["sex"] = sex
	data["age"] = age
	data["assignment"] = assignment
	data["associated_account_number"] = associated_account_number
	data["blood_type"] = blood_type
	data["dna_hash"] = dna_hash
	data["fingerprint_hash"] = fingerprint_hash
	data["photo"] = photo
	data["ai_tracking"] = untrackable
	return data

/obj/item/card/id/syndicate/ui_static_data(mob/user)
	var/list/data = list()
	data["appearances"] = appearances
	return data

/obj/item/card/id/syndicate/ui_state(mob/user)
	return GLOB.default_state

/obj/item/card/id/syndicate/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AgentCard", name)
		ui.open()

/obj/item/card/id/syndicate/attack_self(mob/user)
	if(!ishuman(user))
		return
	if(!registered_human)
		registered_human = user
	if(registered_human != user)
		return flash_card(user)
	switch(tgui_alert("Вы хотите показать [src] или изменить?", "Выбор", "Показать", "Изменить"))
		if("Показать")
			return flash_card(user)
		if("Изменить")
			ui_interact(user)
			return

/obj/item/card/id/proc/flash_card(mob/user)
	user.visible_message(
		span_notice("[user] показывает тебе: [bicon(src)] [src.name]. Должность на карте: [src.assignment]."),
		span_notice("Ты показываешь свою ID карту: [bicon(src)] [src.name]. Должность на карте: [src.assignment]."))
	if(mining_points)
		to_chat(user, "На ней <b>[mining_points] шахтёрских очков</b>. Всего было получено за смену <b>[total_mining_points] шахтёрских очков</b>!")
	src.add_fingerprint(user)

/obj/item/card/id/syndicate/proc/delete_info()
	name = null
	registered_name = null
	icon_state = null
	sex = null
	age = null
	assignment = null
	associated_account_number = null
	blood_type = null
	dna_hash = null
	fingerprint_hash = null
	photo = null
	registered_user = null
	SStgui.close_uis(src)
	to_chat(registered_human, span_notice("Вся информация с [src] была удалена."))

/obj/item/card/id/syndicate/proc/clear_access()
	access = initial_access.Copy()
	to_chat(registered_human, span_notice("Выполнен сброс доступов."))

/obj/item/card/id/syndicate/proc/change_ai_tracking()
	untrackable = !untrackable
	to_chat(registered_human, span_notice("Эта ID карта[untrackable ? " не" : ""] может быть отслежена ИИ."))

/obj/item/card/id/syndicate/proc/change_name()
	var/new_name = reject_bad_name(tgui_input_text(registered_human, "Какое имя будет на карте?", "Карта Агента - Имя", ishuman(registered_human) ? registered_human.real_name : registered_human.name), TRUE)
	if(!Adjacent(registered_human))
		return

	registered_name = new_name
	UpdateName()
	to_chat(registered_human, span_notice("Имя изменено на: [new_name]."))

/obj/item/card/id/syndicate/proc/change_photo()
	if(!Adjacent(registered_human))
		return

	var/job_clothes = null
	if(assignment)
		job_clothes = assignment

	var/icon/newphoto = get_id_photo(registered_human, job_clothes)
	if(!newphoto)
		return

	photo = newphoto
	to_chat(registered_human, span_notice("Фото изменено. Если хотите другую одежду, то выберите другую должность и измените снова."))

/obj/item/card/id/syndicate/proc/change_appearance(list/params)
	var/choice = params["new_appearance"]
	icon_state = choice
	to_chat(usr, span_notice("Внешний вид изменён на: [choice]."))

/obj/item/card/id/syndicate/proc/change_sex()
	var/new_sex = sanitize(stripped_input(registered_human,"Какой пол будет на карте?","Карта Агента - Пол", ishuman(registered_human) ? capitalize(registered_human.gender) : "Male", MAX_MESSAGE_LEN))
	if(!Adjacent(registered_human))
		return

	sex = new_sex
	to_chat(registered_human, span_notice("Пол изменён на: [new_sex]."))

/obj/item/card/id/syndicate/proc/change_age()
	var/default = "21"
	if(ishuman(registered_human))
		default = registered_human.age

	var/new_age = tgui_input_number(registered_human, "Какой возраст будет на карте?", "Карта Агента - Возраст", default, 300, 17)
	if(!Adjacent(registered_human))
		return

	age = new_age
	to_chat(registered_human, span_notice("Возраст изменён на: [new_age]."))

/obj/item/card/id/syndicate/proc/change_occupation()
	var/title = "Карта Агента - Должность"
	var/department_icon_text = "Какая должность будет показываться с этой картой на ХУДах?"
	var/department_selection_text = "Какую должность вы хотите присвоить этой карте? Выберите департамент, или можете вписать собственную должность."
	var/selected_department = tgui_input_list(registered_human, department_selection_text, title, departments)
	if(isnull(selected_department))
		return

	var/new_rank
	var/new_job
	if(selected_department == "Assistant")
		new_job = selected_department
		new_rank = selected_department

	else if(selected_department == "Custom")
		new_job = sanitize(tgui_input_text(registered_human, "Введите название своей должности:", title, "Assistant", MAX_MESSAGE_LEN))
		var/department_icon = tgui_input_list(registered_human, department_icon_text, title, departments - list("Assistant", "Custom"))
		if(isnull(department_icon))
			to_chat(registered_human, span_warning("Вы должны выбрать департамент!"))
			return
		new_rank = tgui_input_list(registered_human, department_icon_text, title, departments[department_icon])

	else
		new_job = tgui_input_list(registered_human, "Какую должность вы хотите?", title, departments[selected_department])
		if(isnull(new_job))
			new_job = "Assistant"
		new_rank = new_job

	if(!Adjacent(registered_human))
		return

	assignment = new_job
	rank = new_rank
	UpdateName()
	registered_human.sec_hud_set_ID()
	to_chat(registered_human, span_notice("Должность сменена на [new_job]."))

/obj/item/card/id/syndicate/proc/change_money_account()
	var/new_account = tgui_input_number(registered_human, "Какой банковский счёт будет привязан к карте?", "Карта Агента - Банковский счёт", 12345, max_value = 9999999)
	if(!Adjacent(registered_human))
		return
	associated_account_number = new_account
	to_chat(registered_human, span_notice("Привязанный счёт изменён на: [new_account]."))

/obj/item/card/id/syndicate/proc/change_blood_type()
	var/default
	if(ishuman(registered_human) && registered_human.dna)
		default = registered_human.dna.blood_type

	var/new_blood_type = sanitize(tgui_input_text(registered_human,"Какой тип крови будет написан на карте?", "Карта Агента - Тип крови", default))
	if(!Adjacent(registered_human))
		return

	blood_type = new_blood_type
	to_chat(registered_human, span_notice("Тип крови изменён на: [new_blood_type]."))

/obj/item/card/id/syndicate/proc/change_dna_hash()
	var/default
	if(ishuman(registered_human) && registered_human.dna)
		default = registered_human.dna.unique_enzymes

	var/new_dna_hash = sanitize(tgui_input_text(registered_human,"Какой ДНК будет написан на карте?", "Карта Агента - ДНК", default))
	if(!Adjacent(registered_human))
		return

	dna_hash = new_dna_hash
	to_chat(registered_human, span_notice("ДНК изменён на: [new_dna_hash]."))

/obj/item/card/id/syndicate/proc/change_fingerprints()
	var/default
	if(ishuman(registered_human) && registered_human.dna)
		default = md5(registered_human.dna.uni_identity)

	var/new_fingerprint_hash = sanitize(tgui_input_text(registered_human, "Какие отпечатки будут написаны на карте?", "Карта Агента - Отпечатки", default))
	if(!Adjacent(registered_human))
		return

	fingerprint_hash = new_fingerprint_hash
	to_chat(registered_human, span_notice("Отпечатки изменёны: [new_fingerprint_hash]."))
