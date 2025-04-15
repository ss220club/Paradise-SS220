#define BORGHYPO_REFILL_VALUE 10
#define SYNDICATE_NANITES_LIMIT 250 // прок..

/obj/item/reagent_containers/borghypo
	var/list/reagents_stored = list() // stores all reagents we have
	var/list/reagents_produced = list() // stores all reagents we've produced

/obj/item/reagent_containers/borghypo/Initialize(mapload)
	. = ..()
	refill_borghypo(loc, TRUE) // start with a full hypo

/obj/item/reagent_containers/borghypo/process()
	if(reagents_stored[choosen_reagent] >= maximum_reagents) // no need to refill
		if(charge_tick)
			charge_tick = 0
		return
	charge_tick++
	if(charge_tick < recharge_time) // not ready to refill
		return
	charge_tick = 0
	refill_borghypo(loc)

/obj/item/reagent_containers/borghypo/refill_borghypo(mob/living/silicon/robot/user, roundstart = FALSE)
	if(roundstart)
		for(var/reagent as anything in reagent_ids)
			reagents_stored[reagent] = maximum_reagents
			reagents_produced[reagent] = maximum_reagents
		return
	if(!istype(user)) // in case if someone shitspawns it
		return
	if(choosen_reagent == "syndicate_nanites" && reagents_produced["syndicate_nanites"] >= SYNDICATE_NANITES_LIMIT && !user.admin_spawned) // allow adminbuse
		to_chat(loc, span_warning("Nanite synthesizer is empty!"))
		return
	if(user.cell.use(charge_cost))
		var/reagents_to_add = min(maximum_reagents - reagents_stored[choosen_reagent], BORGHYPO_REFILL_VALUE)
		reagents_stored[choosen_reagent] += reagents_to_add
		reagents_produced[choosen_reagent] += reagents_to_add

// copypaste mostly
/obj/item/reagent_containers/borghypo/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(ishuman(target))
		var/mob/living/carbon/human/mob = target
		if(reagents_stored[choosen_reagent] < 5)
			to_chat(user, "<span class='warning'>The injector [reagents_stored[choosen_reagent] ? "lacks reagents" : "is empty"].</span>")
			return ITEM_INTERACT_COMPLETE
		if(!mob.can_inject(user, TRUE, user.zone_selected, penetrate_thick))
			return ITEM_INTERACT_COMPLETE

		to_chat(user, "<span class='notice'>You inject [mob] with the injector.</span>")
		to_chat(mob, "<span class='notice'>You feel a tiny prick!</span>")
		mob.reagents.add_reagent(choosen_reagent, 5)
		reagents_stored[choosen_reagent] -= 5
		user.changeNext_move(CLICK_CD_MELEE)
		if(mob.reagents)
			var/datum/reagent/injected = GLOB.chemical_reagents_list[choosen_reagent]
			var/contained = injected.name
			add_attack_logs(user, mob, "Injected with [name] containing [contained], transfered [5] units", injected.harmless ? ATKLOG_ALMOSTALL : null)
			to_chat(user, "<span class='notice'>[5] units injected. [reagents_stored[choosen_reagent]] units remaining.</span>")
		return ITEM_INTERACT_COMPLETE

	if(isliving(target)) // ignore non-human mobs
		return ITEM_INTERACT_COMPLETE

/obj/item/reagent_containers/borghypo/examine(mob/user)
	. = ..()
	var/datum/reagent/get_reagent_name = GLOB.chemical_reagents_list[choosen_reagent]
	. |= "<span class='notice'>It is currently dispensing [get_reagent_name.name]. Contains [reagents_stored[choosen_reagent]] units of various reagents.</span>" // We couldn't care less what actual reagent is in the container, just if there IS reagent in it

#undef BORGHYPO_REFILL_VALUE
#undef SYNDICATE_NANITES_LIMIT
