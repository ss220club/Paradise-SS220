/obj/projectile
	///If TRUE, hit mobs even if they're on the floor and not our target
	var/hit_prone_targets = TRUE
	speed = 0.70

/atom/handle_ricochet(obj/projectile/ricocheting_projectile)
	. = ..()
	if(.)
		// here is confirmed ricochet - force projectile to hit targets
		ricocheting_projectile.hit_prone_targets = TRUE

/obj/item/ammo_casing/ready_proj(atom/target, mob/living/user, quiet, zone_override, atom/firer_source_atom)
	. = ..()
	if(!BB)
		return
	BB.hit_prone_targets = user.a_intent != INTENT_HELP

/mob/living/carbon/human/projectile_hit_check(obj/projectile/P)
	if(stat == CONSCIOUS)
		return !P.hit_prone_targets && !density
	return !density

/obj/projectile/beam/player_laser
	damage = 24
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	impact_type = /obj/effect/projectile/impact/laser
	impact_effect_type = null
	hitscan_light_intensity = 4
	hitscan_light_color_override = LIGHT_COLOR_FIRE
	muzzle_flash_intensity = 5
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_FIRE
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = LIGHT_COLOR_FIRE
	forcedodge = 0

/obj/projectile/beam/disabler
	damage = 20
	icon_state = "ice_2"

/obj/projectile/beam/laser
	icon_state = "laser_alt"
