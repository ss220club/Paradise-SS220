/mob/living/simple_animal/hostile/megafauna/drop_loot()
	if(length(loot) && prob(50))
		for(var/item in loot)
			new item(get_turf(src))

/mob/living/simple_animal/hostile/megafauna/spawn_crusher_loot()
	if(prob(50))
		loot = crusher_loot
