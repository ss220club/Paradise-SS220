// MARK: REAGENT CONTAINERS REBALANCING
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

/obj/item/reagent_containers/applicator/brute/syndi
	name = "advanced brute auto-mender"
	desc = "A small electronic device designed to topically apply healing chemicals. This one can penetrate thick suits."
	ignore_flags = TRUE

/obj/item/reagent_containers/applicator/burn/syndi
	name = "advanced burn auto-mender"
	desc = "A small electronic device designed to topically apply healing chemicals. This one can penetrate thick suits."
	ignore_flags = TRUE

/obj/item/reagent_containers/applicator/dual/syndi
	name = "advanced dual auto-mender"
	desc = "A small electronic device designed to topically apply healing chemicals. This one can penetrate thick suits."

/obj/item/reagent_containers/patch/apply(mob/living/carbon/C, mob/user)
	if(!C.can_inject(user, TRUE))
		return
	return ..()

/obj/item/reagent_containers/hypospray
	var/instant_application = TRUE

/obj/item/reagent_containers/hypospray/apply(mob/living/carbon/C, mob/user)
	if(user != C)
		if(!instant_application)
			C.visible_message(span_warning("[user] пытается вколоть [src] в [C]."))
			if(!do_after(user, 3 SECONDS, needhand = TRUE, target = C, progress = TRUE))
				return

		C.forceFedAttackLog(src, user)
		C.visible_message(span_warning("[user] вкалывает [src] в [C]."))
	return ..()

// MARK: CUSTOM MEDIPENS
/obj/item/reagent_containers/hypospray/autoinjector/custom
	icon = 'modular_ss220/aesthetics/medipens/icon/medipens.dmi'
	icon_state = "medipen"
	desc = "A rapid and safe way to inject chemicals into humanoids. This one have extended capacity."
	amount_per_transfer_from_this = 20
	volume = 20
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/update_icon_state()
	icon_state = replacetext(icon_state, regex(@"\d+$"), "")
	if(reagents.total_volume <= 0)
		icon_state = "[icon_state]0"

/obj/item/reagent_containers/hypospray/autoinjector/custom/brute
	name = "brute medipen"
	icon_state = "medipen_red"
	desc = "A rapid and safe way to tend wounds and deal with minor pain even through spacesuits. Contains bicaridine and salicylic acid."
	list_reagents = list("bicaridine" = 10, "sal_acid" = 3)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/burn
	name = "burn medipen"
	icon_state = "medipen_org"
	desc = "A rapid and safe way to tend burns and regulate body's temperature even through spacesuits. Contains kelotane and menthol."
	list_reagents = list("kelotane" = 10, "menthol" = 3)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/critical
	name = "critical state medipen"
	icon_state = "medipen_blu"
	desc = "A rapid and safe way to stabilize patient from passing out even through spacesuits. Contains epinephrine and salbutamol."
	list_reagents = list("epinephrine" = 10, "salbutamol" = 5)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/radiation
	name = "anti-radiation medipen"
	icon_state = "medipen_rad"
	desc = "A rapid and safe way to counter the effects of irradiation even through spacesuits. Contains potassium iodide."
	list_reagents = list("potass_iodide" = 15)
	instant_application = TRUE

/obj/item/reagent_containers/hypospray/autoinjector/custom/toxin
	name = "anti-toxin medipen"
	icon_state = "medipen_grn"
	desc = "A rapid and safe way to counter the effects of poisoning even through spacesuits. Contains potassium iodide."
	list_reagents = list("charcoal" = 20)
	instant_application = TRUE

// MARK: SPACER FIRST-AID KIT
/obj/item/storage/firstaid/spacer
	name = "spacer first-aid kit"
	desc = "A medical kit designed for use in vacuum while wearing EVA and MOD suits. Contains medipens for both brute and burn damage. Also contains an critical state medipen for emergency use and a health analyzer."
	icon_state = "firstaid_spacer"
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	lefthand_file = 'modular_ss220/aesthetics/boxes/icons/boxes_lefthand.dmi'
	righthand_file = 'modular_ss220/aesthetics/boxes/icons/boxes_righthand.dmi'

/obj/item/storage/firstaid/spacer/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/brute(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/burn(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/critical(src)
	new /obj/item/healthanalyzer(src)

/datum/supply_packs/medical/spacerkits
	name = "Spacer First-Aid Kits Crate"
	contains = list(/obj/item/storage/firstaid/spacer,
					/obj/item/storage/firstaid/spacer,
					/obj/item/storage/firstaid/spacer,
					/obj/item/storage/firstaid/spacer
					)
	cost = 400
	containername = "spacer first-aid kits crate"

/obj/machinery/suit_storage_unit/expedition
	storage_type = /obj/item/storage/firstaid/spacer

/obj/machinery/suit_storage_unit/security
	storage_type = /obj/item/storage/firstaid/spacer

// MARK: MEDIPEN CASE
/obj/item/storage/pill_bottle
	var/allow_rapid_intake = TRUE

/obj/item/storage/pill_bottle/attack__legacy__attackchain(mob/M, mob/user)
	if(!allow_rapid_intake)
		return
	return ..()

/obj/item/storage/pill_bottle/medipen_case
	name = "autoinjector case"
	desc = "It's a container for storing medical autoinjectors."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_case"
	belt_icon = "patch_pack"
	use_sound = 'modular_ss220/aesthetics_sounds/sound/handling/plasticbox_open.ogg'
	can_hold = list(/obj/item/reagent_containers/hypospray/autoinjector)
	storage_slots = 5
	max_combined_w_class = 5
	display_contents_with_number = FALSE
	wrapper_state = "medipen_case_wrap"
	allow_rapid_intake = FALSE

/datum/design/medipencase
	name = "Autoinjector Case"
	id = "medipencase"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 160, MAT_GLASS = 40)
	build_path = /obj/item/storage/pill_bottle/medipen_case
	category = list("initial", "Medical")

/obj/item/storage/box/medipen_cases
	name = "box of autoinjector cases"
	desc = "It has pictures of autoinjector case on its front."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_box"

/obj/item/storage/box/medipen_cases/populate_contents()
	for(var/I in 1 to 7)
		var/obj/item/storage/pill_bottle/P = new /obj/item/storage/pill_bottle/medipen_case(src)
		P.apply_wrapper_color(I)

/obj/item/storage/pill_bottle/medipen_case/radiation
	name = "anti-radiation medipen case"
	wrapper_color = COLOR_ORANGE

/obj/item/storage/pill_bottle/medipen_case/radiation/populate_contents()
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/toxin(src)
	new /obj/item/reagent_containers/hypospray/autoinjector/custom/radiation(src)
