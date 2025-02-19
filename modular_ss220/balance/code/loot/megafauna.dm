/mob/living/simple_animal/hostile/megafauna
	var/static/list/alt_loot = list(/obj/structure/closet/crate/necropolis/tendril)
	var/alt_loot_drop = TRUE

/mob/living/simple_animal/hostile/megafauna/drop_loot()
	if(enraged || !alt_loot_drop || prob(75))
		return ..()
	if(length(loot))
		loot = alt_loot
		return ..()

/mob/living/simple_animal/hostile/megafauna/ancient_robot/drop_loot()
	if(enraged || !alt_loot_drop || prob(75))
		return ..()
	if(length(loot))
		loot = alt_loot
		return ..()

/mob/living/simple_animal/hostile/megafauna/bubblegum/hallucination
	alt_loot_drop = FALSE

/mob/living/simple_animal/hostile/megafauna/dragon/lesser
	alt_loot_drop = FALSE

/mob/living/simple_animal/hostile/megafauna/dragon/space_dragon
	alt_loot_drop = FALSE

/mob/living/simple_animal/hostile/megafauna/fleshling
	alt_loot_drop = FALSE

/mob/living/simple_animal/hostile/megafauna/bubblegum/drop_loot()
	if(!enraged)
		return ..()
	var/crate_type = pick(loot)
	var/obj/structure/closet/crate/C = new crate_type(loc)
	new /obj/item/melee/spellblade/random(C)

/obj/structure/closet/crate/necropolis/bubblegum/populate_contents()
	new /obj/item/clothing/suit/space/hostile_environment(src)
	new /obj/item/clothing/head/helmet/space/hostile_environment(src)
