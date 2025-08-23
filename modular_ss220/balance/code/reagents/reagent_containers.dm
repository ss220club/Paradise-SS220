#define BORGHYPO_REFILL_VALUE 10
#define SYNDICATE_NANITES_LIMIT 250

/obj/item/reagent_containers/borghypo
	var/list/reagents_produced = list() // stores all reagents we've produced
	var/list/reagents_limit = list() // stores limited reagents

/obj/item/reagent_containers/borghypo/refill_hypo(mob/living/silicon/robot/user, quick = FALSE)
	if(quick) // gives us a hypo full of reagents no matter what
		for(var/reagent as anything in reagent_ids)
			if(reagent_ids[reagent] < volume)
				var/reagents_to_add = min(volume - reagent_ids[reagent], volume)
				reagent_ids[reagent] = (reagent_ids[reagent] || 0) + reagents_to_add
				reagents_produced[reagent] = (reagents_produced[reagent] || 0) + reagents_to_add
		return
	if(istype(user) && user.cell && user.cell.use(charge_cost)) // we are a robot, we have a cell and enough charge? let's refill now
		if(charge_tick)
			charge_tick = 0
		for(var/reagent as anything in reagent_ids)
			if(reagent_ids[reagent] < volume)
				var/produced = (reagents_produced[reagent] || 0)
				var/produced_limit = (reagents_limit[reagent] || INFINITY)
				var/reagents_to_add = min(
					volume - reagent_ids[reagent],
					BORGHYPO_REFILL_VALUE,
					max(produced_limit - produced, 0)
				)
				if(reagents_to_add > 0) // better safe than sorry
					reagent_ids[reagent] = (reagent_ids[reagent] || 0) + reagents_to_add // in case if it's null somehow, set it to 0
					reagents_produced[reagent] = produced + reagents_to_add

/obj/item/reagent_containers/borghypo/should_refill()
	if(cyborg.admin_spawned && length(reagents_limit)) // adminbuse
		reagents_limit = list()
	for(var/reagent as anything in reagent_ids)
		var/reagent_volume = reagent_ids[reagent] || 0
		var/produced = reagents_produced[reagent] || 0
		var/produced_limit = reagents_limit[reagent]

		if(reagent_volume < volume && (isnull(produced_limit) || produced < produced_limit))
			return TRUE
	return FALSE

/obj/item/reagent_containers/borghypo/syndicate
	reagents_limit = list("syndicate_nanites" = SYNDICATE_NANITES_LIMIT)

/obj/item/reagent_containers/borghypo/examine(mob/user)
	. = ..()
	for(var/reagent in reagents_limit)
		var/datum/reagent/reagent_name = GLOB.chemical_reagents_list[reagent]
		. += span_notice("It has produced <b>[reagents_produced[reagent]]</b> / <b>[reagents_limit[reagent]]</b> units of <b>[reagent_name]</b>!")

#undef BORGHYPO_REFILL_VALUE
#undef SYNDICATE_NANITES_LIMIT

/obj/item/reagent_containers/hypospray/autoinjector/custom
	desc = "A rapid and safe way to inject chemicals into humanoids. This one have extended capacity."
	amount_per_transfer_from_this = 20
	volume = 20

/obj/item/reagent_containers/hypospray/autoinjector/custom/brute
	name = "brute medipen"
	desc = "A rapid and safe way to tend wounds and deal with minor pain even through spacesuits. Contains bicaridine and salicylic acid."
	list_reagents = list("bicaridine" = 15, "sal_acid" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/custom/burn
	name = "burn medipen"
	desc = "A rapid and safe way to tend burns and regulate body's temperature even through spacesuits. Contains kelotane and menthol."
	list_reagents = list("kelotane" = 15, "menthol" = 5)

/obj/item/reagent_containers/hypospray/autoinjector/custom/critical
	name = "critical state medipen"
	desc = "A rapid and safe way to stabilize patient from passing out even through spacesuits. Contains ephedrine and perfluorodecalin. <br><span class='boldwarning'>WARNING: Do not inject more than one pen in quick succession.</span>"
	list_reagents = list("ephedrine" = 16, "perfluorodecalin" = 4)

/obj/item/storage/firstaid/spacer
	name = "spacer first-aid kit"
	desc = "A medical kit designed for use in space. Contains medipens for both brute damage and burn damage. Also contains an critical state medipen for emergency use and a health analyzer."
	icon_state = "firstaid"

/obj/item/storage/firstaid/spacer/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/critical(src)
	new /obj/item/healthanalyzer(src)
