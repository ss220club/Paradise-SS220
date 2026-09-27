#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2
#define STAIR_INDICATOR_RANGE 3

/// One directional stair object can be chained with others. Its dir is the direction walked to climb up.
/obj/structure/stairs
	name = "stairs"
	desc = "A staircase connecting this floor to the one above."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	base_icon_state = "stairs"
	anchored = TRUE
	move_resist = INFINITY
	dir = SOUTH
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	var/force_open_above = FALSE
	var/terminator_mode = STAIR_TERMINATOR_AUTOMATIC
	var/turf/directly_above
	var/has_merged_sprites = TRUE
	var/list/mob_to_image
	var/list/materials = list()

/obj/structure/stairs/wood
	icon_state = "stairs_wood"
	has_merged_sprites = FALSE

/obj/structure/stairs/stone
	icon_state = "stairs_stone"
	has_merged_sprites = FALSE

/obj/structure/stairs/material
	icon_state = "stairs_material"
	has_merged_sprites = FALSE

/obj/structure/stairs/Initialize(mapload)
	. = ..()
	GLOB.stairs += src
	if(force_open_above)
		force_open_above()
		build_signal_listener()
	var/static/list/exit_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit_stairs))
	AddElement(/datum/element/connect_loc, exit_connections)
	var/static/list/range_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_enter_range),
		COMSIG_ATOM_EXITED = PROC_REF(on_exit_range),
	)
	AddComponent(/datum/component/connect_range, src, range_connections, STAIR_INDICATOR_RANGE)
	update_surrounding()

/obj/structure/stairs/Destroy()
	if(directly_above)
		UnregisterSignal(directly_above, COMSIG_TURF_CHANGE)
		directly_above = null
	for(var/mob/living/climber as anything in mob_to_image)
		clear_climber_image(climber, instant = TRUE)
	GLOB.stairs -= src
	return ..()

/obj/structure/stairs/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(force_open_above)
		build_signal_listener()
		force_open_above()
	update_surrounding()

/obj/structure/stairs/proc/update_surrounding()
	if(!has_merged_sprites)
		return
	update_appearance()
	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, 90)))
		stair.update_appearance()
	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, -90)))
		stair.update_appearance()

/obj/structure/stairs/update_icon_state()
	. = ..()
	if(!has_merged_sprites)
		return
	var/has_left_stairs = FALSE
	var/has_right_stairs = FALSE
	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, 90)))
		if(stair.dir == dir)
			has_left_stairs = TRUE
			break
	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, -90)))
		if(stair.dir == dir)
			has_right_stairs = TRUE
			break
	if(has_left_stairs && has_right_stairs)
		icon_state = "[base_icon_state]-m"
	else if(has_left_stairs)
		icon_state = "[base_icon_state]-r"
	else if(has_right_stairs)
		icon_state = "[base_icon_state]-l"
	else
		icon_state = base_icon_state

/obj/structure/stairs/proc/on_exit_stairs(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER
	if(leaving == src)
		return
	if(!isobserver(leaving) && isTerminator() && direction == dir)
		if(HAS_TRAIT(leaving, TRAIT_CURRENTLY_Z_MOVING))
			return
		ADD_TRAIT(leaving, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
		INVOKE_ASYNC(src, PROC_REF(stair_ascend), leaving)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

#define POINT_X_COMPONENT(pdir) ((pdir & EAST) ? 2 : ((pdir & WEST) ? -2 : 0))
#define POINT_Y_COMPONENT(pdir) ((pdir & SOUTH) ? 2 : ((pdir & NORTH) ? -2 : 0))

/obj/structure/stairs/proc/on_enter_range(datum/source, atom/movable/entered)
	SIGNAL_HANDLER
	if(!isliving(entered))
		return
	var/mob/living/climber = entered
	var/mob/living/climber_ref = climber
	if(!climber.client || climber.dir == REVERSE_DIR(dir))
		return
	if(LAZYACCESS(mob_to_image, climber_ref) || !(climber in viewers(STAIR_INDICATOR_RANGE + 1, src)))
		return
	if(!istype(get_turf_above(get_turf(src)), /turf/space/open))
		return
	var/image/pointing_image = get_pointing_image()
	climber.client.images += pointing_image
	pointing_image.alpha = 0
	animate(pointing_image, pixel_x = POINT_X_COMPONENT(dir), pixel_y = POINT_Y_COMPONENT(dir), time = 0.5 SECONDS, easing = SINE_EASING|EASE_OUT, loop = -1, tag = "point_xy")
	animate(pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, easing = SINE_EASING|EASE_IN)
	animate(pointing_image, alpha = 180, time = 0.75 SECONDS, tag = "point_fadein")
	LAZYSET(mob_to_image, climber_ref, pointing_image)

/obj/structure/stairs/proc/on_exit_range(datum/source, atom/movable/exited)
	SIGNAL_HANDLER
	if(!isliving(exited))
		return
	var/mob/living/climber_ref = exited
	if(!LAZYACCESS(mob_to_image, climber_ref) || (exited in viewers(STAIR_INDICATOR_RANGE, src)))
		return
	clear_climber_image(climber_ref)

/obj/structure/stairs/proc/clear_climber_image(mob/living/climber_ref, instant = FALSE)
	var/image/pointing_image = LAZYACCESS(mob_to_image, climber_ref)
	if(!pointing_image)
		LAZYREMOVE(mob_to_image, climber_ref)
		return
	if(instant)
		clear_climber_image_callback(climber_ref, pointing_image)
		return
	animate(pointing_image, alpha = 0, time = 0.75 SECONDS, tag = "point_fadeout")
	addtimer(CALLBACK(src, PROC_REF(clear_climber_image_callback), climber_ref, pointing_image), 1.5 SECONDS, TIMER_UNIQUE)


/obj/structure/stairs/proc/clear_climber_image_callback(mob/living/climber, image/pointing_image)
	climber?.client?.images -= pointing_image
	LAZYREMOVE(mob_to_image, climber)

/obj/structure/stairs/proc/get_pointing_image()
	var/image/point_image = image('icons/hud/screen_gen.dmi', src, "arrow_large_white_still")
	point_image.color = "#68ff68"
	point_image.appearance_flags |= KEEP_APART
	point_image.transform = matrix().Turn(dir2angle(REVERSE_DIR(dir)))
	point_image.layer = BELOW_MOB_LAYER
	var/turf/source_turf = get_turf(src)
	var/plane_offset = source_turf ? SSmapping.z_level_plane_offsets?["[source_turf.z]"] : 0
	if(isnull(plane_offset))
		plane_offset = 0
	point_image.plane = GET_Z_PLANE(GAME_PLANE, plane_offset)
	return point_image

#undef POINT_X_COMPONENT
#undef POINT_Y_COMPONENT

/obj/structure/stairs/Cross(atom/movable/AM)
	if(isTerminator() && get_dir(src, AM) == dir)
		return FALSE
	return ..()

/obj/structure/stairs/proc/stair_ascend(atom/movable/climber)
	if(QDELETED(climber))
		return
	if(get_turf(climber) != get_turf(src))
		REMOVE_TRAIT(climber, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
		return
	var/turf/stair_turf = get_turf(src)
	var/turf/checking = get_turf_above(stair_turf)
	if(!istype(checking, /turf/space/open))
		REMOVE_TRAIT(climber, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
		return
	var/turf/target = get_step(checking, dir)
	if(!target || target.density || isspaceturf(target))
		REMOVE_TRAIT(climber, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
		return
	var/turf/old_turf = get_turf(climber)
	var/moved = climber.Move(target, dir)
	REMOVE_TRAIT(climber, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
	if(moved)
		climber.pulling?.move_from_pull(climber, stair_turf, climber.glide_size)
		if(ismob(climber) && old_turf.z != target.z)
			var/mob/viewer = climber
			viewer.hud_used?.update_multiz_plane_visibility()
			viewer.update_sight()

/// Catch falling objects and mobs when the opening above this stair leads straight to it.
/obj/structure/stairs/proc/catch_multiz_fall(atom/movable/falling)
	if(QDELETED(falling))
		return FALSE
	var/tumble_down_stairs = FALSE
	if(isliving(falling))
		var/mob/living/fallen_mob = falling
		tumble_down_stairs = can_fall_down_stairs(fallen_mob)
	falling.forceMove(get_turf(src))
	if(tumble_down_stairs)
		on_fall(falling)
	return TRUE

/obj/structure/stairs/proc/can_fall_down_stairs(mob/living/falling)
	return falling.stat != CONSCIOUS || falling.IsWeakened()

/obj/structure/stairs/proc/on_fall(mob/living/falling)
	falling.Weaken(2 SECONDS)
	falling.spin(1 SECONDS, 0.25 SECONDS)
	falling.adjustBruteLoss(rand(4, 8))
	GLOB.move_manager.move_towards(falling, get_ranged_target_turf(src, REVERSE_DIR(dir), 2), delay = 0.4 SECONDS, timeout = 1 SECONDS)

/obj/structure/stairs/vv_edit_var(var_name, var_value)
	. = ..()
	if(!. || var_name != NAMEOF(src, force_open_above))
		return
	if(!var_value)
		if(directly_above)
			UnregisterSignal(directly_above, COMSIG_TURF_CHANGE)
			directly_above = null
	else
		build_signal_listener()
		force_open_above()

/obj/structure/stairs/proc/build_signal_listener()
	if(directly_above)
		UnregisterSignal(directly_above, COMSIG_TURF_CHANGE)
	directly_above = get_turf_above(get_turf(src))
	if(directly_above)
		RegisterSignal(directly_above, COMSIG_TURF_CHANGE, PROC_REF(on_multiz_turf_change))

/obj/structure/stairs/proc/force_open_above()
	var/turf/above_turf = get_turf_above(get_turf(src))
	if(above_turf && !istype(above_turf, /turf/space/open))
		above_turf.ChangeTurf(/turf/space/open)

/obj/structure/stairs/proc/on_multiz_turf_change(datum/source, path, defer_change, keep_icon, ignore_air, copy_existing_baseturf)
	SIGNAL_HANDLER
	if(!QDELETED(src) && force_open_above && path != /turf/space/open)
		INVOKE_ASYNC(src, PROC_REF(force_open_above))

/obj/structure/stairs/proc/isTerminator()
	if(terminator_mode != STAIR_TERMINATOR_AUTOMATIC)
		return terminator_mode == STAIR_TERMINATOR_YES
	var/turf/current_turf = get_turf(src)
	var/turf/next_turf = current_turf ? get_step(current_turf, dir) : null
	if(!next_turf)
		return FALSE
	for(var/obj/structure/stairs/next_stair in next_turf)
		if(next_stair.dir == dir)
			return FALSE
	return TRUE

/obj/structure/stairs_frame
	name = "stairs frame"
	desc = "A frame used to construct a staircase."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs_frame"
	density = FALSE
	anchored = FALSE
	var/frame_stack = /obj/item/stack/rods
	var/frame_stack_amount = 10

/obj/structure/stairs_frame/wood
	name = "wooden stairs frame"
	frame_stack = /obj/item/stack/sheet/wood

/obj/structure/stairs_frame/AltClick(mob/user)
	if(!user || !Adjacent(user) || user.incapacitated())
		return
	if(anchored)
		to_chat(user, SPAN_WARNING("Unwrench the frame before rotating it."))
		return TRUE
	setDir(turn(dir, 90))
	return TRUE

/obj/structure/stairs_frame/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE(anchored ? "The frame is secured and ready for ten sheets of material." : "Secure the frame with a wrench before adding material.")

/obj/structure/stairs_frame/wrench_act(mob/living/user, obj/item/used_tool)
	if(!used_tool.use_tool(src, user, 3 SECONDS))
		return TRUE
	anchored = !anchored
	playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	return TRUE

/obj/structure/stairs_frame/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		new frame_stack(get_turf(src), frame_stack_amount)
	return ..()

/obj/structure/stairs_frame/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!isstack(tool))
		return ..()
	if(!anchored)
		to_chat(user, SPAN_WARNING("Secure the frame with a wrench first."))
		return ITEM_INTERACT_COMPLETE
	var/obj/item/stack/material = tool
	if(!material.stairs_type && !istype(material, /obj/item/stack/sheet))
		return ..()
	if(material.get_amount() < 10)
		to_chat(user, SPAN_WARNING("You need ten sheets to build stairs."))
		return ITEM_INTERACT_COMPLETE
	if(locate(/obj/structure/stairs) in loc)
		to_chat(user, SPAN_WARNING("There are already stairs here."))
		return ITEM_INTERACT_COMPLETE
	to_chat(user, SPAN_NOTICE("You start constructing [src]..."))
	if(!do_after(user, 10 SECONDS, target = src) || !material.use(10) || locate(/obj/structure/table) in loc)
		return ITEM_INTERACT_COMPLETE
	var/stairs_type = material.stairs_type ? material.stairs_type : /obj/structure/stairs/material
	var/obj/structure/stairs/new_stairs = new stairs_type(loc)
	new_stairs.setDir(dir)
	if(!material.stairs_type)
		var/list/materials_used = list()
		for(var/material_id in material.materials)
			materials_used[material_id] = material.materials[material_id] * 10
		new_stairs.materials = materials_used
		new_stairs.color = material.color
	qdel(src)
	return ITEM_INTERACT_COMPLETE

#undef STAIR_TERMINATOR_AUTOMATIC
#undef STAIR_TERMINATOR_NO
#undef STAIR_TERMINATOR_YES
#undef STAIR_INDICATOR_RANGE
