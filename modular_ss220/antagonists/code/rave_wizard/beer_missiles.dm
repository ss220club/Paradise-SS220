/datum/spell/projectile/magic_missile/beer
	name = "Beer Missile"
	desc = "This spell fires several, slow moving, magic beer bottles at nearby targets"
	school = "evocation"
	base_cooldown = 60
	clothes_req = FALSE
	invocation = "CERVISIA TORMENTUM"
	invocation_type = "shout"
	cooldown_min = 60 //35 deciseconds reduction per rank
	proj_icon = 'icons/obj/drinks.dmi'
	proj_icon_state = "beer"
	proj_name = "A bottle of beer"
	proj_lingering = 1
	proj_type = "/obj/item/projectile/magic/magic_missile/beer"
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

/obj/item/projectile/magic/magic_missile/beer
	hitsound = "shatter"
	var/debuff_effect_duration = 10 SECONDS

/datum/spellbook_entry/beer_missile
	name = "Magic beer missiles"
	spell_type = /datum/spell/projectile/magic_missile/beer
	category = "Rave"

