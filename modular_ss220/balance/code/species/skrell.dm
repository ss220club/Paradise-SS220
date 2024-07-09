// Dealing toxins when drinking alcohol
/obj/item/organ/internal/kidneys/skrell/on_life()
	. = ..()
	var/datum/reagent/consumable/ethanol/drink = locate(/datum/reagent/consumable/ethanol) in owner.reagents.reagent_list
	if(drink)
		if(is_broken())
			owner.adjustToxLoss(1.5 * drink.alcohol_perc * PROCESS_ACCURACY)
		else
			owner.adjustToxLoss(0.5 * drink.alcohol_perc * PROCESS_ACCURACY)
			receive_damage(0.1 * PROCESS_ACCURACY)

// Weak night vision
/obj/item/organ/internal/eyes/skrell
	see_in_dark = 3

// Reagent Scan
/obj/item/food/examine(mob/user)
	. = ..()
	if(isskrell(user))
		. += "<span class='notice'>It contains:</span>"
		for(var/I in reagents.reagent_list)
			var/datum/reagent/R = I
			. += "<span class='notice'>[R.volume] units of [R.name]</span>"

// Reagent vision
/mob/living/carbon/human/reagent_vision()
	if(isskrell(src))
		return TRUE
	return ..()

// Getting less toxins
/datum/species/skrell
	tox_mod = 0.9
