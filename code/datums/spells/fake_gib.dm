/datum/spell/touch/fake_disintegrate
	name = "Disintegrate"
	desc = "Это заклинание заряжает вашу руку ужасной энергией, которая может быть использована для взрыва жертв."
	hand_path = "/obj/item/melee/touch_attack/fake_disintegrate"

	base_cooldown = 600
	clothes_req = FALSE
	cooldown_min = 200 //100 deciseconds reduction per rank

	action_icon_state = "gib"
