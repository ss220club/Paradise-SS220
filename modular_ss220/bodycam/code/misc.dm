/obj/machinery/camera
	var/list/computers_watched_by = list()

/obj/machinery/computer/security/ui_act(action, params)
	if(..())
		return
	if(action == "switch_camera")
		var/c_tag = params["name"]
		var/list/cameras = get_available_cameras()
		var/obj/machinery/camera/C = cameras[c_tag]
		active_camera?.computers_watched_by -= src
		active_camera = C
		active_camera.computers_watched_by += src
		playsound(src, get_sfx("terminal_type"), 25, FALSE)

		// Show static if can't use the camera
		if(!active_camera?.can_use())
			show_camera_static()
			return TRUE

		update_camera_view()
		return TRUE

/obj/machinery/computer/security/proc/update_camera_view()
	if(!active_camera)
		return
	var/list/visible_turfs = list()
	for(var/turf/T in view(active_camera.view_range, get_turf(active_camera)))
		visible_turfs += T

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, size_x, size_y)

/obj/machinery/camera/proc/update_computers_watched_by()
	for(var/obj/machinery/computer/security/computer as anything in computers_watched_by)
		computer.update_camera_view()

/obj/machinery/computer/security/Destroy()
	active_camera = null
	. = ..()

/obj/machinery/economy/vending/security/Initialize(mapload)
	products += list(
		/obj/item/body_camera = 10)
	. = ..()
