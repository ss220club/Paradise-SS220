
///////////////////////////////////
// POWERS
///////////////////////////////////

/datum/mutation/nobreath
	name = "Недышащий"
	activation_messages = list("Вам больше не нужно дышать.")
	deactivation_messages = list("Вы вновь чувствуете потребность в дыхании.")
	instability = GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_NOBREATH)

/datum/mutation/nobreath/New()
	..()
	block = GLOB.breathlessblock


/datum/mutation/regenerate
	name = "Регенерация"
	activation_messages = list("Ваши раны начинают заживать.")
	deactivation_messages = list("Ваши регенеративные способности словно исчезли.")
	instability = GENE_INSTABILITY_MINOR

/datum/mutation/regenerate/New()
	..()
	block = GLOB.regenerateblock

/datum/mutation/regenerate/on_life(mob/living/carbon/human/H)
	if(!H.ignore_gene_stability && H.gene_stability < GENETIC_DAMAGE_STAGE_1)
		H.adjustBruteLoss(-0.25, FALSE)
		H.adjustFireLoss(-0.25)
		return
	H.adjustBruteLoss(-1, FALSE)
	H.adjustFireLoss(-1)

/datum/mutation/heat_resist
	name = "Термостойкость"
	activation_messages = list("Ваше тело кажется ледяным на ощупь.")
	deactivation_messages = list("Ваше тело больше не кажется ледяным на ощупь.")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_RESISTHEAT, TRAIT_RESISTHIGHPRESSURE)

/datum/mutation/heat_resist/New()
	..()
	block = GLOB.coldblock

/datum/mutation/heat_resist/on_draw_underlays(mob/M, g)
	return "cold_s"

/datum/mutation/cold_resist
	name = "Хладостойкость"
	activation_messages = list("Ваше тело наполнено теплом.")
	deactivation_messages = list("Ваше тело более не наполнено теплом.")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_RESISTCOLD, TRAIT_RESISTLOWPRESSURE)

/datum/mutation/cold_resist/New()
	..()
	block = GLOB.fireblock

/datum/mutation/cold_resist/on_draw_underlays(mob/M, g)
	return "fire_s"

/datum/mutation/noprints
	name = "Размытые отпечатки"
	activation_messages = list("Узор на ваших пальцах будто бы сросся.")
	deactivation_messages = list("Рельеф кожи на ваших пальцах вновь индивидуален.")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_NOFINGERPRINTS)

/datum/mutation/noprints/New()
	..()
	block = GLOB.noprintsblock

/datum/mutation/noshock
	name = "Электроустойчивость"
	activation_messages = list("Ваша кожа ощущается сухой и резиновой.")
	deactivation_messages = list("Ваша кожа более не ощущается сухой и резиновой.")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_SHOCKIMMUNE)

/datum/mutation/noshock/New()
	..()
	block = GLOB.shockimmunityblock

/datum/mutation/dwarf
	name = "Карлик"
	activation_messages = list("Всё вокруг вдруг стало больше...")
	deactivation_messages = list("Вокруг вас будто бы всё уменьшилось...")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_DWARF)

/datum/mutation/dwarf/New()
	..()
	block = GLOB.smallsizeblock

/datum/mutation/dwarf/activate(mob/M)
	..()
	M.pass_flags |= PASSTABLE
	M.resize = 0.8
	M.update_transform()

/datum/mutation/dwarf/deactivate(mob/M)
	..()
	M.pass_flags &= ~PASSTABLE
	M.resize = 1.25
	M.update_transform()

// OLD HULK BEHAVIOR
/datum/mutation/hulk
	name = "Халк"
	activation_messages = list("У вас болят мышцы.")
	deactivation_messages = list("Ваши мышцы сокращаются.")
	instability = GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_HULK, TRAIT_CHUNKYFINGERS)

/datum/mutation/hulk/New()
	..()
	block = GLOB.hulkblock

/datum/mutation/hulk/activate(mob/living/carbon/human/M)
	..()
	var/status = CANSTUN | CANWEAKEN | CANPARALYSE | CANPUSH
	M.status_flags &= ~status
	M.update_body()

/datum/mutation/hulk/deactivate(mob/living/carbon/human/M)
	..()
	M.status_flags |= CANSTUN | CANWEAKEN | CANPARALYSE | CANPUSH
	M.update_body()

/datum/mutation/hulk/on_life(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.health <= 0)
		M.dna.SetSEState(GLOB.hulkblock, 0)
		singlemutcheck(M, GLOB.hulkblock, MUTCHK_FORCED)
		M.update_mutations()		//update our mutation overlays
		M.update_body()
		M.status_flags |= CANSTUN | CANWEAKEN | CANPARALYSE | CANPUSH //temporary fix until the problem can be solved.
		to_chat(M, SPAN_DANGER("Внезапно вы ощущаете сильную слабость."))

/datum/mutation/tk
	name = "Телекинез"
	activation_messages = list("Ваш разум расширяется.")
	deactivation_messages = list("Ваш разум сужается.")
	instability = GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_TELEKINESIS)

/datum/mutation/tk/New()
	..()
	block = GLOB.teleblock

/datum/mutation/tk/on_draw_underlays(mob/M, g)
	return "telekinesishead_s"

#define EAT_MOB_DELAY 300 // 30s

// WAS: /datum/bioEffect/alcres
/datum/mutation/sober
	name = "Трезвость"
	activation_messages = list("Вы чувствуете себя необычайно трезвым.")
	deactivation_messages = list("Вам бы не помешало крепко выпить...")
	instability = GENE_INSTABILITY_MINOR

	traits_to_add = list(TRAIT_ALCOHOL_TOLERANCE)

/datum/mutation/sober/New()
	..()
	block = GLOB.soberblock

//WAS: /datum/bioEffect/psychic_resist
/datum/mutation/psychic_resist
	name = "Пси-Устойчивость"
	desc = "Повышает стойкость в тех областях мозга, которые обычно связаны с мыслительными процессами."
	activation_messages = list("Чертоги разума были закрыты.")
	deactivation_messages = list("Секреты вашего разума вновь раскрыты.")
	instability = GENE_INSTABILITY_MINOR

/datum/mutation/psychic_resist/New()
	..()
	block = GLOB.psyresistblock

/////////////////////////
// Stealth Enhancers
/////////////////////////

/datum/mutation/stealth
	instability = GENE_INSTABILITY_MAJOR

/datum/mutation/stealth/can_activate(mob/M, flags)
	// Can only activate one of these at a time.
	if(is_type_in_list(/datum/mutation/stealth, M.active_mutations))
		testing("Cannot activate [type]: /datum/mutation/stealth in M.active_mutations.")
		return FALSE
	return ..()

/datum/mutation/stealth/deactivate(mob/living/M)
	..()
	M.reset_visibility()

// WAS: /datum/bioEffect/darkcloak
/datum/mutation/stealth/darkcloak
	name = "Плащ Тьмы"
	desc = "Позволяет объекту преломлять слабый свет вокруг себя, создавая эффект маскировки."
	activation_messages = list("Вы начинаете растворяться в тенях.")
	deactivation_messages = list("Тьма более не укрывает вас.")

/datum/mutation/stealth/darkcloak/New()
	..()
	block = GLOB.shadowblock

/datum/mutation/stealth/darkcloak/deactivate(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.set_alpha_tracking(ALPHA_VISIBLE, src)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.set_alpha_tracking(ALPHA_VISIBLE, src)
/datum/mutation/stealth/darkcloak/on_life(mob/M)
	var/turf/simulated/T = get_turf(M)
	if(!istype(T) || !ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/light_available = T.get_lumcount() * 10
	if(light_available <= 2)
		if(H.invisibility != INVISIBILITY_LEVEL_TWO)
			H.set_alpha_tracking(H.get_alpha() * 0.8, src)
	else
		H.reset_visibility()
		H.set_alpha_tracking(ALPHA_VISIBLE * 0.8, src)
	if(H.get_alpha(src) == 0)
		H.make_invisible()

//WAS: /datum/bioEffect/chameleon
/datum/mutation/stealth/chameleon
	name = "Хамелеон"
	desc = "Гуманоид приобретает способность незаметно изменять световые узоры, становясь невидимым, при условии, что он остается неподвижным."
	activation_messages = list("Вы чувствуете единство с окружением.")
	deactivation_messages = list("Вы вновь открыты и видны другим.")

/datum/mutation/stealth/chameleon/New()
	..()
	block = GLOB.chameleonblock

/datum/mutation/stealth/chameleon/deactivate(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.set_alpha_tracking(ALPHA_VISIBLE, src)

/datum/mutation/stealth/chameleon/on_life(mob/living/M)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if((world.time - H.last_movement) >= 30 && !H.stat && (H.mobility_flags & MOBILITY_STAND) && !H.restrained())
		if(H.invisibility != INVISIBILITY_LEVEL_TWO)
			H.set_alpha_tracking(H.get_alpha() - 25, src)
	else
		H.reset_visibility()
		H.set_alpha_tracking(ALPHA_VISIBLE * 0.8, src)
	if(H.get_alpha(src) == 0)
		H.make_invisible()

/////////////////////////////////////////////////////////////////////////////////////////

/datum/mutation/grant_spell
	var/datum/spell/spelltype

/datum/mutation/grant_spell/activate(mob/M)
	M.AddSpell(new spelltype(null))
	..()
	return TRUE

/datum/mutation/grant_spell/deactivate(mob/M)
	for(var/datum/spell/S in M.mob_spell_list)
		if(istype(S, spelltype))
			M.RemoveSpell(S)
	..()
	return TRUE

// WAS: /datum/bioEffect/cryokinesis
/datum/mutation/grant_spell/cryo
	name = "Криокинез"
	desc = "Позволяет вам понижать температуру тела других гуманоидов."
	activation_messages = list("Вы ощущаете странное холодное покалывание на кончиках пальцев.")
	deactivation_messages = list("Ваши пальцы вновь отдают теплом.")
	instability = GENE_INSTABILITY_MODERATE
	spelltype = /datum/spell/cryokinesis

/datum/mutation/grant_spell/cryo/New()
	..()
	block = GLOB.cryoblock

/datum/spell/cryokinesis
	name = "Криокинез"
	desc = "Понижает температуру другого гуманоида."

	base_cooldown = 1200

	clothes_req = FALSE
	antimagic_flags = NONE

	selection_activated_message		= SPAN_NOTICE("Ваш разум охлаждается. Нажмите на вашу цель для применения способности!")
	selection_deactivated_message	= SPAN_NOTICE("Ваш разум возвращается к норме.")
	var/list/compatible_mobs = list(/mob/living/carbon/human)

	action_icon_state = "genetic_cryo"

/datum/spell/cryokinesis/create_new_targeting()
	var/datum/spell_targeting/click/T = new()
	T.allowed_type = /mob/living/carbon
	T.click_radius = 0
	T.try_auto_target = FALSE // Give the clueless geneticists a way out and to have them not target themselves
	T.selection_type = SPELL_SELECTION_RANGE
	T.include_user = TRUE
	return T

/datum/spell/cryokinesis/cast(list/targets, mob/user = usr)

	var/mob/living/carbon/C = targets[1]

	if(HAS_TRAIT(C, TRAIT_RESISTCOLD))
		C.visible_message(SPAN_WARNING("Облако ледяных кристаллов окутывает [C.name], но пропадает почти мгновенно!"))
		return
	var/handle_suit = FALSE
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(istype(H.head, /obj/item/clothing/head/helmet/space))
			if(istype(H.wear_suit, /obj/item/clothing/suit/space))
				handle_suit = TRUE
				if(H.internal)
					H.visible_message(SPAN_WARNING("[user] распыляет облако мелких ледяных кристаллов, охватывая им [H]!"),
										SPAN_NOTICE("[user] распыляет облако мелких ледяных кристаллов над вашим [H.head]"))
				else
					H.visible_message(SPAN_WARNING("[user] распыляет облако мелких ледяных кристаллов, охватывая им [H]!"),
										SPAN_WARNING("[user] распыляет облако мелких ледяных кристаллов над вашим [H.head], проникающее в вашу систему дыхания!."))

					H.bodytemperature = max(0, H.bodytemperature - 100)
				add_attack_logs(user, C, "Cryokinesis")
	if(!handle_suit)
		C.bodytemperature = max(0, C.bodytemperature - 200)
		C.ExtinguishMob()

		C.visible_message(SPAN_WARNING("[user] распыляет облако мелких ледяных кристаллов, охватывая им [C]!"))
		add_attack_logs(user, C, "Cryokinesis- NO SUIT/INTERNALS")

///////////////////////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/mattereater
/datum/mutation/grant_spell/mattereater
	name = "Пожиратель материи"
	desc = "Позволяет субъекту поедать всё что угодно без каких-либо последствий."
	activation_messages = list("Вас одолевает голод.")
	deactivation_messages = list("Вы уже не так сильно и голодны.")
	instability = GENE_INSTABILITY_MODERATE

	spelltype=/datum/spell/eat

/datum/mutation/grant_spell/mattereater/New()
	..()
	block = GLOB.eatblock

// checks with those with the hungry organ from adding/removing matter eater
/datum/mutation/grant_spell/mattereater/activate(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/xenobiology/hungry/O = H.get_int_organ(/obj/item/organ/internal/liver/xenobiology/hungry)
		if(O)
			return
	return 	..()

/datum/mutation/grant_spell/mattereater/deactivate(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/liver/xenobiology/hungry/O = H.get_int_organ(/obj/item/organ/internal/liver/xenobiology/hungry)
		if(O)
			return
	return 	..()


/datum/spell/eat
	name = "Поедание"
	desc = "Съешь практически что угодно!"

	base_cooldown = 300

	clothes_req = FALSE
	antimagic_flags = NONE

	action_icon_state = "genetic_eat"

/datum/spell/eat/create_new_targeting()
	return new /datum/spell_targeting/matter_eater

/datum/spell/eat/can_cast(mob/user = usr, charge_check = TRUE, show_message = FALSE)
	. = ..()
	if(!.)
		return

	if(!iscarbon(user))
		return TRUE

	var/mob/living/carbon/C = user
	if(!(C.head?.flags_cover & HEADCOVERSMOUTH))
		if(!ismask(C.wear_mask))
			return TRUE

		var/obj/item/clothing/mask/worn_mask = C.wear_mask
		if(!(worn_mask.flags_cover & MASKCOVERSMOUTH) || worn_mask.up)
			return TRUE

	if(show_message)
		to_chat(C, SPAN_WARNING("Ваш рот чем-то закрыт, препятствуя вашему чревоугодию!"))
	return FALSE

/datum/spell/eat/proc/doHeal(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		for(var/name in H.bodyparts_by_name)
			var/obj/item/organ/external/affecting = null
			if(!H.bodyparts_by_name[name])
				continue
			affecting = H.bodyparts_by_name[name]
			if(!is_external_organ(affecting))
				continue
			affecting.heal_damage(4, 0, updating_health = FALSE)
		H.UpdateDamageIcon()
		H.updatehealth()



/datum/spell/eat/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, SPAN_NOTICE("Целей поблизости не найдено."))
		return

	var/atom/movable/the_item = targets[1]
	if(!user.Adjacent(the_item))
		to_chat(user, SPAN_DANGER("Вам нужно быть рядом с [the_item.declent_ru(INSTRUMENTAL)] для этого!"))
		return FALSE
	if(ishuman(the_item))
		var/mob/living/carbon/human/H = the_item
		var/obj/item/organ/external/limb = H.get_organ(user.zone_selected)
		if(!istype(limb))
			to_chat(user, SPAN_WARNING("Вы не можете съесть эту часть!"))
			revert_cast()
			return FALSE
		if(istype(limb,/obj/item/organ/external/head))
			// Bullshit, but prevents being unable to clone someone.
			to_chat(user, SPAN_WARNING("Вы попытались проглотить голову [the_item], но [the_item.ru_p_them()] уши защекотали ваше горло!"))
			revert_cast()
			return FALSE
		if(istype(limb,/obj/item/organ/external/chest))
			// Bullshit, but prevents being able to instagib someone.
			to_chat(user, SPAN_WARNING("Вы попытались проглотить [the_item.ru_p_them()] грудную клетку, но это оказалось перебором для вашего рта!"))
			revert_cast()
			return FALSE
		user.visible_message(SPAN_DANGER("[user.declent_ru(NOMINATIVE)] начинает заглатывать [limb.declent_ru(ACCUSATIVE)] [the_item.declent_ru(GENITIVE)] в свою широко раскрытую пасть!"))
		if(!do_mob(user, H, EAT_MOB_DELAY))
			to_chat(user, SPAN_DANGER("Вас потревожили прежде чем вы смогли съесть [limb.declent_ru(ACCUSATIVE)] [the_item]!"))
		else
			if(!limb || !H)
				return
			if(!user.Adjacent(the_item))
				to_chat(user, SPAN_DANGER("Вам нужно быть рядом с [the_item.declent_ru(INSTRUMENTAL)] для этого!"))
				return FALSE
			user.visible_message(SPAN_DANGER("[user] [pick("отгрызает","откусывает")] [limb.declent_ru(ACCUSATIVE)] [the_item]!"))
			playsound(user.loc, 'sound/items/eatfood.ogg', 50, 0)

			// Most limbs will drop here. Groin won't, but this
			// still spills out the organs that were in it.
			limb.droplimb(FALSE, DROPLIMB_SHARP)
			if(istype(limb, /obj/item/organ/external/groin))
				limb.receive_damage(100, sharp = TRUE)

				var/obj/item/organ/external/left_leg = H.get_organ(BODY_ZONE_L_LEG)
				if(istype(left_leg))
					left_leg.droplimb(FALSE, DROPLIMB_SHARP)

				var/obj/item/organ/external/right_leg = H.get_organ(BODY_ZONE_R_LEG)
				if(istype(right_leg))
					right_leg.droplimb(FALSE, DROPLIMB_SHARP)

				var/obj/item/organ/external/chest = H.get_organ(BODY_ZONE_CHEST)
				if(istype(chest))
					chest.receive_damage(50, sharp = TRUE)

			doHeal(user)

		return

	if(ismob(the_item.loc) && isitem(the_item))
		var/obj/item/eaten = the_item
		var/mob/the_owner = the_item.loc
		if(!the_owner.drop_item_to_ground(eaten, silent = TRUE))
			to_chat(user, SPAN_WARNING("Вы не можете съесть [the_item], оно не пройдет через ваше горло!"))
			return
	user.visible_message(SPAN_DANGER("[user] съедает [the_item]."))
	playsound(user.loc, 'sound/items/eatfood.ogg', 50, FALSE)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/chest/target_place = H.get_organ(BODY_ZONE_CHEST)
		if(istype(target_place))
			the_item.forceMove(target_place)
			doHeal(user)
			return

	qdel(the_item)
	doHeal(user)

////////////////////////////////////////////////////////////////////////

//WAS: /datum/bioEffect/jumpy
/datum/mutation/grant_spell/jumpy
	name = "Прыжок"
	desc = "Позволяет совершать прыжок на далёкое расстояние."
	//cooldown = 30
	activation_messages = list("Ваши мышцы ног стали подтянутыми и сильными.")
	deactivation_messages = list("Ваши мышцы ног вернулись к привычному для них состоянию.")
	instability = GENE_INSTABILITY_MODERATE

	spelltype =/datum/spell/leap

/datum/mutation/grant_spell/jumpy/New()
	..()
	block = GLOB.jumpblock

/datum/spell/leap
	name = "Прыжок"
	desc = "Преодолевай дальнее расстояние!"
	base_cooldown = 60

	clothes_req = FALSE
	antimagic_flags = NONE

	action_icon_state = "genetic_jump"
	var/leap_distance = 10

/datum/spell/leap/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/leap/cast(list/targets, mob/living/user = usr)
	var/failure = FALSE
	if(ismob(user.loc) || IS_HORIZONTAL(user) || user.IsStunned() || user.buckled || user.stat)
		to_chat(user, SPAN_WARNING("Вы пока что не можете прыгнуть!"))
		return

	if(isturf(user.loc))
		if(user.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/living/M in range(user, 1))
				if(M.pulling == user)
					if(!M.restrained() && M.stat == CONSCIOUS && !(M.mobility_flags & MOBILITY_STAND) && user.Adjacent(M))
						failure = TRUE
					else
						M.stop_pulling()

		user.visible_message(SPAN_DANGER("[user.name]</b> совершает большой скачок!"))
		playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 50, 1)
		if(failure)
			user.Weaken(10 SECONDS)
			user.visible_message(SPAN_WARNING("[user] пытается отскочить, но с грохотом теряет равновесие и падает!"),
								SPAN_WARNING("Вы попытались совершить скачок, но с грохотом потеряли равновесие и упали!"),
								SPAN_NOTICE("Вы слышите напряжение мускулатуры и внезапный грохот, как только чьё-то тело пикировало на пол."))
			return FALSE
		var/prevLayer = user.layer
		user.layer = 9

		ADD_TRAIT(user, TRAIT_FLYING, "leap")
		for(var/i in 1 to leap_distance)
			var/turf/hit_turf = get_step(user, user.dir)
			var/atom/hit_atom = get_blocking_atom(hit_turf)
			if(hit_atom)
				hit_atom.hit_by_thrown_mob(user, damage = 10)
				break

			step(user, user.dir)
			if(i < 6)
				user.pixel_y += 8
			else
				user.pixel_y -= 8
			sleep(1)

		REMOVE_TRAIT(user, TRAIT_FLYING, "leap")
		user.pixel_y = 0 // In case leap was varedited to be longer or shorter

		if(HAS_TRAIT(user, TRAIT_FAT) && prob(66))
			user.visible_message(SPAN_DANGER("<b>[user.name]</b> с грохотом падает из-за [user.ru_p_them()] тяжелого веса!"))
			//playsound(user.loc, 'zhit.wav', 50, 1)
			user.AdjustWeakened(20 SECONDS)
			user.AdjustStunned(10 SECONDS)

		user.layer = prevLayer

	if(isobj(user.loc))
		var/obj/container = user.loc
		to_chat(user, SPAN_WARNING("Вы прыгнули и ударились головой внутри [container.declent_ru(GENITIVE)]! Ай!"))
		user.AdjustParalysis(6 SECONDS)
		user.AdjustWeakened(10 SECONDS)
		container.visible_message(SPAN_DANGER("<b>[capitalize(container.declent_ru(NOMINATIVE))]</b> издаёт резкий грохот и дребезжит."))
		playsound(user.loc, 'sound/effects/bang.ogg', 50, 1)
		var/wiggle = 6
		while(wiggle > 0)
			wiggle--
			container.pixel_x = rand(-3,3)
			container.pixel_y = rand(-3,3)
			sleep(1)
		container.pixel_x = 0
		container.pixel_y = 0

/datum/spell/leap/proc/get_blocking_atom(turf/turf_to_check)
	if(!turf_to_check)
		return FALSE

	if(turf_to_check.density)
		return turf_to_check

	for(var/atom/movable/hit_thing in turf_to_check)
		if(isliving(hit_thing))
			var/mob/living/hit_mob = hit_thing
			if(hit_mob.density)
				return hit_mob

		if(isobj(hit_thing))
			var/obj/hit_obj = hit_thing
			if(hit_obj.density)
				return hit_obj

	return FALSE

////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/polymorphism

/datum/mutation/grant_spell/polymorph
	name = "Полиморфизм"
	desc = "Позволяет изменять свою внешность, чтобы имитировать внешность других людей."

	spelltype =/datum/spell/polymorph
	//cooldown = 1800
	activation_messages = list("Почему-то вы не ощущаете себя в своём теле.")
	deactivation_messages = list("К вам вернулась уверенность в собственной личности.")
	instability = GENE_INSTABILITY_MODERATE

/datum/mutation/grant_spell/polymorph/New()
	..()
	block = GLOB.polymorphblock

/datum/spell/polymorph
	name = "Полиморф"
	desc = "Подражай внешности окружающих!"
	base_cooldown = 1800

	clothes_req = FALSE

	selection_activated_message		= SPAN_NOTICE("Ваше тело колеблется. Выберите вашу цель для подражания её внешности.")
	selection_deactivated_message	= SPAN_NOTICE("Ваше тело возвращается к покою.")

	antimagic_flags = NONE

	action_icon_state = "genetic_poly"

/datum/spell/polymorph/create_new_targeting()
	var/datum/spell_targeting/click/T = new()
	T.try_auto_target = FALSE
	T.click_radius = -1
	T.range = 1
	T.selection_type = SPELL_SELECTION_RANGE
	return T

/datum/spell/polymorph/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/target = targets[1]

	user.visible_message(SPAN_WARNING("Тело [user] дёргается и искажается."))

	spawn(10)
		if(target && user)
			playsound(user.loc, 'sound/goonstation/effects/gib.ogg', 50, 1)
			var/mob/living/carbon/human/H = user
			H.UpdateAppearance(target.dna.UI)
			H.real_name = target.real_name
			H.name = target.name

////////////////////////////////////////////////////////////////////////

// WAS: /datum/bioEffect/empath
/datum/mutation/grant_spell/empath
	name = "Эмпатическое мышление"
	desc = "Субъект приобретает способность читать мысли других людей и получать определенную информацию."

	spelltype = /datum/spell/empath
	activation_messages = list("Внезапно, вы подмечаете больше об окружающих, чем раньше.")
	deactivation_messages = list("Вы более не способны проникать в разум других.")
	instability = GENE_INSTABILITY_MINOR

/datum/mutation/grant_spell/empath/New()
	..()
	block = GLOB.empathblock

/datum/spell/empath
	name = "Чтение мыслей"
	desc = "Читайте мысли разумных существ для сбора информации о них."
	base_cooldown = 18 SECONDS
	clothes_req = FALSE
	human_req = TRUE
	antimagic_flags = MAGIC_RESISTANCE_MIND

	action_icon_state = "genetic_empath"

/datum/spell/empath/create_new_targeting()
	var/datum/spell_targeting/targeted/T = new()
	T.allowed_type = /mob/living/carbon
	T.selection_type = SPELL_SELECTION_RANGE
	return T

/datum/spell/empath/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/M in targets)
		if(!iscarbon(M))
			to_chat(user, SPAN_WARNING("Вы можете применить данные силы только к другим гуманоидам."))
			return

		if(M.dna?.GetSEState(GLOB.psyresistblock))
			to_chat(user, SPAN_WARNING("Вы никак не можете проникнуть в разум [M.name]!"))
			return

		if(M.stat == DEAD)
			to_chat(user, SPAN_WARNING("[M.name] мёртв и в [M.ru_p_them()] разум невозможно проникнуть."))
			return
		if(M.health < 0)
			to_chat(user, SPAN_WARNING("[M.name] на грани смерти и [M.ru_p_them()] мысли слишком запутаны для считывания."))
			return

		to_chat(user, SPAN_NOTICE("Чтение мыслей <b>[M.name]:</b>"))

		var/pain_condition = M.health / M.maxHealth
		// lower health means more pain
		var/list/randomthoughts = list("чем бы перекусить","дальнейшее будущее","своё прошлое","денежный достаток",
		"свой стиль причёски","чем бы заняться","своё рабочее положение","необъятность космоса","нечто прекрасное","и грустит о чём-то",
		"тяготы своей жизни","и радуется простым вещам","какую-то бессмыслицу","свои неудачи")
		var/thoughts = "обдумывает [pick(randomthoughts)]"

		if(M.fire_stacks)
			pain_condition -= 0.5
			thoughts = "озабочен собственным возгоранием"

		if(M.radiation)
			pain_condition -= 0.25

		switch(pain_condition)
			if(0.81 to INFINITY)
				to_chat(user, SPAN_NOTICE("<b>Состояние</b>: [M.name] в порядке."))
			if(0.61 to 0.8)
				to_chat(user, SPAN_NOTICE("<b>Состояние</b>: [M.name] испытывает лёгкую боль."))
			if(0.41 to 0.6)
				to_chat(user, SPAN_NOTICE("<b>Состояние</b>: [M.name] испытывает сильную боль."))
			if(0.21 to 0.4)
				to_chat(user, SPAN_NOTICE("<b>Состояние</b>: [M.name] страдает от серьёзной боли."))
			else
				to_chat(user, SPAN_NOTICE("<b>Состояние</b>: [M.name] мучается и едва держит себя в руках."))
				thoughts = "К [M.name] пришло осознание [M.ru_p_them()] бессилия пред собственной смертностью."

		switch(M.a_intent)
			if(INTENT_HELP)
				to_chat(user, SPAN_NOTICE("<b>Настрой</b>: [M.name] доброжелательно оценивает обстановку."))
			if(INTENT_DISARM)
				to_chat(user, SPAN_NOTICE("<b>Настрой</b>: [M.name] проявляет осторожность и вдумчивость."))
			if(INTENT_GRAB)
				to_chat(user, SPAN_NOTICE("<b>Настрой</b>: [M.name] концентрируется на окружении и захвате."))
			if(INTENT_HARM)
				to_chat(user, SPAN_NOTICE("<b>Настрой</b>: [M.name] испытывает напряжение и настраивается на бой."))
				for(var/mob/living/L in view(7,M))
					if(L == M)
						continue
					thoughts = "думает ударить [L.name]"
					break
			else
				to_chat(user, SPAN_NOTICE("<b>Настрой</b>: [M.name] мыслит странно и непредсказуемо."))

		if(ishuman(M))
			var/numbers[0]
//SS220 EDIT START - Небольшая редакция для перевода гена
			var/text_numbers = ""

			var/mob/living/carbon/human/H = M
			if(H.mind && H.mind.initial_account)
				numbers += H.mind.initial_account.account_number
				numbers += H.mind.initial_account.account_pin
			if(length(numbers))
				if(length(numbers) == 1)
					text_numbers = "[numbers[1]]"
				else
					var/i
					for(i = 1 to length(numbers))
						if(i == 1)
							text_numbers += "[numbers[i]]"
						else if(i == length(numbers))
							text_numbers += " и [numbers[i]]"
						else
							text_numbers += ", [numbers[i]]"
//SS220 EDIT END
				to_chat(user, SPAN_NOTICE("<b>Цифры</b>: Кажется номер[length(numbers)>1?"а":""] [text_numbers] [length(numbers)>1?"важны":"важен"] для [M.name]."))
		to_chat(user, SPAN_NOTICE("<b>Мысли</b>: [M.name] сейчас [thoughts]."))

		if(M.dna?.GetSEState(GLOB.empathblock))
			to_chat(M, SPAN_WARNING("Вы ощущаете как [user.name] читает ваши мысли."))
		else if(prob(5) || M.mind?.assigned_role=="Chaplain")
			to_chat(M, SPAN_WARNING("Вы чувствуете, что кто-то вторгается в ваши мысли..."))

///////////////////Vanilla Morph////////////////////////////////////

/datum/mutation/grant_spell/morph
	name = "Морфизм"
	desc = "Позволяет обладателю самостоятельно перестраивать свою внешность без каких-либо приспособлений."
	spelltype =/datum/spell/morph
	activation_messages = list("Ваше тело будто бы научилось изменять внешность.")
	deactivation_messages = list("Ваше тело более не способно к самостоятельному изменению внешности.")
	instability = GENE_INSTABILITY_MODERATE

/datum/mutation/grant_spell/morph/New()
	..()
	block = GLOB.morphblock

/datum/spell/morph
	name = "Преображение"
	desc = "Самостоятельно определяйте свою внешность на ходу!"
	base_cooldown = 1800

	clothes_req = FALSE
	antimagic_flags = NONE

	action_icon_state = "genetic_morph"

/datum/spell/morph/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/morph/cast(list/targets, mob/user = usr)
	if(!ishuman(user))
		return

	if(ismob(user.loc))
		to_chat(user, SPAN_WARNING("Вы пока что не можете менять свою внешность!"))
		return
	var/mob/living/carbon/human/M = user
	var/obj/item/organ/external/head/head_organ = M.get_organ("head")
	var/obj/item/organ/internal/eyes/eyes_organ = M.get_int_organ(/obj/item/organ/internal/eyes)

	var/new_gender = tgui_alert(user, "Выберите пол.", "Настройка персонажа", list("Мужской", "Женский"))
	if(new_gender)
		if(new_gender == "Мужской")
			M.change_gender(MALE)
		else
			M.change_gender(FEMALE)

	if(eyes_organ)
		var/new_eyes = tgui_input_color(user, "Выберите цвет глаз.", "Настройка персонажа", eyes_organ.eye_color)
		if(isnull(new_eyes))
			return
		M.change_eye_color(new_eyes)

	if(istype(head_organ))
		//Alt heads.
		if(head_organ.dna.species.bodyflags & HAS_ALT_HEADS)
			var/list/valid_alt_heads = M.generate_valid_alt_heads()
			var/new_alt_head = tgui_input_list(user, "Выберите альтернативный тип головы", "Настройка персонажа", valid_alt_heads)
			if(new_alt_head)
				M.change_alt_head(new_alt_head)

		// hair
		var/list/valid_hairstyles = M.generate_valid_hairstyles()
		var/new_style = tgui_input_list(user, "Выберите стиль причёски", "Настройка персонажа", valid_hairstyles)

		// if new style selected (not cancel)
		if(new_style)
			M.change_hair(new_style)

		var/new_hair = tgui_input_color(user, "Выберите цвет причёски", "Настройка персонажа", head_organ.hair_colour)
		if(!isnull(new_hair))
			M.change_hair_color(new_hair)

		var/datum/sprite_accessory/hair_style = GLOB.hair_styles_public_list[head_organ.h_style]
		if(hair_style.secondary_theme && !hair_style.no_sec_colour)
			new_hair = tgui_input_color(user, "Выберите второстепенный цвет причёски", "Настройка персонажа", head_organ.sec_hair_colour)
			if(!isnull(new_hair))
				M.change_hair_color(new_hair, TRUE)

		// facial hair
		var/list/valid_facial_hairstyles = M.generate_valid_facial_hairstyles()
		new_style = tgui_input_list(user, "Выберите тип лицевого покрова", "Настройка персонажа", valid_facial_hairstyles)

		if(new_style)
			M.change_facial_hair(new_style)

		var/new_facial = tgui_input_color(user, "Выберите цвет лицевого покрова.", "Настройка персонажа", head_organ.facial_colour)
		if(!isnull(new_facial))
			M.change_facial_hair_color(new_facial)

		var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[head_organ.f_style]
		if(facial_hair_style.secondary_theme && !facial_hair_style.no_sec_colour)
			new_facial = tgui_input_color(user, "Выберите второстепенный цвет лицевого покрова.", "Настройка персонажа", head_organ.sec_facial_colour)
			if(!isnull(new_facial))
				M.change_facial_hair_color(new_facial, TRUE)

		//Head accessory.
		if(head_organ.dna.species.bodyflags & HAS_HEAD_ACCESSORY)
			var/list/valid_head_accessories = M.generate_valid_head_accessories()
			var/new_head_accessory = tgui_input_list(user, "Выберите атрибуты вашей головы", "Настройка персонажа", valid_head_accessories)
			if(!isnull(new_head_accessory))
				M.change_head_accessory(new_head_accessory)

			var/new_head_accessory_colour = tgui_input_color(user, "Выберите цвет атрибутов вашей головы.", "Настройка персонажа", head_organ.headacc_colour)
			if(!isnull(new_head_accessory_colour))
				M.change_head_accessory_color(new_head_accessory_colour)


	//Body accessory.
	if((M.dna.species.tail && M.dna.species.bodyflags & (HAS_TAIL)) || (M.dna.species.wing && M.dna.species.bodyflags & (HAS_WING)) || (M.dna.species.spines && M.dna.species.bodyflags & (HAS_BACK_SPINES)))
		var/list/valid_body_accessories = M.generate_valid_body_accessories()
		if(length(valid_body_accessories) > 1) //By default valid_body_accessories will always have at the very least a 'none' entry populating the list, even if the user's species is not present in any of the list items.
			var/new_body_accessory = tgui_input_list(user, "Выберите тип уникальной конечности тела", "Настройка персонажа", valid_body_accessories)
			if(!isnull(new_body_accessory))
				M.change_body_accessory(new_body_accessory)

	if(istype(head_organ))
		//Head markings.
		if(M.dna.species.bodyflags & HAS_HEAD_MARKINGS)
			var/list/valid_head_markings = M.generate_valid_markings("head")
			var/new_marking = tgui_input_list(user, "Выберите стиль рисунка на голове", "Настройка персонажа", valid_head_markings)
			if(!isnull(new_marking))
				M.change_markings(new_marking, "head")

			var/new_marking_colour = tgui_input_color(user, "Выберите цвет рисунка на голове", "Настройка персонажа", M.m_colours["head"])
			if(!isnull(new_marking_colour))
				M.change_marking_color(new_marking_colour, "head")

	//Body markings.
	if(M.dna.species.bodyflags & HAS_BODY_MARKINGS)
		var/list/valid_body_markings = M.generate_valid_markings("body")
		var/new_marking = tgui_input_list(user, "Выберите стиль рисунка на теле", "Настройка персонажа", valid_body_markings)
		if(!isnull(new_marking))
			M.change_markings(new_marking, "body")

		var/new_marking_colour = tgui_input_color(user, "Выберите цвет рисунка на тела", "Настройка персонажа", M.m_colours["body"])
		if(!isnull(new_marking_colour))
			M.change_marking_color(new_marking_colour, "body")
	//Tail markings.
	if(M.dna.species.bodyflags & HAS_TAIL_MARKINGS)
		var/list/valid_tail_markings = M.generate_valid_markings("tail")
		var/new_marking = tgui_input_list("Выберите стиль подкраски хвоста", "Настройка персонажа", valid_tail_markings)
		if(!isnull(new_marking))
			M.change_markings(new_marking, "tail")

		var/new_marking_colour = tgui_input_color(user, "Выберите цвет подкраски хвоста", "Настройка персонажа", M.m_colours["tail"])
		if(!isnull(new_marking_colour))
			M.change_marking_color(new_marking_colour, "tail")

	//Skin tone.
	if(M.dna.species.bodyflags & HAS_SKIN_TONE)
		var/new_tone = input("Выберите цвет кожи: 1-220 (1 = Альбинос , 35 = Светлый, 150 = Тёмный, 220 = Чёрный)", "Настройка персонажа", M.s_tone) as null|text
		if(!new_tone)
			new_tone = 35
		else
			new_tone = max(min(round(text2num(new_tone)), 220), 1)
			M.change_skin_tone(new_tone)

	if(M.dna.species.bodyflags & HAS_ICON_SKIN_TONE)
		var/prompt = "Выберите цвет кожи: 1-[length(M.dna.species.icon_skin_tones)] ("
		for(var/i = 1 to length(M.dna.species.icon_skin_tones))
			prompt += "[i] = [M.dna.species.icon_skin_tones[i]]"
			if(i != length(M.dna.species.icon_skin_tones))
				prompt += ", "
		prompt += ")"

		var/new_tone = input(prompt, "Настройка персонажа", M.s_tone) as null|text
		if(!new_tone)
			new_tone = 0
		else
			new_tone = max(min(round(text2num(new_tone)), length(M.dna.species.icon_skin_tones)), 1)
			M.change_skin_tone(new_tone)

	//Skin colour.
	if(M.dna.species.bodyflags & HAS_SKIN_COLOR)
		var/new_body_colour = tgui_input_color(user, "Выберите окрас вашего тела", "Настройка персонажа", M.skin_colour)
		if(!isnull(new_body_colour))
			M.change_skin_color(new_body_colour)

	M.update_dna()

	M.visible_message(SPAN_NOTICE("[M] видоизменяется и преображает [M.ru_p_them()] внешность!"), SPAN_NOTICE("Вы изменяете свою внешность!"), SPAN_WARNING("Боже! Что это было? Звучало так, будто плоть с костями пропустили через мясорубку и собрали по другому!"))

/datum/mutation/grant_spell/remotetalk
	name = "Телепатия"
	activation_messages = list("Вы ощущаете способность к передаче своих мыслей.")
	deactivation_messages = list("Вы более не ощущаете способности к передаче своих мыслей.")
	instability = GENE_INSTABILITY_MINOR

	spelltype =/datum/spell/remotetalk

/datum/mutation/grant_spell/remotetalk/New()
	..()
	block = GLOB.remotetalkblock

/datum/mutation/grant_spell/remotetalk/activate(mob/living/M)
	..()
	M.AddSpell(new /datum/spell/mindscan(null))

/datum/mutation/grant_spell/remotetalk/deactivate(mob/user)
	..()
	for(var/datum/spell/S in user.mob_spell_list)
		if(istype(S, /datum/spell/mindscan))
			user.RemoveSpell(S)

/datum/spell/remotetalk
	name = "Проекция разума"
	desc = "Позвольте другим услышать ваши мысли!"
	base_cooldown = 0

	clothes_req = FALSE
	antimagic_flags = MAGIC_RESISTANCE_MIND

	action_icon_state = "genetic_project"

/datum/spell/remotetalk/create_new_targeting()
	return new /datum/spell_targeting/telepathic

/datum/spell/remotetalk/cast(list/targets, mob/user = usr)
	if(!isliving(user))
		return
	if(user.mind?.miming) // Dont let mimes telepathically talk
		to_chat(user,SPAN_WARNING("Вы не можете общаться, не нарушив при этом обет молчания."))
		return
	var/say = tgui_input_text(user, "Что хочешь сказать?", "Проекция разума")
	if(!say || usr.stat)
		return
	say = pencode_to_html(say, usr, format = FALSE, fields = FALSE)

	for(var/mob/living/target in targets)
		log_say("(TPATH to [key_name(target)]) [say]", user)
		user.create_log(SAY_LOG, "Телепатически сказал '[say]' используя [src]", target)
		if(target.dna?.GetSEState(GLOB.remotetalkblock))
			target.show_message("<i>[SPAN_ABDUCTOR("Вы слышите голос [user.real_name]: [say]")]</i>")
		else
			target.show_message("<i>[SPAN_ABDUCTOR("Вы слышите голос, раздающийся эхом в вашей голове: [say]")]</i>")
		user.show_message("<i>[SPAN_ABDUCTOR("Вы проецируете свои мысли для [(target in user.get_visible_mobs()) ? target.name : "неизвестного существа"]: [say]")]</i>")
		for(var/mob/dead/observer/G in GLOB.player_list)
			G.show_message("<i>Телепатическое сообщение от <b>[user]</b> ([ghost_follow_link(user, ghost=G)]) к <b>[target]</b> ([ghost_follow_link(target, ghost=G)]): [say]</i>")

/datum/spell/mindscan
	name = "Открытие разума"
	desc = "Предложите другим высказать свои слова вам мысленно!"
	base_cooldown = 0
	clothes_req = FALSE
	antimagic_flags = MAGIC_RESISTANCE_MIND
	action_icon_state = "genetic_mindscan"
	var/list/expanded_minds = list()

/datum/spell/mindscan/create_new_targeting()
	return new /datum/spell_targeting/telepathic

/datum/spell/mindscan/cast(list/targets, mob/user = usr)
	if(!isliving(user))
		return
	for(var/mob/living/target in targets)
		var/message = "Ваш разум на мгновение расширяется... (Нажмите, чтобы отправить сообщение.)"
		if(target.dna?.GetSEState(GLOB.remotetalkblock))
			message = "Вы ощущаете как [user.real_name] спрашивает у вас ответа... (Нажмите, чтобы позволить телепатическое общение.)"
		user.show_message("<i>[SPAN_ABDUCTOR("Вы открыли свой разум для [(target in user.get_visible_mobs()) ? target.name : "неизвестного существа"].")]</i>")
		target.show_message("<i>[SPAN_ABDUCTOR("<a href='byond://?src=[UID()];from=[target.UID()];to=[user.UID()]'>[message]</a>")]</i>")
		expanded_minds += target
		addtimer(CALLBACK(src, PROC_REF(removeAvailability), target), 10 SECONDS)

/datum/spell/mindscan/proc/removeAvailability(mob/living/target)
	if(target in expanded_minds)
		expanded_minds -= target
		if(!(target in expanded_minds))
			target.show_message("<i>[SPAN_ABDUCTOR("Вы чувствуете как связь угасает...")]</i>")

/datum/spell/mindscan/Topic(href, href_list)
	var/mob/living/message_source
	message_source = locateUID(href_list["from"])
	if(!message_source)
		return
	if(!message_source || !(message_source in expanded_minds))
		return

	expanded_minds -= message_source

	var/mob/living/message_target = locateUID(href_list["to"])
	if(!message_target)
		return

	var/say = tgui_input_text(message_source, "Что вы хотите сказать?", "Расширенное сознание")
	if(!say)
		return
	say = pencode_to_html(say, message_source, format = FALSE, fields = FALSE)

	message_source.create_log(SAY_LOG, "Телепатически ответил '[say]' используя [src]", message_target)
	log_say("(TPATH to [key_name(message_target)]) [say]", message_source)

	if(message_source.dna?.GetSEState(GLOB.remotetalkblock))
		message_source.show_message("<i>[SPAN_ABDUCTOR("Вы открыли свой разум для [message_target]: [say]")]</i>")
	else
		message_source.show_message("<i>[SPAN_ABDUCTOR("Вы заполняете пространство в собственных мыслях: [say]")]</i>")

	message_target.show_message("<i>[SPAN_ABDUCTOR("Вы слышите голос [message_source]: [say]")]</i>")

	for(var/mob/dead/observer/G in GLOB.player_list)
		G.show_message("<i>Телепатический ответ от <b>[message_source]</b> ([ghost_follow_link(message_source, ghost=G)]) к <b>[message_target]</b> ([ghost_follow_link(message_target, ghost=G)]): [say]</i>")

/datum/spell/mindscan/Destroy()
	expanded_minds.Cut()
	return ..()

/datum/mutation/grant_spell/remoteview
	name = "Удалённый просмотр"
	activation_messages = list("Ваше сознание простирает взор на далекое расстояние.")
	deactivation_messages = list("Ваше сознание более не способно видеть окружение вдалеке.")
	instability = GENE_INSTABILITY_MINOR

	spelltype =/datum/spell/remoteview

/datum/mutation/grant_spell/remoteview/New()
	..()
	block = GLOB.remoteviewblock

/datum/mutation/grant_spell/remoteview/deactivate(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.remoteview_target = null
		H.reset_perspective()

/datum/spell/remoteview
	name = "Удаленный просмотр"
	desc = "Присматривайте друг за другом на любом расстоянии!"

	clothes_req = FALSE
	antimagic_flags = MAGIC_RESISTANCE_MIND

	action_icon_state = "genetic_view"

/datum/spell/remoteview/create_new_targeting()
	return new /datum/spell_targeting/remoteview

/datum/spell/remoteview/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H
	if(ishuman(user))
		H = user
	else
		return

	var/mob/target

	if(istype(H.l_hand, /obj/item/tk_grab) || istype(H.r_hand, /obj/item/tk_grab))
		to_chat(H, SPAN_WARNING("Ваше сознание слишком занято телекинетическими способностями."))
		H.remoteview_target = null
		H.reset_perspective()
		return

	if(H.client.eye != user.client.mob)
		H.remoteview_target = null
		H.reset_perspective()
		return

	for(var/mob/living/L in targets)
		target = L

	if(target)
		H.remoteview_target = target
		H.reset_perspective(target)
	else
		H.remoteview_target = null
		H.reset_perspective()

/datum/mutation/meson_vision
	name = "Мезонное зрение"
	activation_messages = list("Вашему взору предстаёт больше деталей об окружении...")
	deactivation_messages = list("Количество информации, предстающее вашему взору, скуднеет...")
	instability = GENE_INSTABILITY_MINOR
	traits_to_add = list(TRAIT_MESON_VISION)

/datum/mutation/meson_vision/New()
	..()
	block = GLOB.mesonblock

/datum/mutation/meson_vision/activate(mob/living/M)
	..()
	M.update_sight()

/datum/mutation/meson_vision/deactivate(mob/living/M)
	..()
	M.update_sight()

/datum/mutation/night_vision
	name = "Ночное зрение"
	activation_messages = list("Свет всегда был таким ярким?")
	deactivation_messages = list("Уровень восприятия света возвращается к норме...")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_NIGHT_VISION)

/datum/mutation/night_vision/New()
	..()
	block = GLOB.nightvisionblock

/datum/mutation/night_vision/activate(mob/living/M)
	..()
	M.update_sight()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_misc_effects()

/datum/mutation/night_vision/deactivate(mob/living/M)
	..()
	M.update_sight()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_misc_effects()

/datum/mutation/flash_protection
	name = "Защита от вспышки"
	activation_messages = list("Вы перестаёте обращать внимание на резкие блики света...")
	deactivation_messages = list("Освещение вновь начинает рябить в глазах...")
	instability = GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_FLASH_PROTECTION)

/datum/mutation/flash_protection/New()
	..()
	block = GLOB.noflashblock

#undef EAT_MOB_DELAY
