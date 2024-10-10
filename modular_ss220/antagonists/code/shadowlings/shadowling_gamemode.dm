/datum/game_mode
	var/list/datum/mind/shadowlings = list()
	var/list/datum/mind/shadowling_thralls = list()
	var/list/datum/mind/shadow_fathers = list()
	var/victory_warning_announced = FALSE

/// Called when shadow father is killed or when special spell is used
/datum/game_mode/proc/begin_shadowling_invasion(mob/living/simple_animal/demon/shadow_father/father, spell_used)
	father.consumed++	//At least one shadowling
	var/list/mob/dead/observer/candidates = SSghost_spawns.poll_candidates("Вы хотите поиграть за тенелинга?", ROLE_SHADOWLING, TRUE, 25 SECONDS, source = /mob/living/simple_animal/demon/shadow_father, role_cleanname = "Shadowling")
	while(father.consumed > 0)
		var/player_to_spawn
		if(spell_used)	// Granting shadowling role for father that commited suicide
			player_to_spawn = father.key
			spell_used = FALSE
		else
			var/list/mob/dead/observer/ghost = pick(candidates)
			player_to_spawn = ghost.key
		if(isnull(player_to_spawn))
			break
		var/obj/effect/dummy/slaughter/holder = new /obj/effect/dummy/slaughter(father.loc)
		var/mob/living/carbon/human/shadow/ling/ling = new /mob/living/carbon/human/shadow/ling(holder)
		dust_if_respawnable(player_to_spawn)
		ling.key = player_to_spawn
		father.consumed--

