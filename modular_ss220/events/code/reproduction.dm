
// --------------------------------------------------------------------------------
// ----------------- TERROR SPIDERS: EGGS (USED BY NURSE AND QUEEN TYPES) ---------
// --------------------------------------------------------------------------------



/obj/structure/spider/eggcluster/terror_eggcluster/Initialize(mapload, lay_type)
	. = ..()
	GLOB.ts_egg_list += src
	spiderling_type = lay_type

	switch(spiderling_type)
		if(/mob/living/simple_animal/hostile/poison/terror_spider/knight)
			name = "knight of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/lurker)
			name = "lurker of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/healer)
			name = "healer of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/reaper)
			name = "reaper of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/builder)
			name = "builder of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/widow)
			name = "widow of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/guardian)
			name = "guardian of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/destroyer)
			name = "destroyer of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/defiler)
			name = "defiler of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/mother)
			name = "mother of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/prince)
			name = "prince of terror eggs"
		if(/mob/living/simple_animal/hostile/poison/terror_spider/queen)
			name = "queen of terror eggs"


/obj/structure/spider/eggcluster/terror_eggcluster/process()
	amount_grown += 1
	if(amount_grown >= 140)  //x2 time for egg process, spiderlings grows instantly
		var/num = spiderling_number
		playsound(src, 'modular_ss220/events/sound/creatures/terrorspiders/eggburst.ogg', 100)
		for(var/i=0, i<num, i++)
			var/obj/structure/spider/spiderling/terror_spiderling/S = new /obj/structure/spider/spiderling/terror_spiderling(get_turf(src))
			if(spiderling_type)
				S.grow_as = spiderling_type
			S.spider_myqueen = spider_myqueen
			S.spider_mymother = spider_mymother
			S.enemies = enemies
			if(spider_growinstantly)
				S.amount_grown = 250
		qdel(src)

/obj/structure/spider/royaljelly
	name = "royal jelly"
	desc = "A pulsating mass of slime, jelly, blood, and or liquified human organs considered delicious and highly nutritious by terror spiders."
	icon_state = "spiderjelly"
