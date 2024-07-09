// Dealing toxins when drinking alcohol
/datum/reagent/consumable/ethanol/on_mob_life(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.internal_organs_slot["kidneys"], /obj/item/organ/internal/kidneys/skrell))
			H.adjustToxLoss(5 * alcohol_perc)

// Weak night vision
/obj/item/organ/internal/eyes/skrell
	see_in_dark = 3

// Reagent Scan
/obj/item/food/examine(mob/user)
	. += ..()
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
