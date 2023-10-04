/mob/living/simple_animal/mouse
	var/non_standard = FALSE // for no "mouse_" with mouse_color
	death_sound = 'modular_ss220/mobs/sound/creatures/rat_death.ogg'
	talk_sound = list('modular_ss220/mobs/sound/creatures/rat_talk.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/rat_wound.ogg')
	icon = 'modular_ss220/mobs/icons/mob/animal.dmi'

// /mob/proc/become_mouse()
	// вместо этого:
	// var/mob/living/simple_animal/mouse/host = new(vent_found.loc)
	// это:
	// var/choosen_type = prob(90) ? /mob/living/simple_animal/mouse : /mob/living/simple_animal/mouse/rat
	// var/mob/living/simple_animal/mouse/host = new choosen_type(vent_found.loc)




// /mob/proc/safe_respawn(var/MP)

// 	if(ispath(MP, /mob/living/simple_animal/cock))
// 		return 1
// 	if(ispath(MP, /mob/living/simple_animal/goose))
// 		return 1
// 	if(ispath(MP, /mob/living/simple_animal/turkey))
// 		return 1
// 	if(ispath(MP, /mob/living/simple_animal/mouse/hamster))
// 		return 1
// 	if(ispath(MP, /mob/living/simple_animal/mouse/rat))
// 		return 1

// 	if(ispath(MP, /mob/living/simple_animal/possum))
// 		return 1
// 	if(ispath(MP, /mob/living/simple_animal/pet/slugcat))
// 		return 1
// 	if(ispath(MP, /mob/living/simple_animal/frog))
// 		return 1



/obj/effect/decal/remains/mouse
	name = "remains"
	desc = "Некогда бывшая мышь. Её останки. Больше не будет пищать..."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_skeleton"
	anchored = FALSE
	move_resist = MOVE_FORCE_EXTREMELY_WEAK

/obj/effect/decal/remains/mouse/water_act(volume, temperature, source, method)
	. = ..()








/mob/living/simple_animal/mouse/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list("[squeak_sound]" = 1), 100, extrarange = SHORT_RANGE_SOUND_EXTRARANGE) //as quiet as a mouse or whatever

/mob/living/simple_animal/mouse
	tts_seed = "Gyro"
	talk_sound = list('modular_ss220/mobs/sound/creatures/rat_talk.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/rat_wound.ogg')
	death_sound = 'modular_ss220/mobs/sound/creatures/rat_death.ogg'
	blood_volume = BLOOD_VOLUME_SURVIVE
	//var/non_standard = FALSE //for no "mouse_" with mouse_color

/mob/living/simple_animal/mouse/New()
	..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

	color_pick()

/mob/living/simple_animal/mouse/proc/color_pick()
	if(!mouse_color)
		mouse_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[mouse_color]"
	icon_living = "mouse_[mouse_color]"
	icon_dead = "mouse_[mouse_color]_dead"
	icon_resting = "mouse_[mouse_color]_sleep"
	update_appearance(UPDATE_DESC)





/mob/living/simple_animal/mouse/splat(var/obj/item/item = null, var/mob/living/user = null)

	//icon_dead = "mouse_[mouse_color]_splat"
	//icon_state = "mouse_[mouse_color]_splat"

	if(non_standard)
		var/temp_state = initial(icon_state)
		icon_dead = "[temp_state]_splat"
		icon_state = "[temp_state]_splat"
	else
		icon_dead = "mouse_[mouse_color]_splat"
		icon_state = "mouse_[mouse_color]_splat"

	if(prob(50))
		var/turf/location = get_turf(src)
		add_splatter_floor(location)
		if(item)
			item.add_mob_blood(src)
		if(user)
			user.add_mob_blood(src)


/mob/living/simple_animal/mouse/death(gibbed)
	if(gibbed)
		make_remains()

	// Only execute the below if we successfully died
	playsound(src, squeak_sound, 40, 1)
	. = ..(gibbed)
	if(!.)
		return FALSE
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time



/mob/living/simple_animal/mouse/proc/make_remains()
	var/obj/effect/decal/remains = new /obj/effect/decal/remains/mouse(src.loc)
	remains.pixel_x = pixel_x
	remains.pixel_y = pixel_y


// /mob/living/simple_animal/mouse/emote(act, m_type = 1, message = null, force)

// 		if("help")
// 			to_chat(src, "scream, squeak")
// 			playsound(src, damaged_sound, 40, 1)

/mob/living/simple_animal/mouse/white
	tts_seed = "Meepo"

/mob/living/simple_animal/mouse/brown
	tts_seed = "Clockwerk"

/mob/living/simple_animal/mouse/brown/Tom
	tts_seed = "Arthas"
	maxHealth = 10
	health = 10





/mob/living/simple_animal/mouse/fluff/clockwork
	name = "Chip"
	real_name = "Chip"
	mouse_color = "clockwork"
	icon_state = "mouse_clockwork"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	gold_core_spawnable = NO_SPAWN
	can_collar = 0
	butcher_results = list(/obj/item/stack/sheet/metal = 1)
	maxHealth = 20
	health = 20
