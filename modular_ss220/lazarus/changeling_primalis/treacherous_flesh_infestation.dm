/datum/disease/treacherous_flesh
	name = "Заражение биоассимилятором"
	max_stages = 6
	spread_text = "Не заразный"
	spread_flags = NON_CONTAGIOUS
	disease_flags = CURABLE|CAN_CARRY
	cure_text = "Lazarus Reagent"
	cures = list("lazarus_reagent")
	cure_chance = 25
	agent = "Клетки коварной плоти"
	viable_mobtypes = list(/mob/living/carbon/human)
	severity = BIOHAZARD
	form = "Infestation"
	bypasses_immunity = TRUE
	virus_heal_resistant = TRUE
	discovery_threshold = 0.8
	stage_prob = 100 //УДАЛИ ПОСЛЕ ТЕСТОВ

/datum/disease/treacherous_flesh/stage_act()
	if(!..())
		return FALSE
	if(stage == 6)
		if(prob(100)) //ПОСТАВЬ НА 5 ПОСЛЕ ТЕСТОВ
			if(istype(affected_mob, /mob/living/carbon/human)) // ДОБАВИТЬ  && !isnull(affected_mob.client) ПОСЛЕ ТЕСТОВ
				var/mob/living/carbon/human/host = affected_mob
				var/obj/effect/mob_spawn/treacherous_flesh/spawner = new /obj/effect/mob_spawn/treacherous_flesh
				host.contents += spawner
				spawner.host = host
				SSticker.mode.ling_hosts += host
				cure()
				notify_ghosts("Зародыш коварной плоти появился внутри организма [host].", enter_link = "<a href=byond://?src=[UID()];activate=1>(Click to control)</a>", source = spawner, action = NOTIFY_ATTACK)
	else
		return

/datum/reagent/treacherous_flesh
	name = "Клетки коварной плоти"
	id = "treacherous_flesh"
	description = "Крайне опасная клеточная структура, способная с лёгкостью преодолеть иммунную систему гуманойдов-органиков и полностью ассимилировать их организмы."
	reagent_state = SOLID
	color = "#2c0d0d"
	taste_description = "flesh"

/mob/living/carbon/human/proc/is_flesh_infecting()
	if(!changeling_primalis)
		return FALSE
	return changeling_primalis.infecting

/datum/reagent/treacherous_flesh/reaction_mob(mob/living/M, method = REAGENT_TOUCH, volume)
	if(M in SSticker.mode.ling_hosts || M.HasDisease(/datum/disease/treacherous_flesh))
		return ..()
	if(ishuman(M) && M.stat != DEAD)
		M.ForceContractDisease(new /datum/disease/treacherous_flesh)
	return ..()

/datum/surgery_step/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_flesh_infecting() && (target.stat != DEAD) && !(target in SSticker.mode.ling_hosts)) // ДОБАВИТЬ  && !isnull(affected_mob.client) ПОСЛЕ ТЕСТОВ
			target.ForceContractDisease(new /datum/disease/treacherous_flesh)
	return ..()

/obj/item/food/pickup(mob/living/carbon/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_flesh_infecting())
			reagents.check_and_add("treacherous_flesh", 1, 1)
	return ..()

/obj/item/reagent_containers/pickup(mob/living/carbon/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_flesh_infecting() && reagents.reagent_list)
			if(reagents.get_reagent_amount("treacherous_flesh") < 1)
				var/required_amount = 1 - reagents.get_reagent_amount("treacherous_flesh")
				if((reagents.maximum_volume - reagents.total_volume) < required_amount)
					reagents.remove_reagent("treacherous_flesh", reagents.get_reagent_amount("treacherous_flesh"))
					for(var/datum/reagent/current_reagent in reagents.reagent_list)
					{
						reagents.remove_reagent(current_reagent.id, current_reagent.volume/volume)
					}
					required_amount = 1
				reagents.add_reagent("treacherous_flesh", required_amount)
	return ..()
