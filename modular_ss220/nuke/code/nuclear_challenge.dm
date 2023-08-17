#define CHALLENGE_TELECRYSTALS 280
#define CHALLENGE_TIME_LIMIT 1 HOUR
#define CHALLENGE_SCALE_PLAYER 1
#define CHALLENGE_SCALE_BONUS 2
#define CHALLENGE_MIN_PLAYERS 50
#define CHALLENGE_SHUTTLE_DELAY 30 MINUTES
#define FORCE_WAR_DECLARATION_DELAY 3 MINUTES

/obj/item/nuclear_challenge/check_allowed(mob/living/user)
	if(declaring_war)
		to_chat(user, "You are already in the process of declaring war! Make your mind up.")
		return FALSE
	return TRUE

/obj/item/nuclear_challenge/proc/force_war()
	var/war_declaration = "Syndicate объявили свои намерения уничтожить станцию [station_name] и вызывают экипаж попробовать их остановить."
	GLOB.major_announcement.Announce(war_declaration, "Declaration of War", 'sound/effects/siren.ogg', msg_sanitized = TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(set_security_level), SEC_LEVEL_GAMMA), 30 SECONDS)
	for(var/obj/machinery/computer/shuttle/syndicate/S in GLOB.machines)
		S.challenge = TRUE
		S.challenge_time = world.time

	// It is intended that additional tk can be negative
	total_tc = CHALLENGE_TELECRYSTALS + round((((GLOB.player_list.len - CHALLENGE_MIN_PLAYERS)/CHALLENGE_SCALE_PLAYER) * CHALLENGE_SCALE_BONUS))
	share_telecrystals()
	SSshuttle.refuel_delay = CHALLENGE_SHUTTLE_DELAY
	qdel(src)


/obj/item/nuclear_challenge/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(TYPE_PROC_REF(/obj/item/nuclear_challenge, force_war)), )

#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_MIN_PLAYERS
#undef CHALLENGE_SHUTTLE_DELAY
#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_SCALE_PLAYER
#undef CHALLENGE_SCALE_BONUS
#undef FORCE_WAR_DECLARATION_DELAY
