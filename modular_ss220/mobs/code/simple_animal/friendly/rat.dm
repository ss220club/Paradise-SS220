
/mob/living/simple_animal/mouse/rat
	name = "rat"
	real_name = "rat"
	desc = "Серая крыса. Не яркий представитель своего вида."
	icon = 'modular_ss220/mobs/icons/animals.dmi'
	squeak_sound = 'modular_ss220/mobs/sound/creatures/rat_squeak.ogg'
	icon_state = "rat_gray"
	icon_living = "rat_gray"
	icon_dead = "rat_gray_dead"
	icon_resting = "rat_gray_sleep"
	non_standard = TRUE
	mouse_color = null
	maxHealth = 15
	health = 15
	mob_size = MOB_SIZE_SMALL
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mouse = 2)

/mob/living/simple_animal/mouse/rat/ratatui
	name = "Рататуй"
	real_name = "Рататуй"
	desc = "Личная крыса шеф повара, помогающая ему при готовке наиболее изысканных блюд. До момента пока он не пропадет и повар не начнет готовить что-то новенькое..."
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 20
	health = 20

/mob/living/simple_animal/mouse/rat/white
	name = "white rat"
	real_name = "white rat"
	desc = "Типичный представитель лабораторных крыс."
	icon_state = "rat_white"
	icon_living = "rat_white"
	icon_dead = "rat_white_dead"
	icon_resting = "rat_white_sleep"
	mouse_color = "white"

/mob/living/simple_animal/mouse/rat/white/brain
	name = "Брейн"
	real_name = "Брейн"
	desc = "Сообразительная личная лабораторная крыса директора исследований, даже освоившая речь. Настолько часто сбегал, что его перестали помещать в клетку. Он явно хочет захватить мир. Где-то спрятался его напарник..."
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 20
	health = 20
	universal_speak = 1
	resting = TRUE

/mob/living/simple_animal/mouse/rat/irish
	name = "irish rat"
	real_name = "irish rat"
	desc = "Ирландская крыса. На космической станции?! На этот раз им точно некуда бежать!"
	icon_state = "rat_irish"
	icon_living = "rat_irish"
	icon_dead = "rat_irish_dead"
	icon_resting = "rat_irish_sleep"
	mouse_color = "irish"

/mob/living/simple_animal/mouse/rat/irish/remi
	name = "Реми"
	real_name = "Реми"
	desc = "Близкий друг Рататуя. Не любимец повара, но пока тот не мешает на кухне, ему разрешили здесь остаться. Очень толстая крыса."
	unique_pet = TRUE
	gold_core_spawnable = NO_SPAWN
	maxHealth = 25
	health = 25
	transform = matrix(1.250, 0, 0, 0, 1, 0) // Толстячок на +2 пикселя

// Remains
/obj/effect/decal/remains/mouse
	name = "remains"
	desc = "Некогда бывшая мышь. Её останки. Больше не будет пищать..."
	icon = 'modular_ss220/mobs/icons/animals.dmi'
	icon_state = "mouse_skeleton"

/obj/effect/decal/remains/mouse/water_act(volume, temperature, source, method)
	. = ..()

/obj/effect/decal/remains/mouse/pinkie
	name = "Пинки"
	desc = "Когда-то это был напарник самой сообразительной крысы в мире. К сожалению он таковым не являлся..."

// Mouse procs
/mob/living/simple_animal/mouse/proc/color_pick()
	if(!mouse_color)
		mouse_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[mouse_color]"
	icon_living = "mouse_[mouse_color]"
	icon_dead = "mouse_[mouse_color]_dead"
	icon_resting = "mouse_[mouse_color]_sleep"
	desc = "It's a small [mouse_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/mouse/rat/color_pick()
	if(!mouse_color)
		mouse_color = pick(list("gray","white","irish"))
		icon_state = "rat_[mouse_color]"
		icon_living = "rat_[mouse_color]"
		icon_dead = "rat_[mouse_color]_dead"
		icon_resting = "rat_[mouse_color]_sleep"

/mob/living/simple_animal/mouse/splat(obj/item/item = null, mob/living/user = null)
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
