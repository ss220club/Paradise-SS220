/obj/item/nails
	name = "гвозди"
	desc = "Хорошие гвозди, жаль бесполезные."
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "nails"

/obj/item/reagent_containers/food/snacks/nails
	name = "жаренные гвозди"
	desc = "Жаренных гвоздей не хочешь, не?"
	icon = 'modular_ss220/food/icons/food.dmi'
	icon_state = "nails_fried"
	trash = /obj/item/trash/plate
	bitesize = 6
	antable = FALSE
	list_reagents = list("iron" = 5, "nutriment" = 1)
	tastes = list("гвозди" = 1)

/obj/item/reagent_containers/food/snacks/nails/On_Consume(mob/living/carbon/human/user)
	. = ..()
	to_chat(user, "<span class='warning'>Ты чувствуешь адскую боль во рту!</span>")
	playsound(user, "bonebreak", 50, TRUE)
	user.apply_damage(5, BRUTE, "head")
	user.Confused(12 SECONDS)
	user.EyeBlurry(6 SECONDS)
	user.emote("scream")
	user.bleed(5)

	if(do_after(user, 5 SECONDS, needhand = FALSE, target = user, progress = FALSE, allow_moving = TRUE) && prob(50))
		user.vomit(lost_nutrition = 0, blood = 10)
	return ..()

/datum/food_processor_process/nails
	input = /obj/item/stack/rods
	output = /obj/item/nails

/datum/deepfryer_special/nails
	input = /obj/item/nails
	output = /obj/item/reagent_containers/food/snacks/nails
