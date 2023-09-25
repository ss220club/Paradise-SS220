// Meat
/obj/item/reagent_containers/food/snacks/meat/dog
	name = "dog meat"
	desc = "Не слишком питательно. Но говорят деликатес космокорейцев."
	list_reagents = list("protein" = 2, "epinephrine" = 2)

/obj/item/reagent_containers/food/snacks/meat/security
	name = "security meat"
	desc = "Мясо наполненное чувством мужества и долга."
	list_reagents = list("protein" = 3, "epinephrine" = 5)

/obj/item/reagent_containers/food/snacks/meat/ham/old
	name = "жесткая ветчина"
	desc = "Мясо почтенного хряка."
	list_reagents = list("protein" = 2, "porktonium" = 10)

/obj/item/reagent_containers/food/snacks/meat/mouse
	name = "мышатина"
	desc = "На безрыбье и мышь мясо. Кто знает чем питался этот грызун до его подачи к столу."
	icon_state = "meat_clear"
	list_reagents = list("nutriment" = 2, "blood" = 3, "toxin" = 1)

/obj/item/reagent_containers/food/snacks/salmonmeat/snailmeat
	name = "snail meat"
	desc = "Сырая космо-улитка в собственном соку."
	filling_color = "#6bb4a8"
	list_reagents = list("protein" = 5, "vitamin" = 5)

/obj/item/reagent_containers/food/snacks/salmonmeat/turtlemeat
	name = "snail meat"
	desc = "Сырая космо-улитка в собственном соку."
	filling_color = "#2fa24c"
	list_reagents = list("protein" = 10, "vitamin" = 8)

// Animal holders
/obj/item/holder/possum
	name = "possum"
	desc = "It's a possum. Ewwww..."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "possum"
	origin_tech = "biotech=3"

/obj/item/holder/possum/poppy
	name = "poppy"
	desc = "It's a possum Poppy. Ewwww..."
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "possum_poppy"

/obj/item/holder/axolotl
	name = "pet"
	desc = "It's a pet"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "axolotl"

/obj/item/holder/snail
	name = "snail"
	desc = "Slooooow"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "snail"
	slot_flags = null

/obj/item/holder/turtle
	name = "yeeslow"
	desc = "Slooooow"
	icon = 'modular_ss220/mobs/icons/pets.dmi'
	icon_state = "yeeslow"
	slot_flags = null

// Simple animal procs
/mob/living/simple_animal
	var/list/damaged_sound = null // The sound player when player hits animal
	var/list/talk_sound = null // The sound played when talk

/mob/living/simple_animal/say(message, verb, sanitize, ignore_speech_problems, ignore_atmospherics)
	. = ..()
	if(. && length(src.talk_sound))
		playsound(src, pick(src.talk_sound), 75, TRUE)

/mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/attack_alien(mob/living/carbon/alien/humanoid/M)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/attack_larva(mob/living/carbon/alien/larva/L)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/attack_slime(mob/living/simple_animal/slime/M)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/attack_robot(mob/living/user)
	. = ..()
	if(. && length(src.damaged_sound))
		playsound(src, pick(src.damaged_sound), 40, 1)

/mob/living/simple_animal/start_pulling(atom/movable/AM, state, force = pull_force, show_message = FALSE)
	if(pull_constraint(AM, show_message))
		return ..()

/mob/living/simple_animal/proc/pull_constraint(atom/movable/AM, show_message = FALSE)
	return TRUE
