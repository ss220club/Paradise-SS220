/obj/machinery/wish_granter_dark
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE
	power_state = NO_POWER_USE

	var/power_mutations
	var/charges = 1
	var/insisting = FALSE

/obj/machinery/wish_granter_dark/Initialize(mapload)
	. = ..()
	power_mutations = list(/datum/mutation/meson_vision, /datum/mutation/night_vision, /datum/mutation/cold_resist, /datum/mutation/grant_spell/cryo)

/obj/machinery/wish_granter_dark/attack_hand(mob/living/carbon/human/user as mob)
	usr.set_machine(src)

	if(!charges)
		to_chat(user, "The Wish Granter lies silent.")
		return

	else if(!ishuman(user))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this. Something instinctual makes you pull away.")
		return

	else if(!insisting)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insisting = TRUE
		return

	insisting = FALSE
	var/wish = input("You want...","Wish") as null|anything in list("Power", "Wealth", "Immortality", "Peace")
	if(!wish)
		return
	charges--

	var/mob/living/carbon/human/human = user
	var/become_shadow = TRUE
	var/list/output = list()
	switch(wish)
		if("Power")
			output += "<B>Your wish is granted, but at a terrible cost...</B>"
			output += "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart."
			for(var/mutation_type in power_mutations)
				var/datum/mutation/mutation = GLOB.dna_mutations[mutation_type]
				mutation.activate(human)

		if("Wealth")
			output += "<B>Your wish is granted, but at a terrible cost...</B>"
			output += "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart."
			new /obj/structure/closet/syndicate/resources/everything(loc)

		if("Immortality")
			output += "<B>Your wish is granted, but at a terrible cost...</B>"
			output += "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart."
			user.verbs += /mob/living/carbon/human/verb/immortality

		if("Peace")
			output += "<B>Whatever alien sentience that the Wish Granter possesses is satisfied with your wish. There is a distant wailing as the last of the Faithless begin to die, then silence.</B>"
			output += "You feel as if you just narrowly avoided a terrible fate..."
			for(var/mob/living/simple_animal/hostile/faithless/F in GLOB.mob_living_list)
				F.death()
			become_shadow = FALSE

	if(become_shadow && !isshadowperson(human))
		human.set_species(/datum/species/shadow)
		output += span_warning("Your flesh rapidly mutates!")
		output += "<b>You are now a Shadow Person, a mutant race of darkness-dwelling humanoids.</b>"
		output += span_warning("Your body reacts violently to light.") + span_notice("However, it naturally heals in darkness.")
		output += "Aside from your new traits, you are mentally unchanged and retain your prior obligations."
		user.regenerate_icons()

	to_chat(user, output.Join("<br>"))

#define TRAIT_REVIVAL_IN_PROGRESS "revival_in_progress"

/mob/living/carbon/human/verb/immortality()
	set category = "Immortality"
	set name = "Resurrection"

	if(stat != DEAD)
		to_chat(src, span_notice("You're not dead yet!"))
		return

	if(HAS_TRAIT(src, TRAIT_REVIVAL_IN_PROGRESS))
		to_chat(src, span_notice("You're already rising from the dead!"))
		return

	ADD_TRAIT(src, TRAIT_REVIVAL_IN_PROGRESS, "Immortality")
	to_chat(src, span_notice("Death is not your end!"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, resurrect)), rand(80 SECONDS, 120 SECONDS))

/mob/living/carbon/human/proc/resurrect()
	// Stolen from ling stasis
	revive()
	updatehealth("Immortality")
	update_blind_effects()
	update_blurry_effects()
	regenerate_icons()
	update_revive()
	med_hud_set_status()
	med_hud_set_health()
	REMOVE_TRAIT(src, TRAIT_REVIVAL_IN_PROGRESS, "Immortality")
	to_chat(src, span_notice("You have regenerated."))
	visible_message(span_warning("[src] appears to wake from the dead, having healed all wounds"))

#undef TRAIT_REVIVAL_IN_PROGRESS
