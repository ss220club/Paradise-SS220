/obj/machinery/camera
	var/nanomap_png

/obj/machinery/camera/Initialize(mapload, should_add_to_cameranet)
	. = ..()
	if(z == level_name_to_num(MAIN_STATION))
		nanomap_png = "[SSmapping.map_datum.technical_name]_nanomap_z1.png"
	else if (z == level_name_to_num(MINING))
		nanomap_png = "[MINING]_nanomap_z1.png"

/obj/machinery/computer/security
	var/list/stored_cameras // Assoc list, ("z_level" = "c_tag")
	var/list/z_levels = list() // Assoc list, ("z_level" = "nanomap.png")
	var/current_z_level_index

/obj/machinery/computer/security/get_available_cameras()
	. = ..()
	z_levels = list()
	for(var/obj/machinery/camera/camera in .)
		if(camera.z in z_levels)
			continue
		z_levels["[camera.z]"] = camera.nanomap_png

/obj/machinery/computer/security/ui_interact(mob/user, datum/tgui/ui = null)
	// Update UI
	ui = SStgui.try_update_ui(user, src, ui)
	// Show static if can't use the camera
	if(!active_camera?.can_use())
		show_camera_static()
	if(!ui)
		var/user_uid = user.UID()
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			watchers += user_uid
		// Turn on the console
		if(length(watchers) == 1 && is_living)
			if(!silent_console)
				playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
			use_power(active_power_consumption)
		// Register map objects
		user.client.register_map_obj(cam_screen)
		for(var/plane in cam_plane_masters)
			var/atom/movable/screen/plane_master/instance = new plane()
			instance.assigned_map = map_name
			instance.del_on_map_removal = FALSE
			instance.screen_loc = "[map_name]:CENTER"
			instance.backdrop(user)

			user.client.register_map_obj(instance)
		user.client.register_map_obj(cam_background)
		// Open UI
		ui = new(user, src, "CameraConsole220", name)
		ui.open()

/obj/machinery/computer/security/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/nanomaps)
	)

/obj/machinery/computer/security/ui_data()
	var/list/data = list()
	data["network"] = network
	data["activeCamera"] = null
	if(active_camera)
		data["activeCamera"] = list(
			name = active_camera.c_tag,
			status = active_camera.status,
			z = active_camera.z,
		)
	var/list/cameras = get_available_cameras()
	data["cameras"] = list()
	for(var/i in cameras)
		var/obj/machinery/camera/C = cameras[i]
		data["cameras"] += list(list(
			name = C.c_tag,
			x = C.x,
			y = C.y,
			z = C.z,
			status = C.status
		))
	data["mapUrl"] = z_levels(current_z_level_index) || null
	return data

/obj/machinery/computer/security/ui_static_data()
	var/list/data = list()
	data["mapRef"] = map_name
	data["stationLevel"] = level_name_to_num(MAIN_STATION)
	return data

/obj/machinery/computer/security/ui_act(action, params)
	. = ..()
	if(. && action == "change_camera")
		if(active_camera)
			current_z_level_index = z_levels.Find("[active_camera.z]")
		return
	if(.)
		return

	if(action == "switch_z_level")
		if(active_camera)
			LAZYSET(stored_cameras, "[active_camera.z]", active_camera.c_tag)
		var/z_dir = params["z_dir"]
		// TODO: Have a list of available z_levels
		var/list/cameras = get_available_cameras()
		switch(z_dir)
			if(1)
				if(length(z_levels) >= current_z_level_index + 1)
					return
				current_z_level_index += 1
				active_camera = cameras[LAZYACCESSASSOC(stored_cameras, level_name_to_num(MAIN_STATION), null)] || null
			if(-1)
				if(current_z_level_index <= 1)
					return
				current_z_level_index -= 1
				active_camera = cameras[LAZYACCESSASSOC(stored_cameras, level_name_to_num(MINING), null)] || null

		// Below is a copy-paste from "switch-camera". Need to refactor it a little
		if(!silent_console)
			playsound(src, get_sfx("terminal_type"), 25, FALSE)

		// Show static if can't use the camera
		if(!active_camera?.can_use())
			show_camera_static()
			return TRUE

		var/list/visible_turfs = list()
		for(var/turf/T in view(active_camera.view_range, get_turf(active_camera)))
			visible_turfs += T

		var/list/bbox = get_bbox_of_atoms(visible_turfs)
		var/size_x = bbox[3] - bbox[1] + 1
		var/size_y = bbox[4] - bbox[2] + 1

		cam_screen.vis_contents = visible_turfs
		cam_background.icon_state = "clear"
		cam_background.fill_rect(1, 1, size_x, size_y)

		return TRUE
