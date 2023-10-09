/atom/movable/Moved(atom/OldLoc, Dir, Forced = FALSE)
	for(var/atom/movable/atom in contents)
		SEND_SIGNAL(atom, COMSIG_MOVABLE_HOLDER_MOVED, OldLoc, Dir, Forced)
	. = ..()

/obj/item/bodycam
	name = "bodyсam"
	desc = "Специализированная портативная камера, способная передавать потоковое видео в реальном времени."
	icon = 'modular_ss220/aesthetics/cameras/icons/cameras.dmi'
	icon_state = "gopro_camera"
	slot_flags = SLOT_EARS

	var/obj/machinery/camera/camera = null

/obj/item/bodycam/examine(mob/user)
	. = ..()
	. += span_info("Камера [camera.status ? "в" : "вы"]ключена.")

/obj/item/bodycam/Initialize(mapload)
	. = ..()
	camera = new(src)
	camera.c_tag = "Bodycam"
	camera.network = list("SS13")
	toggle()
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(was_pickedup))
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(was_pickedup))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(was_dropped))

/obj/item/bodycam/Destroy()
	. = ..()
	QDEL_NULL(camera)

/obj/item/bodycam/emp_act(severity)
	. = ..()
	camera.emp_act(severity)

/obj/item/bodycam/attack_self(mob/user)
	. = ..()
	toggle(user)

/obj/item/bodycam/AltClick()
	. = ..()
	change_name()

/obj/item/bodycam/proc/toggle(mob/user)
	camera.status = !camera.status
	if(camera.status)
		GLOB.cameranet.cameras += camera
		GLOB.cameranet.addCamera(camera)
		if(user)
			to_chat(user, span_notice("Вы включаете камеру."))
	else
		GLOB.cameranet.cameras -= camera
		GLOB.cameranet.removeCamera(camera)
		if(user)
			to_chat(user, span_notice("Вы выключаете камеру."))

/obj/item/bodycam/verb/change_name()
	set category = "Objects"
	set name = "Change Camera Name"
	set src in view(1, usr)

	if(!usr.incapacitated())
		var/new_name = input(usr, "Введите новое название камеры") as text|null
		if(!new_name)
			return
		new_name = sanitize(new_name)
		if(length(new_name) > 24)
			to_chat(usr, span_warning("Название слишком длинное!"))
			return
		if(findtext(new_name, "Bodycam ") != 1)
			new_name = addtext("Bodycam ", new_name)
		camera.c_tag = new_name

/obj/item/bodycam/on_enter_storage(obj/item/storage/S)
	. = ..()
	if(camera.status)
		toggle()

/obj/item/bodycam/on_exit_storage(obj/item/storage/S)
	. = ..()
	if(!ismob(S.loc))
		return
	var/mob/user = S.loc
	was_pickedup(src, user)

/obj/item/bodycam/proc/was_pickedup(datum/source, mob/user)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(update_position), TRUE)
	RegisterSignal(user, COMSIG_MOVABLE_HOLDER_MOVED, PROC_REF(update_position), TRUE)

/obj/item/bodycam/proc/was_dropped(datum/source, mob/user)
	UnregisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_HOLDER_MOVED))

/obj/item/bodycam/proc/update_position(datum/source, turf/oldLoc)
	if(!camera || !camera.status)
		return
	if(oldLoc == get_turf(loc))
		return
	GLOB.cameranet.updatePortableCamera(camera)
