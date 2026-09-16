// Dealing toxins when drinking alcohol
/mob/living/carbon/human/skrell/handle_kidneys()
	var/obj/item/organ/kidneys = get_int_organ(/obj/item/organ/internal/kidneys)

	var/damage_percentage = 0
	if(kidneys && !(kidneys.status & ORGAN_DEAD)) // No kidneys = full damage
		damage_percentage = ((kidneys.max_damage - kidneys.damage) / kidneys.max_damage) * 100
		if(damage_percentage >= 75) // Above 75% HP, no damage
			return

	var/total_damage = 0
	for(var/datum/reagent/chem as anything in reagents.reagent_list)
		if(istype(chem, /datum/reagent/consumable/ethanol))
			total_damage += chem.max_kidney_damage
		else
			total_damage += chem.max_kidney_damage

	if(!total_damage)
		return // No damage

	switch(damage_percentage)
		// No 0 since that's full damage
		if(1 to 25)
			total_damage *= 0.5
		if(25 to 50)
			total_damage *= 0.2
		if(50 to 75)
			total_damage *= 0.05

	adjustToxLoss(total_damage)

// Weak night vision
/obj/item/organ/internal/eyes/skrell
	see_in_dark = 3

// Reagent scan for food
/obj/item/food/examine(mob/user)
	. = ..()
	if(!isskrell(user))
		return
	. += SPAN_NOTICE("It contains:")
	for(var/datum/reagent/reagent_inside_food as anything in reagents.reagent_list)
		. += SPAN_NOTICE("[reagent_inside_food.volume] units of [reagent_inside_food.name]")

// Reagent scan for solutions
/mob/living/carbon/human/reagent_vision()
	return isskrell(src) || ..()

// Getting less toxins
/datum/species/skrell
	tox_mod = 0.9
