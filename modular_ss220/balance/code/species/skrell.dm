/datum/reagent/consumable/ethanol/on_mob_life(mob/living/M)	// Dealing toxins when drinking alcohol
	if(isskrell(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.internal_organs_slot.kidneys, /obj/item/organ/internal/kidneys/skrell))
			H.adjustToxLoss(3 * alcohol_perc)
	return ..()

/obj/item/organ/internal/eyes/skrell	// Weak night vision
	see_in_dark = 3

/obj/item/reagent_containers/food/examine(mob/user)	// Reagent Scan
	. += ..()
	if(isskrell(user))
		. = "<span class='notice'>It contains:</span>"
		for(var/I in reagents.reagent_list)
			var/datum/reagent/R = I
			. += "<span class='notice'>[R.volume] units of [R.name]</span>"

/datum/species/skrell	// Getting less toxins
	tox_mod = 0.9
