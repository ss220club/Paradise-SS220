// Base heavy revolver
/obj/item/gun/projectile/revolver/reclinable
	var/snapback_sound = 'modular_ss220/objects/sound/weapons/cylinder/snapback_rsh12.ogg'
	var/reclined_sound = 'modular_ss220/objects/sound/weapons/cylinder/reclined_rsh12.ogg'
	var/dry_fire_sound = 'sound/weapons/empty.ogg'
	var/reclined = FALSE

/obj/item/gun/projectile/revolver/reclinable/attack_self(mob/living/user)
	reclined = !reclined
	playsound(user, reclined ? reclined_sound : snapback_sound, 50, 1)
	update_icon()

	if(reclined)
		return ..()

/obj/item/gun/projectile/revolver/reclinable/update_icon_state()
	icon_state = initial(icon_state) + (reclined ? "_reclined" : "")

/obj/item/gun/projectile/revolver/reclinable/attackby(obj/item/A, mob/user, params)
	if(!reclined)
		return
	return ..()

/obj/item/gun/projectile/revolver/reclinable/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if (!reclined)
		return ..()

	to_chat(user, "<span class='danger'>*click*</span>")
	playsound(user, dry_fire_sound, 100, 1)

// Colt Anaconda .44

/obj/item/gun/projectile/revolver/reclinable/anaconda
	name = "Анаконда"
	desc = "Крупнокалиберный револьвер двадцатого века. Несмотря на то, что оружие хранилось в хороших условиях, старина даёт о себе знать."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/d44
	lefthand_file = 'modular_ss220/objects/icons/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/guns_righthand.dmi'
	icon = 'modular_ss220/objects/icons/guns.dmi'
	icon_state = "anaconda"
	item_state = "anaconda"
	fire_sound = 'modular_ss220/objects/sound/weapons/gunshots/gunshot_anaconda.ogg'

/obj/item/gun/projectile/revolver/reclinable/anaconda/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box/box_d44))
		return
	return ..()

/obj/item/ammo_box/magazine/internal/cylinder/d44
	name = ".44 revolver cylinder"
	ammo_type = /obj/item/ammo_casing/d44
	caliber = "44"
	max_ammo = 6

/obj/item/ammo_casing/d44
	desc = "A .44 bullet casing."
	caliber = "44"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "casing44"
	projectile_type = /obj/item/projectile/bullet/d44
	muzzle_flash_strength = MUZZLE_FLASH_STRENGTH_NORMAL
	muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG

/obj/item/projectile/bullet/d44
	name = ".44 bullet"
	icon_state = "bullet"
	damage = 50
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	spread = 20

/obj/item/ammo_box/speed_loader_d44
	name = "speed loader (.44)"
	desc = "Designed to quickly reload revolvers."
	ammo_type = /obj/item/ammo_casing/d44
	max_ammo = 6
	multi_sprite_step = 1
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "44"

/obj/item/ammo_box/box_d44
	name = "ammo box (.44)"
	desc = "Contains up to 24 .44 cartridges, intended to either be inserted into a speed loader or into the gun manually."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/d44
	max_ammo = 24
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "44_box"

/obj/structure/displaycase/hos
	alert = TRUE
	start_showpiece_type = /obj/item/gun/projectile/revolver/reclinable/anaconda
	req_access = list(ACCESS_HOS)

// RSH-12 12.7

/obj/item/gun/projectile/revolver/reclinable/rsh12
	name = "РШ-12"
	desc = "Тяжёлый револьвер винтовочного калибра с откидным стволом. По слухам, всё ещё находится на вооружении у СССП."
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rsh12
	lefthand_file = 'modular_ss220/objects/icons/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/guns_righthand.dmi'
	icon = 'modular_ss220/objects/icons/guns.dmi'
	icon_state = "rsh12"
	item_state = "rsh12"
	fire_sound = 'modular_ss220/objects/sound/weapons/gunshots/gunshot_rsh12.ogg'

/obj/item/gun/projectile/revolver/reclinable/rsh12/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box/box_mm127))
		return
	return ..()

/obj/item/ammo_box/magazine/internal/cylinder/rsh12
	name = "12.7mm revolver cylinder"
	ammo_type = /obj/item/ammo_casing/mm127
	caliber = "127mm"
	max_ammo = 5

/obj/item/ammo_casing/mm127
	desc = "A 12.7mm bullet casing."
	caliber = "127mm"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "casing127mm"
	projectile_type = /obj/item/projectile/bullet/mm127
	muzzle_flash_strength = MUZZLE_FLASH_RANGE_STRONG
	muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG

/obj/item/projectile/bullet/mm127
	name = "127mm bullet"
	icon_state = "bullet"
	damage = 75
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/item/projectile/bullet/mm127/on_hit(atom/target, blocked, hit_zone)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	if(L.move_resist == INFINITY)
		return
	var/atom/throw_target = get_edge_target_turf(L, get_dir(src, get_step_away(L, starting)))
	L.throw_at(throw_target, 2, 2)

/obj/item/ammo_box/speed_loader_mm127
	name = "speed loader (12.7mm)"
	desc = "Designed to quickly reload... is it a revolver speedloader with rifle cartidges in it?"
	ammo_type = /obj/item/ammo_casing/mm127
	max_ammo = 5
	multi_sprite_step = 1
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "mm127"

/obj/item/ammo_box/box_mm127
	name = "ammo box (12.7)"
	desc = "Contains up to 100 12.7mm cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/mm127
	max_ammo = 100
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "mm127_box"

//Beretta M9//

/obj/item/gun/projectile/automatic/pistol/beretta
	name = "Беретта M9"
	desc = "Один из самых распространенных и узнаваемых пистолетов во вселенной. Старая добрая классика."
	icon = 'modular_ss220/objects/icons/guns.dmi'
	icon_state = "beretta"
	item_state = "beretta"
	mag_type = /obj/item/ammo_box/magazine/beretta
	fire_sound = 'modular_ss220/objects/sound/weapons/gunshots/beretta_shot.ogg'
	can_suppress = FALSE
	actions_types = list()

/obj/item/gun/projectile/automatic/pistol/update_icon_state()
	..()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
	return

/obj/item/ammo_box/magazine/beretta
	name = "rubber handgun magazine (9mm rubber)"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "berettar-10"
	base_icon_state = "berettar"
	ammo_type = /obj/item/ammo_casing/mmr919
	max_ammo = 10
	caliber = "919mmr"

/obj/item/ammo_box/magazine/beretta/update_icon_state()
	..()
	icon_state = "[base_icon_state]-[round(ammo_count(),2)]"

/obj/item/ammo_box/magazine/beretta/lethal
	name = "standard handgun magazine (9mm)"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "berettal-10"
	base_icon_state = "berettal"
	ammo_type = /obj/item/ammo_casing/mm919
	max_ammo = 10
	caliber = "919mm"

/obj/item/ammo_box/magazine/beretta/lethal/update_icon_state()
	..()
	icon_state = "[base_icon_state]-[round(ammo_count(),2)]"

/obj/item/ammo_casing/mmr919
	caliber = "919mmr"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "casingmm919"
	projectile_type = /obj/item/projectile/bullet/weakbullet3

/obj/item/ammo_casing/mm919
	caliber = "919mm"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "casingmm919"
	projectile_type = /obj/item/projectile/bullet/weakbullet4

/obj/item/ammo_box/mm919
	name = "box of lethal ammo (9x19mm)"
	desc = "Contains up to 20 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/mm919
	max_ammo = 20
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "9mm_box"

/obj/item/ammo_box/mmr919
	name = "box of rubber ammo (9x19mm)"
	desc = "Contains up to 20 rubber 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/mmr919
	max_ammo = 20
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "9mmr_box"

/datum/supply_packs/security/armory/beretta
	name = "Beretta M9 Crate"
	contains = list(/obj/item/gun/projectile/automatic/pistol/beretta,
					/obj/item/gun/projectile/automatic/pistol/beretta)
	cost = 450
	containername = "beretta m9 pack"

/datum/supply_packs/security/armory/berettaammo
	name = "Beretta M9 Rubber Ammunition Crate"
	contains = list(/obj/item/ammo_box/mmr919,
					/obj/item/ammo_box/mmr919,
					/obj/item/ammo_box/magazine/beretta,
					/obj/item/ammo_box/magazine/beretta)
	cost = 400
	containername = "beretta ammunition pack"

//Beretta M9 Mags

/datum/design/mag_beretta
	name = "Beretta M9 Lethal Magazine (9mm)"
	desc = "A 10 round magazine for the out of date Beretta M9"
	id = "mag_beretta"
	req_tech = list("combat" = 1, "materials" = 1)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000)
	build_path = /obj/item/ammo_box/magazine/beretta/lethal
	category = list("Weapons")

/datum/design/box_beretta
	name = "Beretta M9 Lethal Ammo Box (9mm)"
	desc = "A box of 20 rounds for the out of date Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 1, "materials" = 1)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000)
	build_path = /obj/item/ammo_box/mm919
	category = list("Weapons")
