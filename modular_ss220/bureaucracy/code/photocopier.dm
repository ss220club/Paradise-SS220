/obj/machinery/photocopier
	/// Selected form's category
	var/category = ""
	/// Selected form's id
	var/form_id = ""
	/// List of available forms
	var/list/forms
	/// Selected form's datum
	var/datum/bureaucratic_form/form
	/// Printing sound
	var/print_sound = 'sound/goonstation/machines/printer_dotmatrix.ogg'

/obj/machinery/photocopier/Initialize(mapload)
	. = ..()
	forms = new

/obj/machinery/photocopier/attack_ai(mob/user)
	src.add_hiddenprint(user)
	parse_forms(user)
	ui_interact(user)
	return attack_hand(user)

/obj/machinery/photocopier/attack_ghost(mob/user)
	ui_interact(user)
	return attack_hand(user)

/obj/machinery/photocopier/attack_hand(mob/user)
	if(..())
		return 1

	user.set_machine(src)
	parse_forms(user)
	ui_interact(user)

/obj/machinery/photocopier/ui_act(action, list/params)
	if(..())
		return
	. = FALSE
	switch(action)
		if("print_form")
			for(var/i in 1 to copies)
				if(toner <= 0)
					break
				print_form(form)
				use_power(active_power_consumption)
				sleep(15)
		if("choose_form")
			form = params["path"]
			form_id = params["id"]
		if("choose_category")
			category = params["category"]
		if("aipic")
			if(!istype(usr, /mob/living/silicon))
				return

			if(toner < 5)
				return

			var/mob/living/silicon/tempAI = usr
			var/obj/item/camera/siliconcam/camera = tempAI.aiCamera

			if(!camera)
				return
			var/datum/picture/selection = camera.selectpicture()
			if(!selection)
				return

			playsound(loc, print_sound, 50, 1)
			var/obj/item/photo/photo = new /obj/item/photo(loc)
			photo.construct(selection)
			photo.desc += "[photo.desc ? " - " : ""]Copied by [tempAI.name]"
			toner -= 5
		else
			return FALSE
	add_fingerprint(usr)

/obj/machinery/photocopier/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Photocopier220", name, 650, 635, master_ui, state)
		ui.open()

/obj/machinery/photocopier/ui_data(mob/user)
	if(!length(forms))
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
	var/list/access = user.get_access()
	forms = new/list()
	for(var/datum/bureaucratic_form/F as anything in subtypesof(/datum/bureaucratic_form))
		var/req_access = initial(F.req_access)
		if(req_access && !(req_access in access))
			continue
		var/form[0]
		form["path"] = F
		form["id"] = initial(F.id)
		form["altername"] = initial(F.altername)
		form["category"] = initial(F.category)
		forms[++forms.len] = form

/obj/machinery/photocopier/proc/print_form(datum/bureaucratic_form/form)
	playsound(loc, print_sound, 25, 1)
	toner--
	if(!toner)
		visible_message("<span class='notice'>На [src] мигает красная лампочка. Похоже закончился тонер.</span>")
	var/obj/item/paper/paper = new(loc)
	var/datum/bureaucratic_form/ink = new form
	ink.apply_to_paper(paper)
	qdel(ink)
