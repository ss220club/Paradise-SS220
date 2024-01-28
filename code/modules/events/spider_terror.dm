#define TS_POINTS_GREEN 9
#define TS_POINTS_WHITE 17
#define TS_POINTS_PRINCESS 19
#define TS_POINTS_PRINCE 30
#define TS_POINTS_QUEEN 42

#define TERROR_GREEN /mob/living/simple_animal/hostile/poison/terror_spider/green
#define TERROR_WHITE /mob/living/simple_animal/hostile/poison/terror_spider/prince
#define TERROR_PRINCESS /mob/living/simple_animal/hostile/poison/terror_spider/queen/princess
#define TERROR_PRINCE /mob/living/simple_animal/hostile/poison/terror_spider/prince
#define TERROR_QUEEN /mob/living/simple_animal/hostile/poison/terror_spider/queen



/datum/event/spider_terror
	announceWhen = 240
	var/spawncount = 0
	var/spawnpoints = 9
	var/successSpawn = FALSE	//So we don't make a command report if nothing gets spawned.
	var/list/spider_types = list("TERROR_GREEN" = TERROR_GREEN, "TERROR_WHITE" = TERROR_WHITE, "TERROR_PRINCESS" = TERROR_PRINCESS, "TERROR_PRINCE" = TERROR_PRINCE, "TERROR_QUEEN" = TERROR_QUEEN)
	var/list/spider_costs = list("TERROR_GREEN" = TS_POINTS_GREEN, "TERROR_WHITE" = TS_POINTS_WHITE, "TERROR_PRINCESS" = TS_POINTS_PRINCESS, "TERROR_PRINCE" = TS_POINTS_PRINCE, "TERROR_QUEEN" = TS_POINTS_QUEEN)
	var/list/spider_counts = list("TERROR_GREEN" = 0, "TERROR_WHITE" = 0, "TERROR_PRINCESS" = 0, "TERROR_PRINCE" = 0, "TERROR_QUEEN" = 0)

/datum/event/spider_terror/setup()
	announceWhen = rand(announceWhen, announceWhen + 30)

/datum/event/spider_terror/announce(false_alarm)
	if(successSpawn || false_alarm)
		GLOB.major_announcement.Announce("Confirmed outbreak of level 3-S biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/effects/siren-spooky.ogg', new_sound2 = 'sound/AI/outbreak3.ogg')
	else
		log_and_message_admins("Warning: Could not spawn any mobs for event Terror Spiders")

/datum/event/spider_terror/start()
	// It is necessary to wrap this to avoid the event triggering repeatedly.
	INVOKE_ASYNC(src, PROC_REF(wrappedstart))

/datum/event/spider_terror/proc/wrappedstart()
	var/list/candidates = SSghost_spawns.poll_candidates("Do you want to play as a terror spider?", null, TRUE, source = /mob/living/simple_animal/hostile/poison/terror_spider) // questionable
	var/max_spiders = length(candidates)
	log_debug("where is [max_spiders] candidates")
	spawnpoints += round(length(GLOB.clients) / 1.5) // server population sensevity
	log_debug("where is [spawnpoints] available spawnpoints")
	spawn_terror_spiders(count_spawn_spiders(max_spiders), candidates)
	SSevents.biohazards_this_round += 1

/datum/event/spider_terror/proc/count_spawn_spiders(max_spiders)
	while(spawnpoints >= TS_POINTS_GREEN && spawncount < max_spiders)
		var/chosen_spider_id = pick(spider_costs) // random spider type choose
		var/cost = spider_costs[chosen_spider_id]

		if(spawnpoints - cost >= 0)
			spider_counts[chosen_spider_id] += 1
			spawnpoints -= cost
			spawncount += 1
			log_debug("where is [spawnpoints] available spawnpoints")

		if(spawnpoints >= TS_POINTS_GREEN)
			continue

		else
			break // lack of points break

		if(spawncount >= max_spiders)

			break // over candidates limit break
	log_debug("spider list is done: [spider_counts]")
	log_debug("selected [spawncount] spider(s)")
	return spider_counts

/datum/event/spider_terror/proc/spawn_terror_spiders(list/spider_counts, candidates)
	log_debug("begin spiders spawning")
	var/list/vents = get_valid_vent_spawns(exclude_mobs_nearby = TRUE)
	if(!length(vents))
		message_admins("Warning: No suitable vents detected for spawning terrors. Force picking from station vents regardless of state!")
		vents = get_valid_vent_spawns(unwelded_only = FALSE, min_network_size = 0)

	log_debug("where is awailible [length(vents)] vents")

	while(spawncount && length(vents) && length(candidates))
		log_debug("list inspection started")
		for(var/spider_id in spider_counts)
			var/spider_type = spider_types[spider_id]
			var/spider_count = spider_counts[spider_id]

			while(spider_count > 0 && length(candidates))
				var/obj/vent = pick_n_take(vents)
				log_debug("type is set: [spider_type]")
				var/mob/living/simple_animal/hostile/poison/terror_spider/S = new spider_type(vent.loc)
				var/mob/M = pick_n_take(candidates)
				S.key = M.key
				log_debug("key set")
				dust_if_respawnable(M)
				S.forceMove(vent)
				S.add_ventcrawl(vent)
				SEND_SOUND(S, sound('sound/ambience/antag/terrorspider.ogg'))
				S.give_intro_text()
				spawncount--
				successSpawn = TRUE

				spider_count --

			spider_counts[spider_type] = 0


#undef TS_POINTS_GREEN
#undef TS_POINTS_WHITE
#undef TS_POINTS_PRINCESS
#undef TS_POINTS_PRINCE
#undef TS_POINTS_QUEEN

#undef TERROR_GREEN
#undef TERROR_WHITE
#undef TERROR_PRINCESS
#undef TERROR_PRINCE
#undef TERROR_QUEEN
