/obj/machinery/computer/camera_advanced
	name = "advanced camera console"
	desc = "Used to access the various cameras on the station."
	icon_screen = "cameras"
	icon_keyboard = "security_key"
	var/mob/camera/ai_eye/remote/eyeobj
	var/mob/living/carbon/human/current_user = null
	var/list/networks = list("SS13")
	var/datum/action/innate/camera_off/off_action = new
	var/datum/action/innate/camera_jump/jump_action = new
	var/list/actions = list()

/obj/machinery/computer/camera_advanced/proc/CreateEye()
	eyeobj = new()
	eyeobj.origin = src

/obj/machinery/computer/camera_advanced/proc/GrantActions(mob/living/user)
	if(off_action)
		off_action.target = user
		off_action.Grant(user)
		actions += off_action

	if(jump_action)
		jump_action.target = user
		jump_action.Grant(user)
		actions += jump_action

/obj/machinery/computer/camera_advanced/proc/remove_eye_control(mob/living/user)
	if(!user)
		return
	for(var/V in actions)
		var/datum/action/A = V
		A.Remove(user)
	actions.Cut()
	if(user.client)
		user.reset_perspective(null)
		eyeobj.RemoveImages()
	eyeobj.eye_user = null
	user.remote_control = null

	current_user = null
	remove_eye(user)
	playsound(src, 'sound/machines/terminal_off.ogg', 25, 0)

/obj/machinery/computer/camera_advanced/process()
	if(!current_user)
		return

	if((stat & (NOPOWER|BROKEN)) || (!Adjacent(current_user) && !current_user.has_unlimited_silicon_privilege) || !current_user.has_vision() || current_user.incapacitated())
		remove_eye(current_user)

/obj/machinery/computer/camera_advanced/Destroy()
	if(current_user)
		remove_eye(current_user)
	QDEL_NULL(eyeobj)
	QDEL_LIST_CONTENTS(actions)
	return ..()

/obj/machinery/computer/camera_advanced/proc/remove_eye(mob/M)
	if(M == current_user)
		remove_eye_control(M)

/obj/machinery/computer/camera_advanced/attack_hand(mob/user)
	if(current_user)
		to_chat(user, "The console is already in use!")
		return
	if(!iscarbon(user))
		return
	if(..())
		return

	if(!eyeobj)
		CreateEye()

	if(!eyeobj.eye_initialized)
		var/camera_location
		for(var/obj/machinery/camera/C in GLOB.cameranet.cameras)
			if(!C.can_use())
				continue
			if(length(C.network & networks))
				camera_location = get_turf(C)
				break
		if(camera_location)
			eyeobj.eye_initialized = 1
			give_eye_control(user)
			eyeobj.setLoc(camera_location)
		else
			// An abberant case - silent failure is obnoxious
			to_chat(user, "<span class='warning'>ERROR: No linked and active camera network found.</span>")
			remove_eye(user)
	else
		give_eye_control(user)
		eyeobj.setLoc(eyeobj.loc)


/obj/machinery/computer/camera_advanced/proc/give_eye_control(mob/user)
	GrantActions(user)
	current_user = user
	eyeobj.eye_user = user
	eyeobj.name = "Camera Eye ([user.name])"
	user.remote_control = eyeobj
	user.reset_perspective(eyeobj)

/mob/camera/ai_eye/remote
	name = "Inactive Camera Eye"
	// Abductors dont trigger the Ai Detector
	ai_detector_visible = FALSE
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/mob/living/carbon/human/eye_user = null
	var/obj/machinery/computer/camera_advanced/origin
	var/eye_initialized = 0
	var/visible_icon = 0
	var/image/user_image = null

/mob/camera/ai_eye/remote/Destroy()
	eye_user = null
	origin = null
	return ..()

/mob/camera/ai_eye/remote/RemoveImages()
	..()
	if(visible_icon)
		var/client/C = GetViewerClient()
		if(C)
			C.images -= user_image

/mob/camera/ai_eye/remote/GetViewerClient()
	if(eye_user)
		return eye_user.client
	return null

/mob/camera/ai_eye/remote/setLoc(T)
	if(eye_user)
		if(!isturf(eye_user.loc))
			return
		T = get_turf(T)
		var/old_loc = loc
		loc = T
		Moved(old_loc, get_dir(old_loc, loc))
		if(use_static)
			GLOB.cameranet.visibility(src, GetViewerClient())
		if(visible_icon)
			if(eye_user.client)
				eye_user.client.images -= user_image
				user_image = image(icon,loc,icon_state,FLY_LAYER)
				eye_user.client.images += user_image

/mob/camera/ai_eye/remote/relaymove(mob/user,direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday) // 3 seconds
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(src, direct))
		if(step)
			src.setLoc(step)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial

/datum/action/innate/camera_off
	name = "End Camera View"
	button_overlay_icon_state = "camera_off"

/datum/action/innate/camera_off/Activate()
	if(!target || !iscarbon(target))
		return
	var/mob/living/carbon/C = target
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/console = remote_eye.origin
	console.remove_eye_control(target)

/datum/action/innate/camera_jump
	name = "Jump To Camera"
	button_overlay_icon_state = "camera_jump"

/datum/action/innate/camera_jump/Activate()
	if(!target || !iscarbon(target))
		return
	var/mob/living/carbon/C = target
	var/mob/camera/ai_eye/remote/remote_eye = C.remote_control
	var/obj/machinery/computer/camera_advanced/origin = remote_eye.origin

	var/list/L = list()

	for(var/obj/machinery/camera/cam in GLOB.cameranet.cameras)
		L.Add(cam)

	camera_sort(L)

	var/list/T = list()

	for(var/obj/machinery/camera/netcam in L)
		var/list/tempnetwork = netcam.network&origin.networks
		if(length(tempnetwork))
			T[text("[][]", netcam.c_tag, (netcam.can_use() ? null : " (Deactivated)"))] = netcam


	playsound(origin, 'sound/machines/terminal_prompt.ogg', 25, 0)
	var/camera = tgui_input_list(target, "Choose which camera you want to view", "Cameras", T)
	var/obj/machinery/camera/final = T[camera]
	playsound(origin, "terminal_type", 25, 0)
	if(final)
		playsound(origin, 'sound/machines/terminal_prompt_confirm.ogg', 25, FALSE)
		remote_eye.setLoc(get_turf(final))
		C.overlay_fullscreen("flash", /atom/movable/screen/fullscreen/stretch/flash/noise)
		C.clear_fullscreen("flash", 3) //Shorter flash than normal since it's an ~~advanced~~ console!
	else
		playsound(origin, 'sound/machines/terminal_prompt_deny.ogg', 25, FALSE)
