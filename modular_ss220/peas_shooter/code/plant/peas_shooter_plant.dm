/obj/item/seeds/soya/peas_shooter
	name = "pack of peas shooter seeds"
	desc = "These seeds grow into peas shooter"
	icon = 'modular_ss220/peas_shooter/icons/seeds/seed_soybean.dmi'
	icon_state = "seed-soybean"
	species = "peas shooter"
	plantname = "Peas Shooter Plants"
	icon_harvest = "soybean-harvest"
	product = /obj/item/gun/projectile/revolver/peas_shooter
	rarity = 20
	reagents_add = list("plantmatter" = 0.2, "vitamin" = 0.4)
	mutatelist = list()
	potency = 20
	yield = 1
	production = 10
	genes = list()

/obj/item/seeds/soya/Initialize(mapload)
    . = ..()
	mutatelist += list(/obj/item/seeds/soya/peas_shooter,)

