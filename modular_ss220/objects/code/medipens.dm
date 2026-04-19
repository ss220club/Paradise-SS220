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
	icon = 'modular_ss220/objects/icons/medipens.dmi'
	icon_state = "medipen"
	desc = "A rapid and safe way to inject chemicals into humanoids. This one have extended capacity."
	amount_per_transfer_from_this = 30
	volume = 30
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
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/burn
	name = "burn medipen"
	icon_state = "medipen_org"
	desc = "A rapid and safe way to tend burns and regulate body's temperature even through spacesuits. Contains kelotane and menthol."
	list_reagents = list("kelotane" = 10, "menthol" = 3)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/critical
	name = "critical state medipen"
	icon_state = "medipen_blu"
	desc = "A rapid and safe way to stabilize patient from passing out even through spacesuits. Contains epinephrine and salbutamol."
	list_reagents = list("epinephrine" = 10, "salbutamol" = 5)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/radiation
	name = "anti-radiation medipen"
	icon_state = "medipen_rad"
	desc = "A rapid and safe way to counter the effects of irradiation even through spacesuits. Contains potassium iodide."
	list_reagents = list("potass_iodide" = 15)
	instant_application = FALSE

/obj/item/reagent_containers/hypospray/autoinjector/custom/toxin
	name = "anti-toxin medipen"
	icon_state = "medipen_grn"
	desc = "A rapid and safe way to counter the effects of poisoning even through spacesuits. Contains charcoal."
	list_reagents = list("charcoal" = 20)
	instant_application = FALSE

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
/obj/item/storage/pill_bottle/medipen_case
	var/allow_rapid_intake = TRUE

/obj/item/storage/pill_bottle/medipen_case/attack__legacy__attackchain(mob/M, mob/user)
	if(!allow_rapid_intake)
		return FALSE

	return ..()

/obj/item/storage/pill_bottle/medipen_case
	name = "autoinjector case"
	desc = "It's a container for storing medical autoinjectors."
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "medipen_case"
	belt_icon = "patch_pack"
	use_sound = 'modular_ss220/aesthetics_sounds/sound/handling/plasticbox_open.ogg'
	can_hold = list(/obj/item/reagent_containers/hypospray/autoinjector)
	storage_slots = 10
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

/obj/machinery/smartfridge/medbay/Initialize(mapload)
	. = ..()
	accepted_items_typecache = typecacheof(list(
		/obj/item/reagent_containers/hypospray/autoinjector,
	))

/obj/machinery/economy/vending/medical/Initialize(mapload)
	products += list(/obj/item/storage/pill_bottle/medipen_case = 1,)
	return ..()
