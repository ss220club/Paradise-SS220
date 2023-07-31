#define MODE_COPY 	"mode_copy"
#define MODE_PRINT 	"mode_print"
#define MODE_AIPIC 	"mode_aipic"

/obj/machinery/photocopier
	var/mode = MODE_COPY
	var/category = "" // selected form's category
	var/form_id = "" // selected form's id
	var/list/forms = new/list() // forms list
	var/obj/item/paper/form/form = null // selected form for print

/obj/machinery/photocopier/proc/parse_forms(mob/user)
	var/list/access = user.get_access()
	forms = new/list()
	for(var/F in subtypesof(/obj/item/paper/form))
		var/obj/item/paper/form/ff = F
		var/req_access = initial(ff.access)
		if(req_access && !(req_access in access))
			continue
		var/form[0]
		form["path"] = F
		form["id"] = initial(ff.id)
		form["altername"] = initial(ff.altername)
		form["category"] = initial(ff.category)
		forms[++forms.len] = form

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

/obj/machinery/photocopier/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "Photocopier220", name, 402, 368, master_ui, state)
		ui.open()

/obj/machinery/photocopier/ui_act(action, list/params)
	if(..())
		return
	. = FALSE
	add_fingerprint(usr)
	switch(action)
		if("copy")
			copy(copyitem)
		if("removedocument")
			remove_document()
			. = TRUE
		if("removefolder")
			remove_folder()
			. = TRUE
		if("add")
			if(copies < maxcopies)
				copies++
				. = TRUE
		if("minus")
			if(copies > 0)
				copies--
				. = TRUE
		if("scandocument")
			scan_document()
		if("filecopy")
			file_copy(params["uid"])
		if("deletefile")
			delete_file(params["uid"])
			. = TRUE
	update_icon()
