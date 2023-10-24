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

/obj/item/ammo_box/magazine/beretta
	name = "beretta rubber 9x19mm magazine"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "berettar"
	multi_sprite_step = 2
	ammo_type = /obj/item/ammo_casing/beretta/mmrub919
	max_ammo = 10
	caliber = "919mm"

/obj/item/ammo_box/magazine/beretta/mm919
	name = "beretta lethal 9x19mm magazine"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "berettal"
	ammo_type = /obj/item/ammo_casing/beretta/mm919
	max_ammo = 10

/obj/item/ammo_box/magazine/beretta/mmbsp919
	name = "beretta bluespace 9x19mm magazine"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "berettab"
	ammo_type = /obj/item/ammo_casing/beretta/mmbsp919
	max_ammo = 10

/obj/item/ammo_box/magazine/beretta/mmap919
	name = "beretta armor-piercing 9x19mm magazine"
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "berettaap"
	ammo_type = /obj/item/ammo_casing/beretta/mmap919
	max_ammo = 10

/obj/item/ammo_casing/beretta/mmbsp919
	caliber = "919mm"
	name = "9x19mm bluespace bullet casing"
	desc = "A 9x19mm bluespace bullet casing."
	projectile_type = /obj/item/projectile/bullet/mmbsp919

/obj/item/projectile/bullet/mmbsp919
	name = "9x19 bluespace bullet"
	damage = 18
	speed = 0.2

/obj/item/ammo_casing/beretta/mmap919
	name = "9x19mm armor-piercing bullet casing"
	desc = "A 9x19 armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/mmap919

/obj/item/projectile/bullet/mmap919
	name = "9x19mm armor-piercing bullet"
	damage = 18
	armour_penetration_percentage = 35
	armour_penetration_flat = 15

/obj/item/ammo_casing/beretta/mmrub919
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "casingmm919"
	projectile_type = /obj/item/projectile/bullet/weakbullet4

/obj/item/ammo_casing/beretta/mm919
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "casingmm919"
	projectile_type = /obj/item/projectile/bullet/weakbullet3

/obj/item/ammo_box/beretta/mm919
	name = "box of lethal 9x19mm cartridges"
	desc = "Contains up to 20 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mm919
	max_ammo = 20
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "9mm_box"

/obj/item/ammo_box/beretta/mmrub919
	name = "box of rubber 9x19mm cartridges"
	desc = "Contains up to 30 rubber 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmrub919
	max_ammo = 30
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "9mmr_box"

/obj/item/ammo_box/beretta/mmbsp919
	name = "box of bluespace 9x19mm cartridges"
	desc = "Contains up to 20 bluespace 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmbsp919
	max_ammo = 20
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "9mmb_box"

/obj/item/ammo_box/beretta/mmap919
	name = "box of armor-penetration 9x19mm cartridges"
	desc = "Contains up to 20 armor-penetration 9x19mm cartridges."
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/beretta/mmap919
	max_ammo = 20
	icon = 'modular_ss220/objects/icons/ammo.dmi'
	icon_state = "9mmap_box"

/datum/supply_packs/security/armory/beretta
	name = "Beretta M9 Crate"
	contains = list(/obj/item/gun/projectile/automatic/pistol/beretta,
					/obj/item/gun/projectile/automatic/pistol/beretta)
	cost = 450
	containername = "beretta m9 pack"

/datum/supply_packs/security/armory/berettarubberammo
	name = "Beretta M9 Rubber Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmrub919,
					/obj/item/ammo_box/beretta/mmrub919,
					/obj/item/ammo_box/beretta/mmrub919,
					/obj/item/ammo_box/beretta/mmrub919,
					/obj/item/ammo_box/magazine/beretta,
					/obj/item/ammo_box/magazine/beretta)
	cost = 350
	containername = "beretta rubber ammunition pack"

/datum/supply_packs/security/armory/berettalethalammo
	name = "Beretta M9 Lethal Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mm919,
					/obj/item/ammo_box/beretta/mm919,
					/obj/item/ammo_box/beretta/mm919,
					/obj/item/ammo_box/beretta/mm919,
					/obj/item/ammo_box/magazine/beretta/mm919,
					/obj/item/ammo_box/magazine/beretta/mm919)
	cost = 400
	containername = "beretta lethal ammunition pack"

/datum/supply_packs/security/armory/berettaexperimentalammo
	name = "Beretta M9 Bluespace Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmbsp919,
					/obj/item/ammo_box/beretta/mmbsp919,
					/obj/item/ammo_box/beretta/mmbsp919,
					/obj/item/ammo_box/beretta/mmbsp919,
					/obj/item/ammo_box/magazine/beretta/mmbsp919,
					/obj/item/ammo_box/magazine/beretta/mmbsp919)
	cost = 500
	containername = "beretta bluespace ammunition pack"

/datum/supply_packs/security/armory/berettaarmorpiercingammo
	name = "Beretta M9 Armor-piercing Ammunition Crate"
	contains = list(/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/beretta/mmap919,
					/obj/item/ammo_box/magazine/beretta/mmap919,
					/obj/item/ammo_box/magazine/beretta/mmap919)
	cost = 500
	containername = "beretta AP ammunition pack"

/datum/design/box_beretta/lethal
	name = "Beretta M9 Lethal Ammo Box (9mm)"
	desc = "A box of 20 lethal rounds for Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 2, "materials" = 1)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 6000, MAT_SILVER = 600)
	build_path = /obj/item/ammo_box/beretta/mm919
	category = list("Weapons")

/datum/design/box_beretta/ap
	name = "Beretta M9 AP Ammo Box (9mm)"
	desc = "A box of 20 armor-piercing rounds for Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 3, "materials" = 2)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 6000, MAT_SILVER = 600, MAT_GLASS = 1000)
	build_path = /obj/item/ammo_box/beretta/mmap919
	category = list("Weapons")

/datum/design/box_beretta/bluespace
	name = "Beretta M9 Bluespace Ammo Box (9mm)"
	desc = "A box of 20 high velocity bluespace rounds for Beretta M9"
	id = "box_beretta"
	req_tech = list("combat" = 3, "materials" = 2, "bluespace" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_SILVER = 600, MAT_BLUESPACE = 5000)
	build_path = /obj/item/ammo_box/beretta/mmbsp919
	category = list("Weapons")

