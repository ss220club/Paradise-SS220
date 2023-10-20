/turf/simulated/floor/brick
	name = "brick floor"
	icon = 'modular_ss220/dunes_map/icons/desert.dmi'
	icon_state = "brick"
	baseturf = /turf/simulated/floor/indestructible/dune_sand

/turf/simulated/floor/indestructible/dune_sand
	name = "dune sand"
	icon = 'modular_ss220/dunes_map/icons/desert.dmi'
	icon_state = "sand"
	temperature = 325
	planetary_atmos = TRUE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	var/environment_type = "sand"
	var/obj/item/stack/digResult = /obj/item/stack/ore/glass
	var/floor_variance = 5
	var/dug

/turf/simulated/floor/indestructible/dune_sand/Initialize(mapload)
	var/proper_name = name
	. = ..()
	name = proper_name
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(1,4)]"

/turf/simulated/floor/indestructible/dune_sand/proc/getDug()
	new digResult(src, 5)
	icon_plating = "[environment_type]_dug"
	icon_state = "[environment_type]_dug"
	dug = TRUE

/turf/simulated/floor/indestructible/dune_sand/proc/can_dig(mob/user)
	if(!dug)
		return TRUE
	if(user)
		to_chat(user, "<span class='notice'>Выглядит так, будто тут уже кто-то копал.</span>")

/turf/simulated/floor/indestructible/dune_sand/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/simulated/floor/indestructible/dune_sand/burn_tile()
	return

/turf/simulated/floor/indestructible/dune_sand/MakeSlippery(wet_setting)
	return

/turf/simulated/floor/indestructible/dune_sand/MakeDry(wet_setting)
	return

/turf/simulated/floor/indestructible/dune_sand/remove_plating()
	return

/turf/simulated/floor/indestructible/dune_sand/crowbar_act(mob/user, obj/item/I)
	return

/turf/simulated/floor/indestructible/dune_sand/ex_act(severity)
	if(!can_dig())
		return
	switch(severity)
		if(3)
			return
		if(2)
			if(prob(20))
				getDug()
		if(1)
			getDug()

/turf/simulated/floor/indestructible/dune_sand/attackby(obj/item/I, mob/user, params)
	if(!I|| !user)
		return FALSE

	if((istype(I, /obj/item/shovel) || istype(I, /obj/item/pickaxe)))
		if(!can_dig(user))
			return TRUE

		var/turf/T = get_turf(user)
		if(!istype(T))
			return

		to_chat(user, "<span class='notice'>Вы начинаете копать...</span>")

		playsound(src, I.usesound, 50, TRUE)
		if(do_after(user, 40 * I.toolspeed, target = src))
			if(!can_dig(user))
				return TRUE
			to_chat(user, "<span class='notice'>Вы выкопали яму.</span>")
			getDug()
			return TRUE

	else if(istype(I, /obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = I
		if(S.pickup_all_on_tile)
			for(var/obj/item/stack/ore/O in contents)
				O.attackby(I, user)
				return

	else if(istype(I, /obj/item/stack/tile))
		var/obj/item/stack/tile/Z = I
		if(!Z.use(1))
			return
		if(istype(Z, /obj/item/stack/tile/plasteel)) // Turn asteroid floors into plating by default
			ChangeTurf(/turf/simulated/floor/plating, keep_icon = FALSE)
		else
			ChangeTurf(Z.turf_type, keep_icon = FALSE)
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)

/turf/simulated/floor/indestructible/dune_sand/smooth
	icon = 'modular_ss220/dunes_map/icons/sand_smooth.dmi'
	icon_state = "sand_smooth"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = list(/turf/simulated/floor/indestructible/dune_sand, /turf/simulated/floor/indestructible/dune_sand/smooth)

/turf/simulated/floor/indestructible/dune_sand/dug
	name = "sand dug"
	icon_state = "sand_dug"

/turf/simulated/floor/beach/water/desert_water
	icon = 'modular_ss220/dunes_map/icons/desert.dmi'
	baseturf = /turf/simulated/floor/beach/water/desert_water

/turf/simulated/wall/indestructible/rock/mineral/dune_rock
	name = "dune rock"
	color = "#D9742B"

/turf/simulated/floor/chasm/dune
	icon = 'modular_ss220/dunes_map/icons/chasm.dmi'
