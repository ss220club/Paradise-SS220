//Beretta M9//

/obj/item/gun/projectile/automatic/pistol/beretta
	name = "Беретта M9"
	desc = "Один из самых распространенных и узнаваемых пистолетов во вселенной. Старая добрая классика."
	icon = 'modular_ss220/beretta/icons/guns.dmi'
	icon_state = "beretta"
	item_state = "beretta"
	mag_type = /obj/item/ammo_box/magazine/beretta/rubber
	fire_sound = 'modular_ss220/beretta/sound/weapons/gunshots/beretta_shot.ogg'
	can_suppress = FALSE
	actions_types = list()

/obj/item/gun/projectile/automatic/pistol/update_icon_state()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
	return

/obj/item/ammo_box/magazine/beretta/rubber
	name = "rubber handgun magazine (9mm rubber)"
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "berettar-10"
	base_icon_state = "berettar"
	ammo_type = /obj/item/ammo_casing/beretta/mmrub919
	max_ammo = 10
	caliber = "919mmr"

/obj/item/ammo_box/magazine/beretta/update_icon_state()
	..()
	icon_state = "[base_icon_state]-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/beretta/lethal
	name = "standard handgun magazine (9mm)"
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "berettal-10"
	base_icon_state = "berettal"
	ammo_type = /obj/item/ammo_casing/beretta/mmleth919
	max_ammo = 10
	caliber = "919mm"

/obj/item/ammo_box/magazine/beretta/lethal/update_icon_state()
	..()
	icon_state = "[base_icon_state]-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/beretta/bluespace
    name = "experimental handgun magazine (9mm)"
    icon = 'modular_ss220/beretta/icons/ammo.dmi'
    icon_state = "berettab-10"
    base_icon_state = "berettab"
    ammo_type = /obj/item/ammo_casing/beretta/mmbsp919
    max_ammo = 10
    caliber = "919bmm"

/obj/item/ammo_box/magazine/beretta/bluespace/update_icon_state()
	..()
	icon_state = "[base_icon_state]-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/beretta/ap
    name = "armor-piercing handgun magazine (9mm)"
    icon = 'modular_ss220/beretta/icons/ammo.dmi'
    icon_state = "berettaap-10"
    base_icon_state = "berettaap"
    ammo_type = /obj/item/ammo_casing/beretta/mmap919
    max_ammo = 10
    caliber = "919bmm"

/obj/item/ammo_box/magazine/beretta/ap/update_icon_state()
	..()
	icon_state = "[base_icon_state]-[round(ammo_count(),2)]"

/obj/item/ammo_casing/beretta/mmbsp919
	name = "9x19mm bluespace bullet casing"
	desc = "A 9x19mm bluespace bullet casing."
	projectile_type = /obj/item/projectile/bullet/beretta/bluespace

/obj/item/projectile/bullet/beretta/bluespace
	name = "9x19 bluespace bullet"
	damage = 18
	speed = 0.2

/obj/item/ammo_casing/beretta/mmap919
	name = "9x19mm armor-piercing bullet casing"
	desc = "A .38 armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/beretta/ap

/obj/item/projectile/bullet/beretta/ap
	name = "9x19mm armor-piercing bullet"
	damage = 18
	armour_penetration_percentage = 50
	armour_penetration_flat = 25

/obj/item/ammo_casing/beretta/mmrub919
	caliber = "919mmr"
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "casingmm919"
	projectile_type = /obj/item/projectile/bullet/weakbullet4

/obj/item/ammo_casing/beretta/mmleth919
	caliber = "919mm"
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "casingmm919"
	projectile_type = /obj/item/projectile/bullet/weakbullet3

/obj/item/ammo_box/beretta/mmlethal919
	name = "box of lethal ammo (9x19mm)"
	desc = "Contains up to 20 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmleth919
	max_ammo = 20
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "9mm_box"

/obj/item/ammo_box/beretta/mmrubber919
	name = "box of rubber ammo (9x19mm)"
	desc = "Contains up to 20 rubber 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmrub919
	max_ammo = 30
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "9mmr_box"

/obj/item/ammo_box/beretta/mmbluespace919
	name = "box of experimental ammo (9x19mm)"
	desc = "Contains up to 20 experimental 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmbsp919
	max_ammo = 20
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "9mmb_box"

/obj/item/ammo_box/beretta/mmap919
	name = "box of experimental ammo (9x19mm)"
	desc = "Contains up to 20 experimental 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmap919
	max_ammo = 20
	icon = 'modular_ss220/beretta/icons/ammo.dmi'
	icon_state = "9mmap_box"

/datum/supply_packs/security/armory/beretta
	name = "Beretta M9 Crate"
	contains = list(/obj/item/gun/projectile/automatic/pistol/beretta,
					/obj/item/gun/projectile/automatic/pistol/beretta)
	cost = 450
	containername = "beretta m9 pack"

/datum/supply_packs/security/armory/berettarubberammo
	name = "Beretta M9 Rubber Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmrubber919,
					/obj/item/ammo_box/beretta/mmrubber919,
					/obj/item/ammo_box/magazine/beretta/rubber,
					/obj/item/ammo_box/magazine/beretta/rubber,
					/obj/item/ammo_box/magazine/beretta/rubber,
					/obj/item/ammo_box/magazine/beretta/rubber)
	cost = 350
	containername = "beretta rubber ammunition pack"

/datum/supply_packs/security/armory/berettalethalammo
	name = "Beretta M9 Lethal Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmlethal919,
					/obj/item/ammo_box/beretta/mmlethal919,
					/obj/item/ammo_box/magazine/beretta/lethal,
					/obj/item/ammo_box/magazine/beretta/lethal,
					/obj/item/ammo_box/magazine/beretta/lethal,
					/obj/item/ammo_box/magazine/beretta/lethal)
	cost = 400
	containername = "beretta lethal ammunition pack"

/datum/supply_packs/security/armory/berettaexperimentalammo
	name = "Beretta M9 Experimental Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmbluespace919,
					/obj/item/ammo_box/beretta/mmbluespace919,
					/obj/item/ammo_box/beretta/mmbluespace919,
					/obj/item/ammo_box/beretta/mmbluespace919,
					/obj/item/ammo_box/magazine/beretta/bluespace,
					/obj/item/ammo_box/magazine/beretta/bluespace)
	cost = 500
	containername = "beretta experimental ammunition pack"

/datum/supply_packs/security/armory/berettaarmorpiercingammo
	name = "Beretta M9 Armor-piercing Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/magazine/beretta/ap,
					/obj/item/ammo_box/magazine/beretta/ap)
	cost = 500
	containername = "beretta AP ammunition pack"

/datum/design/box_beretta/lethal
	name = "Beretta M9 Lethal Ammo Box (9mm)"
	desc = "A box of 20 lethal rounds for Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 2, "materials" = 1)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000)
	build_path = /obj/item/ammo_box/beretta/mmlethal919
	category = list("Weapons")

/datum/design/box_beretta/ap
	name = "Beretta M9 AP Ammo Box (9mm)"
	desc = "A box of 20 armor-piercing rounds for Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 3, "materials" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_SILVER = 3000)
	build_path = /obj/item/ammo_box/beretta/mmap919
	category = list("Weapons")

/datum/design/box_beretta/bluespace
	name = "Beretta M9 Experimental Ammo Box (9mm)"
	desc = "A box of 20 high velocity bluespace rounds for Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 3, "materials" = 2, "bluespace" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_BLUESPACE = 500)
	build_path = /obj/item/ammo_box/beretta/mmbluespace919
	category = list("Weapons")
