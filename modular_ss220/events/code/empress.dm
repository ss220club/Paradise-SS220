// --------------------------------------------------------------------------------
// ----------------- TERROR SPIDERS: T5 EMPRESS OF TERROR -------------------------
// --------------------------------------------------------------------------------
// -------------: ROLE: ruling over planets of uncountable spiders, like Xenomorph Empresses.
// -------------: AI: none - this is strictly adminspawn-only and intended for RP events, coder testing, and teaching people 'how to queen'
// -------------: SPECIAL: Lay Eggs ability that allows laying queen-level eggs.
// -------------: TO FIGHT IT: run away screaming?
// -------------: SPRITES FROM: FoS, https://www.paradisestation.org/forum/profile/335-fos

/mob/living/simple_animal/hostile/poison/terror_spider/queen/empress
	name = "Empress of Terror"
	desc = "The unholy offspring of spiders, nightmares, and lovecraft fiction."
	ai_target_method = TS_DAMAGE_SIMPLE
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 30
	melee_damage_upper = 60
	idle_ventcrawl_chance = 0
	ai_playercontrol_allowtype = 0
	canlay = 1000
	spider_tier = TS_TIER_5
	projectiletype = /obj/item/projectile/terrorspider/empress
	icon = 'icons/mob/terrorspider64.dmi'
	pixel_x = -16
	move_resist = MOVE_FORCE_STRONG // no more pushing a several hundred if not thousand pound spider
	mob_size = MOB_SIZE_LARGE
	icon_state = "terror_empress"
	icon_living = "terror_empress"
	icon_dead = "terror_empress_dead"
	var/datum/action/innate/terrorspider/queen/empress/empresslings/empresslings_action
	var/datum/action/innate/terrorspider/queen/empress/empresserase/empresserase_action

/mob/living/simple_animal/hostile/poison/terror_spider/queen/empress/New()
	..()
	empresslings_action = new()
	empresslings_action.Grant(src)
	empresserase_action = new()
	empresserase_action.Grant(src)

/mob/living/simple_animal/hostile/poison/terror_spider/queen/empress/spider_special_action()
	return


/mob/living/simple_animal/hostile/poison/terror_spider/queen/empress/LayQueenEggs()
	var/eggtype = input("What kind of eggs?") as null|anything in list(TS_DESC_QUEEN, TS_DESC_MOTHER, TS_DESC_PRINCE, TS_DESC_PRINCESS, TS_DESC_KNIGHT, TS_DESC_LURKER, TS_DESC_HEALER, TS_DESC_WIDOW, TS_DESC_GUARDIAN, TS_DESC_DEFILER, TS_DESC_DESTROYER)
	var/numlings = input("How many in the batch?") as null|anything in list(1, 2, 3, 4, 5, 10, 15, 20, 30, 40, 50)
	if(eggtype == null || numlings == null)
		to_chat(src, "<span class='danger'>Cancelled.</span>")
		return
	switch(eggtype)
		if(TS_DESC_KNIGHT)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/knight, numlings)
		if(TS_DESC_LURKER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/lurker, numlings)
		if(TS_DESC_HEALER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/healer, numlings)
		if(TS_DESC_WIDOW)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/widow, numlings)
		if(TS_DESC_GUARDIAN)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/guardian, numlings)
		if(TS_DESC_DEFILER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/defiler, numlings)
		if(TS_DESC_DESTROYER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/destroyer, numlings)
		if(TS_DESC_PRINCE)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/prince, numlings)
		if(TS_DESC_PRINCESS)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/queen/princess, numlings)
		if(TS_DESC_MOTHER)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/mother, numlings)
		if(TS_DESC_QUEEN)
			DoLayTerrorEggs(/mob/living/simple_animal/hostile/poison/terror_spider/queen, numlings)
		else
			to_chat(src, "<span class='danger'>Unrecognized egg type.</span>")





/obj/item/projectile/terrorspider/empress
	name = "empress venom"
	icon_state = "toxin5"
	damage = 90
	damage_type = BRUTE
