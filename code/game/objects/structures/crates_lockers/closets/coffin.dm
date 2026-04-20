/obj/structure/closet/coffin
	name = "гроб"
	desc = "Это место захоронения усопших."
	icon_state = "coffin"
	enable_door_overlay = FALSE
	door_anim_time = 0
	resistance_flags = FLAMMABLE
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/wood
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25

/obj/structure/closet/coffin/sarcophagus
	name = "саркофаг"
	icon_state = "sarc"
	open_sound = 'sound/effects/stonedoor_openclose.ogg'
	close_sound = 'sound/effects/stonedoor_openclose.ogg'
	material_drop = /obj/item/stack/sheet/mineral/sandstone

/obj/structure/closet/coffin/vampire
	max_integrity = 500
	anchored = TRUE
	armor = list(MELEE = 200, BULLET = 200, LASER = 80, ENERGY = 200, BOMB = 200, RAD = 200, FIRE = 80, ACID = 200)	// just burn it
	custom_fire_overlay = " "	// gets rid of regular SSfires overlay, setting it on fire uses something completely different
	/// Owner of the coffin
	var/mob/vampire
	/// Is the coffin being set on fire?
	var/igniting = FALSE
	/// Last time the vampire was warned of the attack
	COOLDOWN_DECLARE(fire_act_cooldown)

/obj/structure/closet/coffin/vampire/Initialize(mapload, mob/user)
	. = ..()
	name = "\proper гроб  [user.mind.name]"
	desc += "<br>Владелец этого гроба, возможно, никому не был дорог или даже ещё не умер.<br>\
		[SPAN_WARNING("Кажется, оно неуязвимо для всего, кроме лазеров и огня! Особенно для огня!")]"
	vampire = user

/obj/structure/closet/coffin/vampire/welder_act(mob/user, obj/item/I)
	if(igniting)
		return ITEM_INTERACT_COMPLETE
	if(!I.tool_use_check(user, 30))	// it's a cursed coffin, you will need something better than a maintenance welder to ignite it
		return ITEM_INTERACT_COMPLETE
	igniting = TRUE
	to_chat(user, SPAN_NOTICE("Вы пытаетесь поджечь [src] с помощью [I]."))
	to_chat(vampire, SPAN_WARNING("На ваше логово напали!"))
	if(do_after(user, 15 SECONDS, target = src))
		fire_act()
	igniting = FALSE
	return ITEM_INTERACT_COMPLETE

/obj/structure/closet/coffin/vampire/bullet_act(obj/projectile/P)
	if(!P.immolate)
		return ..()
	fire_act()
	return ..()

/obj/structure/closet/coffin/vampire/fire_act()
	. = ..()
	if(!COOLDOWN_FINISHED(src, fire_act_cooldown))
		return
	to_chat(vampire, SPAN_WARNING("На ваше логово напали!"))
	switch(rand(1, 4))
		if(1)
			visible_message(SPAN_DANGER("Древесина воет, а огонь вспыхивает, казалось бы, из ниоткуда!"))
			playsound(src, "sound/goonstation/voice/howl.ogg", 30)
		if(2 to 3)
			visible_message(SPAN_DANGER("Древесина шипит, и огонь вспыхивает, казалось бы, из ниоткуда!"))
			if(prob(50))
				playsound(src, "sound/effects/unathihiss.ogg", 30)
			else
				playsound(src, "sound/effects/tajaranhiss.ogg", 30)
		if(4)
			visible_message(SPAN_DANGER("Древесина рычит, когда огонь вырывается из ниоткуда!"))
			playsound(src, 'sound/goonstation/voice/growl3.ogg', 30)
	var/turf/new_fire = pick(oview(2, src))
	new /obj/effect/fire(get_turf(new_fire), T20C, 30 SECONDS, 1)
	new /obj/effect/fire(loc, T20C, 30 SECONDS, 1)
	COOLDOWN_START(src, fire_act_cooldown, 10 SECONDS)

/obj/structure/closet/coffin/vampire/burn()
	playsound(src, 'sound/hallucinations/wail.ogg', 20, extrarange = SOUND_RANGE_SET(5))
	visible_message(SPAN_DANGER("Огонь вырывается из [name], когда он разрушается!"))
	for(var/turf/T in range(1, src))
		new /obj/effect/fire(T, T20C, 30 SECONDS, 1)
	..()
