#define HIT_MISSILE_EFFECT_DURATION 10 SECONDS

/obj/effect/proc_holder/spell/projectile/beer_missile
	name = "Beer Missile"
	desc = "This spell fires several, slow moving, magic beer bottles at nearby targets"
	school = "evocation"
	base_cooldown = 60
	clothes_req = FALSE
	invocation_type = "shout"
	cooldown_min = 60 //35 deciseconds reduction per rank
	proj_icon = 'icons/obj/drinks.dmi'
	proj_icon_state = "beer"
	proj_name = "A bottle of beer"
	proj_lingering = 1
	proj_type = "/obj/effect/proc_holder/spell/inflict_handler/beer_missile"
	proj_lifespan = 20
	proj_step_delay = 5
	proj_trail_icon = 'icons/obj/drinks.dmi'
	proj_trail = 1
	proj_trail_lifespan = 5
	proj_trail_icon_state = "beer"
	action_icon_state = "no_state"
	action_background_icon_state = "missile"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'
	sound = 'sound/magic/magic_missile.ogg'

/obj/effect/proc_holder/spell/projectile/beer_missile/create_new_targeting()
	var/datum/spell_targeting/targeted/T = new()
	T.allowed_type = /mob/living
	T.max_targets = INFINITY
	return T

/obj/effect/proc_holder/spell/inflict_handler/beer_missile
	sound = "shatter"

/obj/effect/proc_holder/spell/inflict_handler/beer_missile/cast(list/targets, mob/user = usr)
	for(var/mob/living/target in targets)
		target.AdjustKnockDown(HIT_MISSILE_EFFECT_DURATION)
		target.AdjustDizzy(HIT_MISSILE_EFFECT_DURATION)
		target.AdjustSlur(HIT_MISSILE_EFFECT_DURATION)
		target.AdjustConfused(HIT_MISSILE_EFFECT_DURATION)
		target.AdjustEyeBlurry(HIT_MISSILE_EFFECT_DURATION)
		target.AdjustDrowsy(HIT_MISSILE_EFFECT_DURATION)
		target.AdjustDruggy(HIT_MISSILE_EFFECT_DURATION)
	. = ..()

/datum/spellbook_entry/beer_missile
	name = "Magic beer missiles"
	spell_type = /obj/effect/proc_holder/spell/projectile/beer_missile
	category = "Rave"

#undef HIT_MISSILE_EFFECT_DURATION
