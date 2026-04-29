/datum/spell/charge_up/bounce/lightning
	name = "Lightning Bolt"
	desc = "Метать молнии во врагов. Классика. При нажатии начнет накапливаться энергия. Нажмите на цель, чтобы отправить заряд в цель до того, как заклятие переполнится и рассеется."
	base_cooldown	= 30 SECONDS
	invocation = "UN'LTD P'WAH!"
	invocation_type = "shout"
	cooldown_min = 3 SECONDS
	action_icon_state = "lightning"
	charge_sound = new /sound('sound/magic/lightning_chargeup.ogg', channel = 7)
	max_charge_time = 10 SECONDS
	stop_charging_text = "Вы перестаёте заряжать молнии вокруг себя."
	stop_charging_fail_text = "Молнии вокруг вас слишком сильны, чтобы их можно было остановить!"
	start_charging_text = "Вы начинаете накапливать молнии вокруг себя."
	bounce_hit_sound = 'sound/magic/lightningshock.ogg'
	var/damaging = TRUE

/datum/spell/charge_up/bounce/lightning/New()
	..()
	charge_up_overlay = image(icon = 'icons/effects/effects.dmi', icon_state = "electricity", layer = EFFECTS_LAYER)

/datum/spell/charge_up/bounce/lightning/lightnian
	clothes_req = FALSE
	invocation_type = "none"
	damaging = FALSE

/datum/spell/charge_up/bounce/lightning/get_bounce_energy()
	if(damaging)
		return max(15, get_energy_charge() / 2)
	return 0

/datum/spell/charge_up/bounce/lightning/get_bounce_amount()
	if(damaging)
		return 5
	return round(get_energy_charge() / 20)

/datum/spell/charge_up/bounce/lightning/create_beam(mob/origin, mob/target)
	origin.Beam(target, icon_state = "lightning[rand(1, 12)]", icon = 'icons/effects/effects.dmi', time = 5)

/datum/spell/charge_up/bounce/lightning/apply_bounce_effect(mob/origin, mob/living/target, energy, mob/user)
	if(target.can_block_magic(antimagic_flags))
		target.visible_message(
			SPAN_WARNING("[target.declent_ru(NOMINATIVE)] поглощает молнии, не получив повреждений!"),
			SPAN_DANGER("Вы поглощаете молнии. Вас так просто не остановить!")
		)
		return
	if(damaging)
		target.electrocute_act(energy, "Lightning Bolt", flags = SHOCK_NOGLOVES)
	else
		target.AdjustJitter(2000 SECONDS) //High numbers for violent convulsions
		target.AdjustStuttering(4 SECONDS)
		target.Slowed(6 SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, AdjustJitter), -2000 SECONDS, 10), 2 SECONDS) //Still jittery, but vastly less
