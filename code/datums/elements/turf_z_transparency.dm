/// Transparent floors display the turf below through themselves and nearby turf edges.
/// This is the BandaStation z-pillar renderer, adapted to PSS13's linked z-level helpers.
GLOBAL_LIST_EMPTY(multiz_pillars_by_z)
#define MULTIZ_PILLAR_SIZE 20
#define MULTIZ_PILLAR_KEY(position) ROUND_UP(position / MULTIZ_PILLAR_SIZE)

/proc/request_multiz_pillar(x, y, z)
	if(length(GLOB.multiz_pillars_by_z) < z)
		GLOB.multiz_pillars_by_z.len = z
	var/list/our_z = GLOB.multiz_pillars_by_z[z]
	if(!our_z)
		our_z = list()
		GLOB.multiz_pillars_by_z[z] = our_z
	var/x_key = MULTIZ_PILLAR_KEY(x)
	if(length(our_z) < x_key)
		our_z.len = x_key
	var/list/our_x = our_z[x_key]
	if(!our_x)
		our_x = list()
		our_z[x_key] = our_x
	var/y_key = MULTIZ_PILLAR_KEY(y)
	if(length(our_x) < y_key)
		our_x.len = y_key
	var/datum/multiz_pillar/pillar = our_x[y_key]
	if(!pillar)
		pillar = new(x_key, y_key, z)
		our_x[y_key] = pillar
	return pillar

/proc/is_multiz_space_opening(turf/T)
	if(!istype(T, /turf/space))
		return FALSE
	if(istype(T, /turf/space/open))
		return TRUE
	var/turf/below_turf = get_turf_below(T)
	while(isspaceturf(below_turf))
		below_turf = get_turf_below(below_turf)
	return below_turf != null

/proc/is_multiz_render_transparent(turf/T)
	// Banda renders directly into transparent floors and openspace turfs. PSS13
	// represents mapped shafts with ordinary space tiles, so recognize those too.
	return T && (T.transparent_floor || is_multiz_space_opening(T) || (istype(T, /turf/space) && get_turf_below(T)))

/// Find the corresponding turf at the source level, even when open space spans
/// more than one linked z-level.
/proc/get_multiz_visual_target(turf/displayed_turf, turf/source_turf)
	if(!displayed_turf || !source_turf)
		return null
	var/turf/visual_target = displayed_turf
	while(visual_target && visual_target.z < source_turf.z)
		visual_target = get_turf_above(visual_target)
	if(!visual_target || visual_target.z != source_turf.z)
		return null
	return locate(displayed_turf.x, displayed_turf.y, source_turf.z)

/// Holds a lower turf on an opaque upper turf without changing the lower turf's normal plane.
/obj/effect/abstract/multiz_z_holder
	var/datum/multiz_pillar/pillar
	var/turf/shown_turf
	appearance_flags = PIXEL_SCALE
	plane = HUD_PLANE
	anchored = TRUE
	move_resist = INFINITY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/abstract/multiz_z_holder/Destroy()
	if(pillar)
		pillar.drawing_objects -= shown_turf
		pillar = null
	shown_turf = null
	return ..()

/obj/effect/abstract/multiz_z_holder/proc/display(turf/to_display, datum/multiz_pillar/source_pillar)
	if(pillar)
		CRASH("Multiz holder reused while already displaying a turf")
	pillar = source_pillar
	shown_turf = to_display
	vis_contents += to_display
	source_pillar.drawing_objects[to_display] = src

/// Tracks which openings request each lower turf, avoiding duplicate display objects.
/datum/multiz_pillar
	var/x_key
	var/y_key
	var/z_level
	var/list/turf_sources = list()
	var/list/drawing_objects = list()

/datum/multiz_pillar/New(x_key, y_key, z_level)
	. = ..()
	src.x_key = x_key
	src.y_key = y_key
	src.z_level = z_level

/datum/multiz_pillar/Destroy()
	if(length(GLOB.multiz_pillars_by_z) >= z_level)
		var/list/by_x = GLOB.multiz_pillars_by_z[z_level]
		if(length(by_x) >= x_key)
			var/list/by_y = by_x[x_key]
			if(length(by_y) >= y_key)
				by_y[y_key] = null
	for(var/turf/displayed as anything in turf_sources)
		var/list/sources = turf_sources[displayed]
		for(var/turf/source as anything in sources.Copy())
			hide_turf(displayed, source)
	return ..()

/datum/multiz_pillar/proc/display_turf(turf/to_display, turf/source)
	var/list/sources = turf_sources[to_display]
	if(sources)
		sources |= source
		var/obj/effect/abstract/multiz_z_holder/holder = drawing_objects[to_display]
		if(!holder)
			return
		var/turf/visual_target = get_multiz_visual_target(to_display, source)
		if(!is_multiz_render_transparent(visual_target))
			return
		holder.vis_contents -= to_display
		qdel(holder)
		drawing_objects -= to_display
		visual_target.vis_contents += to_display
		return

	sources = list(source)
	turf_sources[to_display] = sources
	var/turf/visual_target = get_multiz_visual_target(to_display, source)
	if(is_multiz_render_transparent(visual_target))
		visual_target.vis_contents += to_display
	else if(visual_target)
		var/obj/effect/abstract/multiz_z_holder/holder = new(visual_target)
		holder.display(to_display, src)

/datum/multiz_pillar/proc/hide_turf(turf/to_hide, turf/source)
	var/list/sources = turf_sources[to_hide]
	if(!sources)
		return
	sources -= source
	if(length(sources))
		return
	turf_sources -= to_hide
	var/obj/effect/abstract/multiz_z_holder/holder = drawing_objects[to_hide]
	if(holder)
		qdel(holder)
	else
		var/turf/visual_target = get_multiz_visual_target(to_hide, source)
		if(visual_target)
			visual_target.vis_contents -= to_hide
	if(!length(turf_sources) && !QDELETED(src))
		qdel(src)

/datum/multiz_pillar/proc/refresh_display(turf/affected_turf)
	var/list/sources = turf_sources[affected_turf]
	if(!length(sources))
		return
	var/obj/effect/abstract/multiz_z_holder/holder = drawing_objects[affected_turf]
	var/turf/source_turf = sources[1]
	var/turf/visual_target = get_multiz_visual_target(affected_turf, source_turf)
	if(holder && is_multiz_render_transparent(visual_target))
		holder.vis_contents -= affected_turf
		qdel(holder)
		drawing_objects -= affected_turf
		visual_target.vis_contents += affected_turf
	else if(!holder && visual_target && !is_multiz_render_transparent(visual_target))
		visual_target.vis_contents -= affected_turf
		holder = new(visual_target)
		holder.display(affected_turf, src)

/datum/element/turf_z_transparency
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/turf_z_transparency/Attach(datum/target)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE
	// Turf elements may be requested both during initialization and when a z-level
	// is linked after its turfs already exist. Re-registering this singleton's
	// handlers is intentional; replace the same callbacks instead of warning.
	RegisterSignal(target, COMSIG_TURF_MULTIZ_DEL, PROC_REF(on_multiz_turf_del), override = TRUE)
	RegisterSignal(target, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_turf_new), override = TRUE)
	update_multi_z(target)

/datum/element/turf_z_transparency/Detach(datum/source)
	clear_multiz(source)
	UnregisterSignal(source, list(COMSIG_TURF_MULTIZ_NEW, COMSIG_TURF_MULTIZ_DEL))
	return ..()

/datum/element/turf_z_transparency/proc/update_multi_z(turf/our_turf)
	var/turf/below_turf = get_turf_below(our_turf)
	if(!below_turf)
		return
	// Rendering a space turf that itself contains another vis_contents turf is
	// unreliable in BYOND. Render the first real surface straight onto this level.
	while(isspaceturf(below_turf))
		below_turf = get_turf_below(below_turf)
		if(!below_turf)
			return
	for(var/turf/partner in range(1, below_turf))
		var/datum/multiz_pillar/pillar = request_multiz_pillar(partner.x, partner.y, our_turf.z)
		pillar.display_turf(partner, our_turf)

/datum/element/turf_z_transparency/proc/clear_multiz(turf/our_turf)
	var/turf/below_turf = get_turf_below(our_turf)
	if(!below_turf)
		return
	while(isspaceturf(below_turf))
		below_turf = get_turf_below(below_turf)
		if(!below_turf)
			return
	for(var/turf/partner in range(1, below_turf))
		var/datum/multiz_pillar/pillar = request_multiz_pillar(partner.x, partner.y, our_turf.z)
		pillar.hide_turf(partner, our_turf)

/datum/element/turf_z_transparency/proc/on_multiz_turf_del(turf/our_turf, turf/below_turf, dir)
	SIGNAL_HANDLER
	if(dir == DOWN)
		clear_multiz(our_turf)
		var/turf/above_turf = get_turf_above(our_turf)
		if(above_turf && is_multiz_render_transparent(above_turf))
			SEND_SIGNAL(above_turf, COMSIG_TURF_MULTIZ_DEL, our_turf, DOWN)

/datum/element/turf_z_transparency/proc/on_multiz_turf_new(turf/our_turf, turf/below_turf, dir)
	SIGNAL_HANDLER
	if(dir == DOWN)
		update_multi_z(our_turf)
		var/turf/above_turf = get_turf_above(our_turf)
		if(above_turf && is_multiz_render_transparent(above_turf))
			SEND_SIGNAL(above_turf, COMSIG_TURF_MULTIZ_NEW, our_turf, DOWN)

#undef MULTIZ_PILLAR_SIZE
#undef MULTIZ_PILLAR_KEY
