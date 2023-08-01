/obj/machinery/photocopier
	var/category = "" // selected form's category
	var/form_id = "" // selected form's id
	var/list/forms = new/list() // forms list
	var/obj/item/paper/form/form = null // selected form for print

/obj/machinery/photocopier/attack_ai(mob/user)
	src.add_hiddenprint(user)
	parse_forms(user)
	ui_interact(user)
	return attack_hand(user)

/obj/machinery/photocopier/attack_ghost(mob/user)
	ui_interact(user)
	return attack_hand(user)

/obj/machinery/photocopier/attack_hand(mob/user)
	if(..(user))
		return 1

	user.set_machine(src)
	parse_forms(user)
	ui_interact(user)

/obj/machinery/photocopier/ui_act(action, list/params)
	if(..())
		return
	. = FALSE
	add_fingerprint(usr)
	switch(action)
		if("print_form")
			for(var/i = 0, i < copies, i++)
				if(toner <= 0)
					break
				playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 25, 1)
				print_form(form)
				sleep(15)
				use_power(active_power_consumption)
		if("choose_form")
			form = params["path"]
			form_id = params["id"]
		if("choose_category")
			category = params["category"]
		if("aipic")
			if(!istype(usr,/mob/living/silicon))
				return

			if(toner >= 5)
				var/mob/living/silicon/tempAI = usr
				var/obj/item/camera/siliconcam/camera = tempAI.aiCamera

				if(!camera)
					return
				var/datum/picture/selection = camera.selectpicture()
				if(!selection)
					return

				playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)
				var/obj/item/photo/p = new /obj/item/photo (src.loc)
				p.construct(selection)
				if(p.desc == "")
					p.desc += "Copied by [tempAI.name]"
				else
					p.desc += " - Copied by [tempAI.name]"
				toner -= 5
				sleep(15)
		else
			return FALSE
	add_fingerprint(usr)

/obj/machinery/photocopier/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Photocopier220", name, 650, 635, master_ui, state)
		ui.open()

/obj/machinery/photocopier/ui_data(mob/user)
	if(forms.len == 0)
		parse_forms(user)

	var/list/data = list()

	data["isAI"] = issilicon(user)
	data["copynumber"] = copies
	data["toner"] = toner
	data["copyitem"] = (copyitem ? copyitem.name : null)
	data["folder"] = (folder ? folder.name : null)
	data["mob"] = (copymob ? copymob.name : null)
	data["files"] = list()
	data["form"] = form
	data["category"] = category
	data["form_id"] = form_id
	data["forms"] = forms

	if(LAZYLEN(saved_documents))
		for(var/obj/item/O in saved_documents)
			var/list/document_data = list(
				name = O.name,
				uid = O.UID()
			)
			data["files"] += list(document_data)
	return data

/obj/machinery/photocopier/proc/parse_forms(mob/user)
	forms = new/list()
	for(var/F in subtypesof(/obj/item/paper/form))
		var/obj/item/paper/form/ff = F
		var/form[0]
		form["path"] = F
		form["id"] = initial(ff.id)
		form["altername"] = initial(ff.altername)
		form["category"] = initial(ff.category)
		forms[++forms.len] = form

/obj/machinery/photocopier/proc/print_form(var/obj/item/paper/form/form)
	var/obj/item/paper/form/paper = new form (loc)
	toner--
	if(toner == 0)
		visible_message("<span class='notice'>Красная лампочка на [src]е мигает, походу закончился тонер.</span>")
	return paper
