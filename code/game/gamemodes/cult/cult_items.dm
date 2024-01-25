/obj/item/tome
	name = "arcane tome"
	desc = "An old, dusty tome with frayed edges and a sinister-looking cover."
	icon_state = "tome"
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tome/New()
	if(SSticker.mode)
		icon_state = SSticker.cultdat.tome_icon
	..()

/obj/item/melee/cultblade
	name = "клинок культа"
	desc = "Магическое оружие, носимое последователями культа."
	icon = 'icons/obj/cult.dmi'
	icon_state = "blood_blade"
	item_state = "blood_blade"
	w_class = WEIGHT_CLASS_BULKY
	force = 30
	throwforce = 10
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sprite_sheets_inhand = list("Skrell" = 'icons/mob/clothing/species/skrell/held.dmi') // To stop skrell stabbing themselves in the head

/obj/item/melee/cultblade/New()
	if(SSticker.mode)
		icon_state = SSticker.cultdat.sword_icon
		item_state = SSticker.cultdat.sword_icon
	..()

/obj/item/melee/cultblade/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Этот клинок очень мощный, способный в лёгкую отрезать конечности. Неверующие не могут использовать данное оружие. Удар по неверующему во время их ослабления с помощью Магией Крови полностью оглушит их.</span>"

/obj/item/melee/cultblade/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.Weaken(10 SECONDS)
		user.unEquip(src, 1)
		user.visible_message("<span class='warning'>Мощная сила отталкивает [user] от [target]!</span>",
							"<span class='cultlarge'>\"Тебе не стоит играть с острыми предметами, можешь вырезать чьи-то глаза ненароком.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick("l_arm", "r_arm"))
		else
			user.adjustBruteLoss(rand(force/2, force))
		return
	if(!iscultist(target))
		var/datum/status_effect/cult_stun_mark/S = target.has_status_effect(STATUS_EFFECT_CULT_STUN)
		if(S)
			S.trigger()
	..()

/obj/item/melee/cultblade/pickup(mob/living/user)
	. = ..()
	if(!iscultist(user))
		to_chat(user, "<span class='cultlarge'>\"Я бы не советовал.\"</span>")
		to_chat(user, "<span class='warning'>Непреодолимое чувство тошноты овладевает вами!</span>")
		user.Confused(20 SECONDS)
		user.Jitter(12 SECONDS)

	if(HAS_TRAIT(user, TRAIT_HULK))
		to_chat(user, "<span class='danger'>You can't seem to hold the blade properly!</span>")
		user.unEquip(src, TRUE)

/obj/item/restraints/legcuffs/bola/cult
	name = "руническая бола"
	desc = "Сильная бола, связанная тёмной магией. Киньте её для замедления и опрокидывания жертвы. Не будет задевать соратников-культистов."
	icon_state = "bola_cult"
	item_state = "bola_cult"
	breakouttime = 45
	knockdown_duration = 2 SECONDS

/obj/item/restraints/legcuffs/bola/cult/throw_at(atom/target, range, speed, mob/thrower, spin, diagonals_first, datum/callback/callback)
	if(thrower && !iscultist(thrower)) // A couple of objs actually proc throw_at, so we need to make sure that yes, we got tossed by a person before trying to send a message
		thrower.visible_message("<span class='danger'>Бола светится и отскакивает обратно в [thrower]!</span>")
		throw_impact(thrower)
	. = ..()

/obj/item/restraints/legcuffs/bola/cult/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(iscultist(hit_atom))
		hit_atom.visible_message("<span class='warning'>[src] отскакивает от [hit_atom], будто отталкиваемый невидимой силой!</span>")
		return
	. = ..()

/obj/item/clothing/head/hooded/culthood
	name = "капюшон культиста"
	icon_state = "culthood"
	desc = "капюшон, носимый последователями культа."
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = 20, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 0, RAD = 0, FIRE = 5, ACID = 5)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	magical = TRUE

/obj/item/clothing/head/hooded/culthood/alt
	icon_state = "cult_hoodalt"
	item_state = "cult_hoodalt"


/obj/item/clothing/suit/hooded/cultrobes
	name = "роба культа"
	desc = "набор бронированной робы, носимые последователями культа."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/culthood
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor = list(MELEE = 35, BULLET = 20, LASER = 35, ENERGY = 10, BOMB = 15, RAD = 0, FIRE = 5, ACID = 5)
	flags_inv = HIDEJUMPSUIT
	magical = TRUE

/obj/item/clothing/suit/hooded/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"
	hoodtype = /obj/item/clothing/head/hooded/culthood/alt

/obj/item/clothing/head/helmet/space/cult
	name = "шлем культа"
	desc = "A space worthy helmet used by the followers of a cult."
	icon_state = "cult_helmet"
	item_state = "cult_helmet"
	armor = list(MELEE = 115, BULLET = 50, LASER = 20, ENERGY = 10, BOMB = 20, RAD = 20, FIRE = 35, ACID = 150)
	magical = TRUE
	sprite_sheets = list("Vox" = 'icons/mob/clothing/species/vox/head.dmi')

/obj/item/clothing/suit/space/cult
	name = "броня культа"
	icon_state = "cult_armour"
	item_state = "cult_armour"
	desc = "A bulky suit of armor, bristling with spikes. It looks space proof."
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade, /obj/item/tank/internals)
	slowdown = 1
	armor = list(MELEE = 115, BULLET = 50, LASER = 20, ENERGY = 10, BOMB = 20, RAD = 20, FIRE = 35, ACID = 150)
	magical = TRUE
	sprite_sheets = list("Vox" = 'icons/mob/clothing/species/vox/suit.dmi')

/obj/item/clothing/suit/hooded/cultrobes/cult_shield
	name = "усиленная роба культиста"
	desc = "Усиленное одеяние, создающее щит вокруг носителя."
	icon_state = "cult_armour"
	item_state = "cult_armour"
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 50, BULLET = 35, LASER = 50, ENERGY = 20, BOMB = 50, RAD = 20, FIRE = 50, ACID = 75)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie

/obj/item/clothing/head/hooded/cult_hoodie
	name = "Усиленный капюшон культиста"
	desc = "Усиленное одеяние, создающее щит вокруг носителя."
	icon_state = "cult_hoodalt"
	armor = list(MELEE = 35, BULLET = 20, LASER = 35, ENERGY = 10, BOMB = 15, RAD = 0, FIRE = 5, ACID = 5)
	body_parts_covered = HEAD
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	flags_cover = HEADCOVERSEYES
	magical = TRUE

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/equipped(mob/living/user, slot)
	..()
	if(!iscultist(user)) // Todo: Make this only happen when actually equipped to the correct slot. (For all cult items)
		to_chat(user, "<span class='cultlarge'>\"Я бы не советовал.\"</span>")
		to_chat(user, "<span class='warning'>Непреодолимое чувство тошноты овладевает вами!</span>")
		user.unEquip(src, 1)
		user.Confused(20 SECONDS)
		user.Weaken(10 SECONDS)


/obj/item/clothing/suit/hooded/cultrobes/cult_shield/setup_shielding()
	AddComponent(/datum/component/shielded, recharge_start_delay = 0 SECONDS, shield_icon_file = 'icons/effects/cult_effects.dmi', shield_icon = "shield-cult", run_hit_callback = CALLBACK(src, PROC_REF(shield_damaged)))

/// A proc for callback when the shield breaks, since cult robes are stupid and have different effects
/obj/item/clothing/suit/hooded/cultrobes/cult_shield/proc/shield_damaged(mob/living/wearer, attack_text, new_current_charges)
	wearer.visible_message("<span class='danger'>[attack_text] был отражён со всплеском кровавокрасных вспышек!</span>")
	new /obj/effect/temp_visual/cult/sparks(get_turf(wearer))
	if(new_current_charges == 0)
		wearer.visible_message("<span class='danger'>Рунический щит вокруг [wearer] внезапно исчез!</span>")

/obj/item/clothing/suit/hooded/cultrobes/flagellant_robe
	name = "Роба флагелланта"
	desc = "Окровавленная роба, пропитанная тёмной магией; позволяет носителю двигаться с нечеловеческой скоростью, но взамен носитель получает увеличенный урон."
	icon_state = "flagellantrobe"
	item_state = "flagellantrobe"
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(MELEE = -25, BULLET = -25, LASER = -25, ENERGY = -25, BOMB = -25, RAD = -25, FIRE = 0, ACID = 0)
	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/suit.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/suit.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/suit.dmi'
		)
	hoodtype = /obj/item/clothing/head/hooded/flagellant_hood


/obj/item/clothing/suit/hooded/cultrobes/flagellant_robe/equipped(mob/living/user, slot)
	..()
	if(!iscultist(user))
		to_chat(user, "<span class='cultlarge'>\"Я бы не советовал.\"</span>")
		to_chat(user, "<span class='warning'>Непреодолимое чувство тошноты овладевает вами!</span>")
		user.unEquip(src, 1)
		user.Confused(20 SECONDS)
		user.Weaken(10 SECONDS)
	else if(slot == SLOT_HUD_OUTER_SUIT)
		ADD_TRAIT(user, TRAIT_GOTTAGOFAST, "cultrobes[UID()]")

/obj/item/clothing/suit/hooded/cultrobes/flagellant_robe/dropped(mob/user)
	. = ..()
	if(user)
		REMOVE_TRAIT(user, TRAIT_GOTTAGOFAST, "cultrobes[UID()]")

/obj/item/clothing/head/hooded/flagellant_hood
	name = "Роба флагелланта"
	desc = "Окровавленная роба, пропитанная тёмной магией; позволяет носителю двигаться с нечеловеческой скоростью, но взамен носитель получает увеличенный урон."
	icon_state = "flagellanthood"
	item_state = "flagellanthood"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = -25, BULLET = -25, LASER = -25, ENERGY = -25, BOMB = -25, RAD = -25, FIRE = 0, ACID = 0)
	sprite_sheets = list(
		"Vox" = 'icons/mob/clothing/species/vox/head.dmi',
		"Drask" = 'icons/mob/clothing/species/drask/head.dmi',
		"Grey" = 'icons/mob/clothing/species/grey/head.dmi'
		)

/obj/item/whetstone/cult
	name = "Точильный камень древних"
	desc = "блок, усиленный тёмной магией. Острое оружие будет усилено при использовании на камне."
	icon_state = "cult_sharpener"
	increment = 5
	max = 40
	prefix = "darkened"
	claw_damage_increase = 4

/obj/item/whetstone/cult/update_icon_state()
	icon_state = "cult_sharpener[used ? "_used" : ""]"

/obj/item/whetstone/cult/attackby(obj/item/I, mob/user, params)
	..()
	if(used)
		to_chat(user, "<span class='notice'>[src] крошится в пепел.</span>")
		qdel(src)

/obj/item/reagent_containers/drinks/bottle/unholywater
	name = "flask of unholy water"
	desc = "Toxic to nonbelievers; this water renews and reinvigorates the faithful of a cult."
	icon_state = "holyflask"
	color = "#333333"
	list_reagents = list("unholywater" = 40)

/obj/item/clothing/glasses/hud/health/night/cultblind
	name = "Повязка фанатика"
	desc = "Позволяет мастеру направлять вас во тьме и оберегает от света."
	icon_state = "blindfold"
	item_state = "blindfold"
	see_in_dark = 8
	invis_override = SEE_INVISIBLE_HIDDEN_RUNES
	flash_protect = FLASH_PROTECTION_FLASH
	prescription = TRUE
	origin_tech = null

/obj/item/clothing/glasses/hud/health/night/cultblind/equipped(mob/living/user, slot)
	..()
	if(!iscultist(user))
		to_chat(user, "<span class='cultlarge'>\"Ты хочешь ослепнуть, не так ли?\"</span>")
		user.unEquip(src, 1)
		user.Confused(60 SECONDS)
		user.Weaken(10 SECONDS)
		user.EyeBlind(60 SECONDS)

/obj/item/shuttle_curse
	name = "Проклятая сфера"
	desc = "Вы заглядываете в дымчатую сферу и видите ужасные судьбы, постигшие спасательный шаттл."
	icon = 'icons/obj/cult.dmi'
	icon_state ="shuttlecurse"
	var/global/curselimit = 0

/obj/item/shuttle_curse/attack_self(mob/living/user)
	if(!iscultist(user))
		user.unEquip(src, 1)
		user.Weaken(10 SECONDS)
		to_chat(user, "<span class='warning'>Мощная сила отталкивает вас от [src]!</span>")
		return
	if(curselimit > 1)
		to_chat(user, "<span class='notice'>Мы исчерпали возможность проклясть эвакуационный шаттл.</span>")
		return
	if(locate(/obj/singularity/narsie) in GLOB.poi_list || locate(/mob/living/simple_animal/demon/slaughter/cult) in GLOB.mob_list)
		to_chat(user, "<span class='danger'>Нар'Си или её аватары уже в этом мире, нельзя отсрочить конец всего сущего.</span>")
		return

	if(SSshuttle.emergency.mode == SHUTTLE_CALL)
		var/cursetime = 3 MINUTES
		var/timer = SSshuttle.emergency.timeLeft(1) + cursetime
		SSshuttle.emergency.setTimer(timer)
		to_chat(user,"<span class='danger'>Вы разбиваете сферу!Тёмная эссенция закручивается в спираль, затем исчезает.</span>")
		playsound(user.loc, 'sound/effects/glassbr1.ogg', 50, TRUE)
		curselimit++
		var/message = pick(CULT_CURSES)
		GLOB.major_announcement.Announce("[message] Эвакуационный шаттл задерживается на [cursetime / 600] минут(-ы).", "ВНИМАНИЕ: Обнаружена неисправность в системе.", 'sound/misc/notice1.ogg')
		qdel(src)

/obj/item/cult_shift
	name = "Сдвигатель завесы"
	desc = "Эта реликвия позволяет вам телепортироваться вперед на среднюю дистанцию."
	icon = 'icons/obj/cult.dmi'
	icon_state ="shifter"
	var/uses = 4

/obj/item/cult_shift/examine(mob/user)
	. = ..()
	if(uses)
		. += "<span class='cult'>Остал[uses > 1 ? "ся" : "ось"] [uses] use[uses > 1 ? "ов" : ""].</span>"
	else
		. += "<span class='cult'>Кажется исчерпанным.</span>"

/obj/item/cult_shift/proc/handle_teleport_grab(turf/T, mob/user)
	var/mob/living/carbon/C = user
	if(C.pulling)
		var/atom/movable/pulled = C.pulling
		var/turf/turf_behind = get_turf(get_step(T, turn(C.dir, 180)))
		if(!pulled.anchored) //Item may have been anchored while pulling, and pulling state isn't updated until you move away, so we double check.
			pulled.forceMove(turf_behind)
			. = pulled

/obj/item/cult_shift/attack_self(mob/user)

	if(!uses || !iscarbon(user))
		to_chat(user, "<span class='warning'>[src] пуст и не двигается в ваших руках.</span>")
		return
	if(!iscultist(user))
		user.unEquip(src, TRUE)
		step(src, pick(GLOB.alldirs))
		to_chat(user, "<span class='warning'>[src] выскакивает из ваших рук, чрезмерно хотя сместиться!</span>")
		return
	if(user.holy_check())
		return
	var/outer_tele_radius = 9

	var/mob/living/carbon/C = user
	var/list/turfs = list()
	for(var/turf/T in orange(user, outer_tele_radius))
		if(!is_teleport_allowed(T.z))
			break
		if(get_dir(C, T) != C.dir) // This seems like a very bad way to do this
			continue
		if(isspaceturf(T))
			continue
		if(T.x > world.maxx-outer_tele_radius || T.x < outer_tele_radius)
			continue	//putting them at the edge is dumb
		if(T.y > world.maxy-outer_tele_radius || T.y < outer_tele_radius)
			continue
		turfs += T

	if(length(turfs))
		uses--
		var/turf/mobloc = get_turf(C)
		var/turf/destination = pick(turfs)
		if(uses <= 0)
			icon_state = "shifter_drained"
		playsound(src, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		new /obj/effect/temp_visual/dir_setting/cult/phase/out(mobloc, C.dir)

		handle_teleport_grab(destination, C)
		C.forceMove(destination)

		new /obj/effect/temp_visual/dir_setting/cult/phase(destination, C.dir)
		playsound(destination, 'sound/effects/phasein.ogg', 25, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		playsound(destination, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

	else
		to_chat(C, "<span class='danger'>Завеса не может быть разорвана тут!</span>")

/obj/item/melee/cultblade/ghost
	name = "Меч древних"
	force = 15
	flags = NODROP | DROPDEL

/obj/item/clothing/head/hooded/culthood/alt/ghost
	flags = NODROP | DROPDEL

/obj/item/clothing/suit/cultrobesghost
	name = "Призрачная роба культиста"
	desc = "Набор эфемерной бронированной робы, носимая нежитью культа."
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor = list(MELEE = 50, BULLET = 20, LASER = 50, ENERGY = 10, BOMB = 15, RAD = 0, FIRE = 5, ACID = 5)
	flags_inv = HIDEJUMPSUIT
	flags = NODROP | DROPDEL


/obj/item/clothing/shoes/cult/ghost
	flags = NODROP | DROPDEL

/obj/item/clothing/under/color/black/ghost
	flags = NODROP | DROPDEL

/datum/outfit/ghost_cultist
	name = "Призрак культист"

	uniform = /obj/item/clothing/under/color/black/ghost
	suit = /obj/item/clothing/suit/cultrobesghost
	shoes = /obj/item/clothing/shoes/cult/ghost
	head = /obj/item/clothing/head/hooded/culthood/alt/ghost
	r_hand = /obj/item/melee/cultblade/ghost

/obj/item/shield/mirror
	name = "зеркальный щит"
	desc = "Печально известный щит, используемый древними сектами для запутывания и дизориентации врагов."
	icon = 'icons/obj/cult.dmi'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	icon_state = "mirror_shield"
	item_state = "mirror_shield"
	force = 5
	throwforce = 15
	throw_speed = 1
	throw_range = 3
	attack_verb = list("bumped", "prodded")
	hitsound = 'sound/weapons/smash.ogg'
	/// Chance that energy projectiles will be reflected
	var/reflect_chance = 70
	/// The number of clone illusions remaining
	var/illusions = 2

	// Any damage higher than these values will have a chance to shatter the shield
	/// Shatter threshold for Ballistic weapons
	var/ballistic_threshold = 10
	/// Shatter threshold for Energy weapons
	var/energy_threshold = 20

/obj/item/shield/mirror/Initialize(mapload)
	. = ..()
	GLOB.mirrors += src

/obj/item/shield/mirror/Destroy()
	GLOB.mirrors -= src
	return ..()

/**
  * Reflect/Block/Shatter proc.
  *
  * Projectiles:
  * If you have been hit by a projectile, the 'threshold' will be set depending on the damage type.
  * By default, energy weapons have a 70% chance of being reflected, so you're going to want to use ballistics against mirror shields. (Reflection is calculated beforehand in [/mob/living/carbon/human/bullet_act])
  * For every point of damage above the threshold, the shield will have a 3% chance to shatter. (Up to a maximum of 75%)
  * If a ballistic projectile doesn't shatter the shield, it will move on to the melee section.
  *
  * Melee and blocked projectiles:
  * Melee attacks and bullets have a 50|50 chance of being blocked by the mirror shield. (Based on the 'block_chance' variable)
  * If they are blocked, and the shield has an illusion charge, an illusion will be spawned at src.
  * The illusion has a 60% chance to be hostile and attack non-cultists, and a 40% chance to just run away from the user.
  */
/obj/item/shield/mirror/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	// Incase they get one by some magic
	if(!SSticker.cultdat.mirror_shields_active)
		to_chat(owner, "<span class='warning'>Этот щит бессилен! Вы должны провести необходимую жертву для его усиления!</span>")
		return

	if(iscultist(owner) && !owner.holy_check()) // Cultist holding the shield

		// Hit by a projectile
		if(istype(hitby, /obj/item/projectile))
			var/obj/item/projectile/P = hitby
			var/shatter_chance = 0 // Percent chance of the shield shattering on a projectile hit
			var/threshold // Depends on the damage Type (Brute or Burn)
			if(P.damage_type == BRUTE)
				threshold = ballistic_threshold
			else if(P.damage_type == BURN)
				threshold = energy_threshold
			else
				return FALSE
			// Assuming the projectile damage is 20 (WT-550), 'shatter_chance' will be 10
			// 10 * 3 gives it a 30% chance to shatter per hit.
			shatter_chance = min((P.damage - threshold) * 3, 75) // Maximum of 75% chance

			if(prob(shatter_chance) || P.shield_buster)
				var/turf/T = get_turf(owner)
				T.visible_message("<span class='warning'>Чистая сила от [P] разбивает зеркальный щит!</span>")
				new /obj/effect/temp_visual/cult/sparks(T)
				playsound(T, 'sound/effects/glassbr3.ogg', 100)
				owner.Weaken(6 SECONDS)
				qdel(src)
				return FALSE

			if(P.is_reflectable(REFLECTABILITY_ENERGY))
				return FALSE //To avoid reflection chance double-dipping with block chance

		// Hit by a melee weapon or blocked a projectile
		. = ..()
		if(.) // they did parry the attack
			playsound(src, 'sound/weapons/parry.ogg', 100, TRUE)
			if(illusions > 0)
				illusions--
				addtimer(CALLBACK(src, PROC_REF(readd)), 45 SECONDS)
				if(prob(60))
					spawn_illusion(owner, TRUE) // Hostile illusion
				else
					spawn_illusion(owner, FALSE) // Running illusion
			return TRUE

	else // Non-cultist holding the shield
		if(prob(50))
			spawn_illusion(owner, TRUE, TRUE)
		return FALSE

/obj/item/shield/mirror/proc/spawn_illusion(mob/living/carbon/human/user, hostile, betray)
	if(hostile)
		var/mob/living/simple_animal/hostile/illusion/cult/H = new(user.loc)
		H.faction = list("cult")
		if(!betray)
			H.Copy_Parent(user, 70, 10, 5)
		else
			H.Copy_Parent(user, 100, 20, 5)
			H.GiveTarget(user)
			to_chat(user, "<span class='danger'>[src] предаёт вас!</span>")
	else
		var/mob/living/simple_animal/hostile/illusion/escape/cult/E = new(user.loc)
		E.Copy_Parent(user, 70, 10)
		E.GiveTarget(user)
		E.Goto(user, E.move_to_delay, E.minimum_distance)

/obj/item/shield/mirror/proc/readd()
	if(illusions < initial(illusions))
		illusions++
	else if(isliving(loc))
		var/mob/living/holder = loc
		if(iscultist(holder))
			to_chat(holder, "<span class='cultitalic'>Иллюзии щита заряжены в полную силу!</span>")
		else
			to_chat(holder, "<span class='warning'>[src] слегка вибрирует и начинает светиться.")

/obj/item/shield/mirror/IsReflect()
	if(prob(reflect_chance))
		if(ismob(loc))
			var/mob/user = loc
			if(user.holy_check())
				return FALSE
		return TRUE
	return FALSE

/obj/item/cult_spear
	name = "Кровавая алебарда"
	desc = "Тошнотворное копье, состоящее полностью из кристаллизированной крови. Будет оглушать недавно помеченных людей, если копьё находится в руках."
	icon = 'icons/obj/cult.dmi'
	lefthand_file = 'icons/mob/inhands/weapons_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons_righthand.dmi'
	base_icon_state = "bloodspear"
	icon_state = "bloodspear0"
	slot_flags = 0
	force = 17
	throwforce = 30
	throw_speed = 2
	armour_penetration_percentage = 50
	attack_verb = list("атаковал", "проткнул", "воткнул", "разорвал", "выпотрошил")
	sharp = TRUE
	no_spin_thrown = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	needs_permit = TRUE
	var/datum/action/innate/cult/spear/spear_act

/obj/item/cult_spear/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/parry, _stamina_constant = 2, _stamina_coefficient = 0.4, _parryable_attack_types = ALL_ATTACK_TYPES, _parry_cooldown = (2 / 3) SECONDS ) // 0.666667 seconds for 60% uptime.
	AddComponent(/datum/component/two_handed, force_wielded = 24, force_unwielded = force, icon_wielded = "[base_icon_state]1")

/obj/item/cult_spear/Destroy()
	if(spear_act)
		qdel(spear_act)
	return ..()

/obj/item/cult_spear/update_icon_state()
	icon_state = "[base_icon_state]0"

/obj/item/cult_spear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(iscultist(L))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			if(!L.restrained() && L.put_in_active_hand(src))
				L.visible_message("<span class='warning'>[L] ловит [src] из ниоткуда!</span>")
			else
				L.visible_message("<span class='warning'>[src] отскакивает от [L], как будто отталкиваемый невидимой силой!</span>")
		else if(!..())
			if(L.null_rod_check())
				return
			var/datum/status_effect/cult_stun_mark/S = L.has_status_effect(STATUS_EFFECT_CULT_STUN)
			if(S)
				S.trigger()
			else
				L.KnockDown(10 SECONDS)
				L.adjustStaminaLoss(60)
				L.apply_status_effect(STATUS_EFFECT_CULT_STUN)
				L.flash_eyes(1, TRUE)
				if(issilicon(L))
					L.emp_act(EMP_HEAVY)
				else if(iscarbon(L))
					L.Silence(6 SECONDS)
					L.Stuttering(16 SECONDS)
					L.CultSlur(20 SECONDS)
					L.Jitter(16 SECONDS)
			break_spear(T)
	else
		..()

/obj/item/cult_spear/proc/break_spear(turf/T)
	if(!T)
		T = get_turf(src)
	if(T)
		T.visible_message("<span class='warning'>[src] shatters and melts back into blood!</span>")
		new /obj/effect/temp_visual/cult/sparks(T)
		new /obj/effect/decal/cleanable/blood/splatter(T)
		playsound(T, 'sound/effects/glassbr3.ogg', 100)
	qdel(src)

/obj/item/cult_spear/attack(mob/living/M, mob/living/user, def_zone)
	. = ..()
	var/datum/status_effect/cult_stun_mark/S = M.has_status_effect(STATUS_EFFECT_CULT_STUN)
	if(S && HAS_TRAIT(src, TRAIT_WIELDED))
		S.trigger()

/datum/action/innate/cult/spear
	name = "Кровавая связь"
	desc = "Призовите кровавую алебарду обратно в руку!"
	background_icon_state = "bg_cult"
	button_icon_state = "bloodspear"
	var/obj/item/cult_spear/spear
	var/cooldown = 0

/datum/action/innate/cult/spear/Grant(mob/user, obj/blood_spear)
	. = ..()
	spear = blood_spear

/datum/action/innate/cult/spear/Activate()
	if(owner == spear.loc || cooldown > world.time || owner.holy_check())
		return
	var/ST = get_turf(spear)
	var/OT = get_turf(owner)
	if(get_dist(OT, ST) > 10)
		to_chat(owner,"<span class='warning'>Копьё слишком далеко!</span>")
	else
		cooldown = world.time + 20
		if(isliving(spear.loc))
			var/mob/living/L = spear.loc
			L.unEquip(spear)
			L.visible_message("<span class='warning'>Невидимая сила тянет копьё из рук [L]!</span>")
		spear.throw_at(owner, 10, 2, null, dodgeable = FALSE)

/obj/item/gun/projectile/shotgun/boltaction/enchanted/arcane_barrage/blood
	name = "Снаряд Кровавого Шквала"
	desc = "Кровь за кровь."
	item_state = "disintegrate"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	color = "#ff0000"
	guns_left = 24
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage/blood
	fire_sound = 'sound/magic/wand_teleport.ogg'
	flags = NOBLUDGEON | DROPDEL

/obj/item/gun/projectile/shotgun/boltaction/enchanted/arcane_barrage/blood/afterattack(atom/target, mob/living/user, flag, params)
	if(user.holy_check())
		return
	..()


/obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage/blood
	ammo_type = /obj/item/ammo_casing/magic/arcane_barrage/blood

/obj/item/ammo_casing/magic/arcane_barrage/blood
	projectile_type = /obj/item/projectile/magic/arcane_barrage/blood
	muzzle_flash_effect = /obj/effect/temp_visual/emp/cult

/obj/item/projectile/magic/arcane_barrage/blood
	name = "кровавый шквал"
	icon_state = "blood_bolt"
	damage_type = BRUTE
	impact_effect_type = /obj/effect/temp_visual/dir_setting/bloodsplatter
	hitsound = 'sound/effects/splat.ogg'

/obj/item/projectile/magic/arcane_barrage/blood/prehit(atom/target)
	if(iscultist(target))
		damage = 0
		nodamage = TRUE
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.stat != DEAD)
				H.reagents.add_reagent("unholywater", 4)
		if(isshade(target) || isconstruct(target))
			var/mob/living/simple_animal/M = target
			if(M.health + 5 < M.maxHealth)
				M.adjustHealth(-5)
		new /obj/effect/temp_visual/cult/sparks(target)
	..()

/obj/item/blood_orb
	name = "кровавая сфера"
	icon = 'icons/obj/cult.dmi'
	icon_state = "summoning_orb"
	item_state = "summoning_orb"
	desc = "Сфера кристализованной крови. Может быть использована для передачи крови между культистами."
	var/blood = 50

/obj/item/portal_amulet
	name = "reality sunderer"
	icon = 'icons/obj/cult.dmi'
	icon_state = "amulet"
	desc = "Некий амулет, сделанный из металла, блюспейс кристаллов и крови. Позволяет культистам ставить порталы к рунам телепорта, уничтожая руну в процессе."
	w_class = WEIGHT_CLASS_SMALL


/obj/item/portal_amulet/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!iscultist(user))
		if(!iscarbon(user))
			return
		var/mob/living/carbon/M = user
		to_chat(M, "<span class='cultlarge'>\"Ну что, хочешь исследовать космос?\"</span>")
		to_chat(M, "<span class='warning'>Космос мерцает вокруг вас, и вы оказываетесь в другом месте!</span>")
		M.Confused(20 SECONDS)
		M.flash_eyes(override_blindness_check = TRUE)
		M.EyeBlind(20 SECONDS)
		do_teleport(M, get_turf(M), 5, sound_in = 'sound/magic/cult_spell.ogg')
		qdel(src)
		return

	if(istype(O, /obj/effect/rune))
		if(!istype(O, /obj/effect/rune/teleport))
			to_chat(user, "<span class='warning'>[src] только работает на рунах телепорта.</span>")
			return
		if(!proximity)
			to_chat(user, "<span class='warning'>Слишком далеко от руны телепорта.</span>")
			return
		var/obj/effect/rune/teleport/R = O
		attempt_portal(R, user)

/obj/item/portal_amulet/proc/attempt_portal(obj/effect/rune/teleport/R, mob/user)
	var/list/potential_runes = list()
	var/list/teleport_names = list()
	var/list/duplicate_rune_count = list()
	var/turf/T = get_turf(src) //used to tell the other rune where we came from

	for(var/I in GLOB.teleport_runes)
		var/obj/effect/rune/teleport/target = I
		var/result_key = target.listkey
		if(target == R || !is_level_reachable(target.z))
			continue
		if(result_key in teleport_names)
			duplicate_rune_count[result_key]++
			result_key = "[result_key] ([duplicate_rune_count[result_key]])"
		else
			teleport_names += result_key
			duplicate_rune_count[result_key] = 1
		potential_runes[result_key] = target

	if(!length(potential_runes))
		to_chat(user, "<span class='warning'>Нет валидных рун для телепорта!</span>")
		return

	if(!is_level_reachable(user.z))
		to_chat(user, "<span class='cultitalic'>Вы не в правильном измерении!</span>")
		return

	var/input_rune_key = tgui_input_list(user, "Выберите руну для постановки портала", "Портал до руны", potential_runes) //we know what key they picked
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(QDELETED(R) || QDELETED(actual_selected_rune) || !Adjacent(user) || user.incapacitated())
		return

	if(is_mining_level(R.z) && !is_mining_level(actual_selected_rune.z))
		actual_selected_rune.handle_portal("lava")
	else if(!is_station_level(R.z) || istype(get_area(src), /area/space))
		actual_selected_rune.handle_portal("space", T)
	new /obj/effect/portal/cult(get_turf(R), get_turf(actual_selected_rune), src, 4 MINUTES)
	to_chat(user, "<span class='cultitalic'>Вы используете амулет для превращения [R] в портал.</span>")
	playsound(src, 'sound/magic/cult_spell.ogg', 100, TRUE)
	qdel(R)
	qdel(src)

/obj/effect/portal/cult
	name = "Древний портал"
	desc = "Злой портал, сделанный из тёмной магии. На удивление стабилен."
	icon_state = "portal1"
	failchance = 0
	precision = FALSE
	var/obj/effect/cult_portal_exit/exit = null

/obj/effect/portal/cult/Initialize(mapload, target, creator, lifespan)
	. = ..()
	if(target)
		exit = new /obj/effect/cult_portal_exit(target)

/obj/effect/portal/cult/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/melee/cultblade/dagger) && iscultist(user) || istype(I, /obj/item/nullrod) && HAS_MIND_TRAIT(user, TRAIT_HOLY))
		to_chat(user, "<span class='notice'>Вы закрываете портал с помощью [I].</span>")
		playsound(src, 'sound/magic/magic_missile.ogg', 100, TRUE)
		qdel(src)
		return
	return ..()

/obj/effect/portal/cult/Destroy()
	QDEL_NULL(exit)
	return ..()

/obj/effect/cult_portal_exit
	name = "eldritch rift"
	desc = "Точка выхода из какого-то портала. Будьте начеку, из него может выйти ещё что-то."
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	color = "red"
