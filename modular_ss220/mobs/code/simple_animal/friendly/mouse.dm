/datum/hud/simple_animal_mouse/New(mob/user)
	..()

	mymob.healths = new /atom/movable/screen/healths()
	infodisplay += mymob.healths

	mymob.nutrition_display = new /atom/movable/screen/nutrition()
	mymob.nutrition_display.screen_loc = "EAST-1:26,CENTER-1:15"
	// "EAST-2:32,CENTER-1:13"
	mymob.nutrition_display.icon = 'modular_ss220/mobs/code/simple_animal/friendly/screen_hunger_mouse_test.dmi' // TODO Перерисовать на сыр
	infodisplay += mymob.nutrition_display

	var/atom/movable/screen/using
	using = new /atom/movable/screen/act_intent/simple_animal()
	using.icon_state = mymob.a_intent
	static_inventory += using
	action_intent = using

	user.overlay_fullscreen("see_through_darkness", /atom/movable/screen/fullscreen/stretch/see_through_darkness)



/mob/living/simple_animal/mouse
	var/non_standard = FALSE // for no "mouse_" with mouse_color
	icon = 'modular_ss220/mobs/icons/mob/animal.dmi'
	death_sound = 'modular_ss220/mobs/sound/creatures/rat_death.ogg'
	talk_sound = list('modular_ss220/mobs/sound/creatures/rat_talk.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/rat_wound.ogg')
	blood_volume = BLOOD_VOLUME_SURVIVE
	butcher_results = list(/obj/item/food/meat/mouse = 1)

	// hungry mouse
	hud_type = /datum/hud/simple_animal_mouse
	nutrition = NUTRITION_LEVEL_HUNGRY + 10
	hunger_drain = HUNGER_FACTOR * 1.5
	var/previous_status
	var/busy = FALSE



/mob/living/simple_animal/mouse/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list("[squeak_sound]" = 1), 100, extrarange = SHORT_RANGE_SOUND_EXTRARANGE) //as quiet as a mouse or whatever

	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

	mouse_color = initial(mouse_color) // сбрасываем из-за наследования чтобы своим проком переписать
	color_pick()
	update_appearance(UPDATE_ICON_STATE|UPDATE_DESC)

/mob/living/simple_animal/mouse/Login()
	. = ..()
	reagents = new()


/mob/living/simple_animal/mouse/proc/color_pick()
	if(!mouse_color)
		mouse_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[mouse_color]"
	icon_living = "mouse_[mouse_color]"
	icon_dead = "mouse_[mouse_color]_dead"
	icon_resting = "mouse_[mouse_color]_sleep"

/mob/living/simple_animal/mouse/splat(obj/item/item = null, mob/living/user = null)
	if(non_standard)
		var/temp_state = initial(icon_state)
		icon_dead = "[temp_state]_splat"
		icon_state = "[temp_state]_splat"
	else
		..()

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
	. = ..(gibbed)

/mob/living/simple_animal/mouse/proc/make_remains()
	var/obj/effect/decal/remains = new /obj/effect/decal/remains/mouse(src.loc)
	remains.pixel_x = pixel_x
	remains.pixel_y = pixel_y

/mob/living/simple_animal/mouse/handle_chemicals_in_body()

	var/hunger_rate = hunger_drain
	var/new_status
	adjust_nutrition(-hunger_rate)
	log_debug("\[ANTAG MIX\] nutriment in body: [nutrition]")

	switch(nutrition)
		if(NUTRITION_LEVEL_FULL * 1.4 to INFINITY)
			nutrition_display.icon_state = "explode"
			do_sparks(3, 1, src)
			src.gib()
		if(NUTRITION_LEVEL_FULL to INFINITY)
			nutrition_display.icon_state = "fat"
		if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
			nutrition_display.icon_state = "full"
		if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
			nutrition_display.icon_state = "well_fed"
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			nutrition_display.icon_state = "fed"
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			nutrition_display.icon_state = "hungry"
		if(NUTRITION_LEVEL_HYPOGLYCEMIA to NUTRITION_LEVEL_STARVING)
			nutrition_display.icon_state = "starving"
			// Someting bad

	new_status = nutrition_display.icon_state

	if(previous_status == new_status)
		return

	previous_status = new_status
	switch(new_status)
		if("explode")
			visible_message("[src] разарвало от обжорства!.", "Ваши внутренности не выдерживают и лопаются.")
			do_sparks(3, 1, src)
			src.gib()
		if("fat")
			name = "жирная [initial(name)]" // Мешаем англиский с русским
			desc = "[initial(desc)] Господи! Она же огромная!"

			to_chat(src, "<span class='userdanger'>Ты чувствуешь, что в тебя больше не влезет и кусочка</span>")
		if("full")
			name = initial(name)
			desc = initial(desc)
		if("well_fed")
			to_chat(src, "<span class='userdanger'>Ты чувствуешь себя превосходно!</span>")
		if("fed")
			name = initial(name)
			desc = initial(desc)
		if("hungr")
			name = "костлявая [initial(name)]"
			desc = "[initial(desc)] Вы можете видеть рёбра через кожу."
			to_chat(src, "<span class='userdanger'>Твой живот угрюмо урчит, лучше найти что-то поесть</span>")
		if("starving")
			nutrition_display.icon_state = "starving"
		// Someting bad


//Prevents mouse from pulling things
/mob/living/simple_animal/mouse/start_pulling(atom/movable/AM, state, force = pull_force, show_message = FALSE)
	if(istype(AM, /obj/item/food))
		// This is stolen from mob/living/start_pulling
		// because i can't call it from here ..()
		// insted it will call upstream version of mouse/start_pulling
		// Let me know if you know how to do it better
		if(!(AM.can_be_pulled(src, state, force, show_message)))
			return FALSE
		if(incapacitated())
			return
		if(SEND_SIGNAL(src, COMSIG_LIVING_TRY_PULL, AM, force) & COMSIG_LIVING_CANCEL_PULL)
			return FALSE
		return
	if(show_message)
		to_chat(src, "<span class='warning'>You are too small to pull anything except food.</span>")
	return

/mob/living/simple_animal/mouse/proc/consume(obj/item/food/F)

	if(busy)
		to_chat(src, "<span class='warning'>You need to finish chewing first.</span>")
		return

	busy = TRUE
	to_chat(src, "<span class='warning'>You're starting to chew on [F]...</span>")
	if(!do_after_once(src, 5 SECONDS, target = F, needhand = FALSE))
		to_chat(src, "<span class='warning'>You hurry up and stop chewing on [F]!</span>")
		busy = FALSE
		return

	visible_message("[src] ravenously consumes [F].", "You ravenously devour [F].")
	playsound(loc, 'sound/items/eatfood.ogg', 30, FALSE, frequency = 1.5)
	var/nutriment = F.reagents.get_reagent_amount("nutriment") * 20 // Human biology is hard, but you get about 20 times more regents.
	log_debug("\[ANTAG MIX\] nutriment got: [nutriment]")
	adjust_nutrition(nutriment)
	F.generate_trash(F)
	busy = FALSE
	qdel(F)



// /mob/living/simple_animal/mouse/emote(act, m_type = 1, message = null, force)

// 		if("help")
// 			to_chat(src, "scream, squeak")
// 			playsound(src, damaged_sound, 40, 1)

/mob/living/simple_animal/mouse/brown/tom
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
