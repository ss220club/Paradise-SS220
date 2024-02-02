/obj/spacepod
	//Action datums
	var/datum/action/innate/spacepod/spacepod_exit/exit_action = new
	var/datum/action/innate/spacepod/spacepod_toggle_brakes/brakes_action = new
	var/datum/action/innate/spacepod/spacepod_toggle_lights/lights_action = new
	var/datum/action/innate/spacepod/spacepod_toggle_poddoors/podddoors_action = new
	var/datum/action/innate/spacepod/spacepod_lock_doors/lock_action = new

/obj/spacepod/proc/GrantActions(mob/living/user)
	exit_action.Grant(user, src)
	brakes_action.Grant(user, src)
	lights_action.Grant(user, src)
	podddoors_action.Grant(user, src)
	lock_action.Grant(user, src)

/obj/spacepod/proc/RemoveActions(mob/living/user)
	exit_action.Remove(user)
	brakes_action.Remove(user)
	lights_action.Remove(user)
	podddoors_action.Remove(user)
	lock_action.Remove(user)

/datum/action/innate/spacepod
	check_flags = AB_CHECK_RESTRAINED | AB_CHECK_STUNNED | AB_CHECK_CONSCIOUS
	icon_icon = 'code/modules/spacepods/icons/actions_spacepod.dmi'
	var/obj/spacepod/frame

/datum/action/innate/spacepod/Grant(mob/living/L, obj/spacepod/S)
	if(S)
		frame = S
	. = ..()

/datum/action/innate/spacepod/Destroy()
	frame = null
	return ..()

// Actions!

/datum/action/innate/spacepod/spacepod_exit
	name = "Eject From Spacepod"
	button_icon_state = "pods_exit"

/datum/action/innate/spacepod/spacepod_exit/Activate()
	frame.go_out()

/datum/action/innate/spacepod/spacepod_toggle_brakes
	name = "Toggle Spacepod Brakes"
	button_icon_state = "handbrake_on"

/datum/action/innate/spacepod/spacepod_toggle_brakes/Activate()
	if(!frame.verb_check())
		return
	frame.brakes = !frame.brakes
	to_chat(usr, "<span class='notice'>You toggle the brakes [frame.brakes ? "on" : "off"].</span>")
	button_icon_state = "handbrake_[frame.brakes ? "on" : "off"]"
	UpdateButtonIcon()

/datum/action/innate/spacepod/spacepod_toggle_lights
	name = "Toggle Spacepod Lights"
	button_icon_state = "pods_lights_off"

/datum/action/innate/spacepod/spacepod_toggle_lights/Activate()
	if(!frame.verb_check())
		return

	/*
	if(!frame.cell || frame.cell.charge < 1) // RMNZ: To turn off button when cell has no power
		button_icon_state = "pods_lights_off"
		UpdateButtonIcon()
		return
	*/

	frame.lights = !frame.lights
	if(frame.lights)
		frame.set_light(frame.lights_power)
	else
		frame.set_light(0)
	to_chat(usr, "Lights toggled [frame.lights ? "on" : "off"].")
	button_icon_state = "pods_lights_[frame.lights ? "on" : "off"]"
	for(var/mob/M in frame.passengers)
		to_chat(M, "Lights toggled [frame.lights ? "on" : "off"].")
		button_icon_state = "pods_lights_[frame.lights ? "on" : "off"]"
	UpdateButtonIcon()

/datum/action/innate/spacepod/spacepod_toggle_poddoors
	name = "Toggle Nearest Pod Doors"
	button_icon_state = "blast_door_use"

/datum/action/innate/spacepod/spacepod_toggle_poddoors/Activate()
	if(!frame.verb_check())
		return

	for(var/obj/machinery/door/poddoor/multi_tile/P in orange(3, frame))
		for(var/mob/living/carbon/human/O in frame.contents)
			if(P.check_access(O.get_active_hand()) || P.check_access(O.wear_id))
				if(P.density)
					P.open()
					return TRUE
				else
					P.close()
					return TRUE
		to_chat(usr, "<span class='warning'>Access denied.</span>")
		return

	to_chat(usr, "<span class='warning'>You are not close to any pod doors.</span>")

/datum/action/innate/spacepod/spacepod_lock_doors
	name = "Lock Spacepod Doors"
	button_icon_state = "pods_door_on"

/datum/action/innate/spacepod/spacepod_lock_doors/Activate()
	if(!frame.verb_check(FALSE))
		return

	if(!frame.lock)
		to_chat(usr, "<span class='warning'>[src] has no locking mechanism.</span>")
		frame.locked = FALSE //Should never be false without a lock, but if it somehow happens, that will force an unlock.
	else
		frame.locked = !frame.locked
		to_chat(usr, "<span class='warning'>You [frame.locked ? "lock" : "unlock"] the doors.</span>")
		button_icon_state = "pods_door_[!frame.locked ? "on" : "off"]"
		UpdateButtonIcon()
