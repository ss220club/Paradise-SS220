/datum/species/monkey/kidan_nymph
	name = "kidan nymph"
	name_plural = "kidan nymph"
	icobase = 'modular_ss220/objects/kidan_nymph.dmi'
	tail = ""
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_BUG
	bodyflags = BALD | SHAVED
	greater_form = /datum/species/kidan
	default_language = "Chittin"
	butt_sprite = "kidan"
	dietflags = DIET_HERB
	is_small = 0.5
	tox_mod = 3 // Die. Terrible creatures. Die.
	total_health = 50 // Маленький беззащитный кидан
	brute_mod = 2 // Без хитина не окрепший
	burn_mod = 2 // Без хитина не окрепший
	flesh_color = "#ffd79a"
	blood_color = "#e2b679"

	has_organ = list(
		"heart"   = /obj/item/organ/internal/heart/kidan,
		"lungs"   = /obj/item/organ/internal/lungs/kidan,
		"liver"   = /obj/item/organ/internal/liver/kidan,
		"kidneys"   = /obj/item/organ/internal/kidneys/kidan,
		"brain"   = /obj/item/organ/internal/brain/kidan,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes"     = /obj/item/organ/internal/eyes/kidan,
		"lantern"  = /obj/item/organ/internal/lantern
	)

	allowed_consumed_mobs = list(/mob/living/basic/diona_nymph)

/obj/item/food/monkeycube/kidan_nymphcube
	name = "kidan nymph cube"
	monkey_type = /datum/species/monkey/kidan_nymph

/datum/design/kidan_nymphcube
	name = "Kidan nymph cube"
	id = "kncube"
	build_type = BIOGENERATOR
	materials = list(MAT_BIOMASS = 250)
	build_path = /obj/item/food/monkeycube/kidan_nymphcube
	category = list("initial", "Food")

/obj/item/storage/box/monkeycubes/kidan_nymph_cubes
	name = "kidan nymph cube box"
	desc = "Kidan cubes from the people of the TSF. Just add water!"
	icon_state = "kidan_nymph_box"
	monkey_cube_type = /obj/item/food/monkeycube/kidan_nymphcube
