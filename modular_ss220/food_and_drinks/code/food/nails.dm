/obj/item/nails
	name = "гвозди"
	desc = "Хорошие гвозди, жаль бесполезные."
	icon = 'modular_ss220/food_and_drinks/icons/food.dmi'
	icon_state = "nails"

/obj/item/food/nails
	name = "жаренные гвозди"
	desc = "Жаренных гвоздей не хочешь, не?"
	icon = 'modular_ss220/food_and_drinks/icons/food.dmi'
	icon_state = "nails_fried"
	trash = /obj/item/trash/plate
	bitesize = 3
	antable = FALSE
	list_reagents = list("iron" = 8, "nutriment" = 1)
	tastes = list("гвозди" = 1)

/obj/item/food/nails/On_Consume(mob/living/carbon/human/user)
	. = ..()
	to_chat(user, span_warning("Ты чувствуешь адскую боль во рту!"))
	playsound(user.loc, "bonebreak", 60, TRUE)
	user.apply_damage(5, BRUTE, "head")

	switch(rand(1, 3))
		if(1)
			user.Confused(12 SECONDS)
		if(2)
			user.EyeBlurry(6 SECONDS)
		if(3)
			user.bleed(5)

	if(prob(30))
		user.emote("scream")

	if(prob(10) && do_after(user, 5 SECONDS, needhand = FALSE, target = user, progress = FALSE, allow_moving = TRUE))
		user.vomit(lost_nutrition = 0, blood = 15, should_confuse = FALSE)
		user.emote("scream")

/datum/food_processor_process/nails
	input = /obj/item/stack/rods
	output = /obj/item/nails

/datum/cooking/recipe/nails
	container_type = /obj/item/reagent_containers/cooking/deep_basket
	product_type = /obj/item/food/nails
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/nails),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)
	appear_in_default_catalog = FALSE
