/datum/action/innate/cult/blood_magic //Blood magic handles the creation of blood spells (formerly talismans)
	name = "Подготовить Магию Крови"
	button_icon_state = "carve"
	desc = "Подготовьте Магию Крови путём высечения рун на вашем теле. Это сделать проще с помощью <b>руны усиления</b>."
	var/list/spells = list()
	var/channeling = FALSE

/datum/action/innate/cult/blood_magic/Remove()
	for(var/X in spells)
		qdel(X)
	..()

/datum/action/innate/cult/blood_magic/override_location()
	button.ordered = FALSE
	button.screen_loc = DEFAULT_BLOODSPELLS
	button.moved = DEFAULT_BLOODSPELLS

/datum/action/innate/cult/blood_magic/proc/Positioning()
	var/list/screen_loc_split = splittext(button.screen_loc, ",")
	var/list/screen_loc_X = splittext(screen_loc_split[1], ":")
	var/list/screen_loc_Y = splittext(screen_loc_split[2], ":")
	var/pix_X = text2num(screen_loc_X[2])
	for(var/datum/action/innate/cult/blood_spell/B in spells)
		if(B.button.locked)
			var/order = pix_X + spells.Find(B) * 31
			B.button.screen_loc = "[screen_loc_X[1]]:[order],[screen_loc_Y[1]]:[screen_loc_Y[2]]"
			B.button.moved = B.button.screen_loc

/datum/action/innate/cult/blood_magic/Activate()
	var/rune = FALSE
	var/limit = RUNELESS_MAX_BLOODCHARGE
	for(var/obj/effect/rune/empower/R in range(1, owner))
		rune = TRUE
		limit = MAX_BLOODCHARGE
		break
	if(length(spells) >= limit)
		if(rune)
			to_chat(owner, "<span class='cultitalic'>Вы не можете хранить более [MAX_BLOODCHARGE] заклинаний. <b>Выберите заклинание для удаления.</b></span>")
			remove_spell("Вы не можете хранить более [MAX_BLOODCHARGE] заклинаний, выберите заклинание для удаления.")
		else
			to_chat(owner, "<span class='cultitalic'>Вы не можете хранить более [RUNELESS_MAX_BLOODCHARGE] spell\s без руны усиления! <b>выберите заклинание для удаления.</b></span>")
			remove_spell("Вы не можете хранить более [RUNELESS_MAX_BLOODCHARGE] заклинаний без руны усиления, выберите заклинание для удаления.")
		return
	var/entered_spell_name
	var/datum/action/innate/cult/blood_spell/BS
	var/list/possible_spells = list()

	for(var/I in subtypesof(/datum/action/innate/cult/blood_spell))
		var/datum/action/innate/cult/blood_spell/J = I
		var/cult_name = initial(J.name)
		possible_spells[cult_name] = J
	if(length(spells))
		possible_spells += "(УДАЛИТЬ ЗАКЛИНАНИЕ)"
	entered_spell_name = tgui_input_list(owner, "Выберите заклинание для подготовки...", "Выбор Заклинаний", possible_spells)
	if(entered_spell_name == "(УДАЛИТЬ ЗАКЛИНАНИЕ)")
		remove_spell()
		return
	BS = possible_spells[entered_spell_name]
	if(QDELETED(src) || owner.incapacitated() || !BS || (rune && !(locate(/obj/effect/rune/empower) in range(1, owner))) || (length(spells) >= limit))
		return

	if(!channeling)
		channeling = TRUE
		to_chat(owner, "<span class='cultitalic'>Вы начинаете высекать неестественные символы на теле!</span>")
	else
		to_chat(owner, "<span class='warning'>You are already invoking blood magic!</span>")
		return

	if(do_after(owner, 100 - rune * 60, target = owner))
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			if(H.dna && (NO_BLOOD in H.dna.species.species_traits))
				H.cult_self_harm(3 - rune * 2)
			else
				H.bleed(20 - rune * 12)
		var/datum/action/innate/cult/blood_spell/new_spell = new BS(owner)
		spells += new_spell
		new_spell.Grant(owner, src)
		to_chat(owner, "<span class='cult'>Ваши раны сияют мощью, вы подготовили заклинание [new_spell.name]!</span>")
		SSblackbox.record_feedback("tally", "cult_spells_prepared", 1, "[new_spell.name]")
	channeling = FALSE

/datum/action/innate/cult/blood_magic/proc/remove_spell()
	var/nullify_spell = tgui_input_list(owner, "Выберите заклинание для удаления", "Текущие заклинания", spells)
	if(nullify_spell)
		qdel(nullify_spell)

/datum/action/innate/cult/blood_spell //The next generation of talismans, handles storage/creation of blood magic
	name = "Магия Крови"
	button_icon_state = "telerune"
	desc = "Бойся старой крови..."
	var/charges = 1
	var/magic_path = null
	var/obj/item/melee/blood_magic/hand_magic
	var/datum/action/innate/cult/blood_magic/all_magic
	var/base_desc //To allow for updating tooltips
	var/invocation = "Эй, что-то пошло не так!"
	var/health_cost = 0

/datum/action/innate/cult/blood_spell/Grant(mob/living/owner, datum/action/innate/cult/blood_magic/BM)
	if(health_cost)
		desc += "<br>Наносит <u>[health_cost] урона</u> руке при использовании."
	base_desc = desc
	desc += "<br><b><u>Осталось [charges] зарядов.</u></b>."
	all_magic = BM
	button.ordered = FALSE
	..()

/datum/action/innate/cult/blood_spell/override_location()
	button.locked = TRUE
	all_magic.Positioning()

/datum/action/innate/cult/blood_spell/Remove()
	if(all_magic)
		all_magic.spells -= src
	if(hand_magic)
		qdel(hand_magic)
		hand_magic = null
	..()

/datum/action/innate/cult/blood_spell/IsAvailable()
	if(!iscultist(owner) || owner.incapacitated() || !charges)
		return FALSE
	return ..()

/datum/action/innate/cult/blood_spell/Activate()
	if(owner.holy_check())
		return
	if(magic_path) // If this spell flows from the hand
		if(!hand_magic) // If you don't already have the spell active
			hand_magic = new magic_path(owner, src)
			if(!owner.put_in_hands(hand_magic))
				qdel(hand_magic)
				hand_magic = null
				to_chat(owner, "<span class='warning'>Ваша рука должна быть пустой для подготовки Магии Крови!</span>")
				return
			to_chat(owner, "<span class='cultitalic'>Ваши раны сияют в то время, как вы подготовили [name].</span>")

		else // If the spell is active, and you clicked on the button for it
			qdel(hand_magic)
			hand_magic = null

//the spell list

/datum/action/innate/cult/blood_spell/stun
	name = "Оглушение"
	desc = "Ослабит и обеззвучит жертву. Ударьте её кинжалом культа, полностью оглушая и продлевая её беззвучие."
	button_icon_state = "stun"
	magic_path = /obj/item/melee/blood_magic/stun
	health_cost = 10

/datum/action/innate/cult/blood_spell/teleport
	name = "Телепорт"
	desc = "Усиливает вашу руку, позволяя вам телепортировать себя или другого культиста на руну Телепорта."
	button_icon_state = "teleport"
	magic_path = /obj/item/melee/blood_magic/teleport
	health_cost = 7

/datum/action/innate/cult/blood_spell/emp
	name = "Электромагнитный импульс"
	desc = "Выпускает ЭМИ, который будет воздействовать на ближайших некультистов. <b>Импульс будет воздействовать и на вас.</b>"
	button_icon_state = "emp"
	health_cost = 10
	invocation = "Ta'gh fara'qha fel d'amar det!"

/datum/action/innate/cult/blood_spell/emp/Grant(mob/living/owner)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/oof = FALSE
		for(var/obj/item/organ/external/E in H.bodyparts)
			if(E.is_robotic())
				oof = TRUE
				break
		if(!oof)
			for(var/obj/item/organ/internal/I in H.internal_organs)
				if(I.is_robotic())
					oof = TRUE
					break
		if(oof)
			to_chat(owner, "<span class='userdanger'>Вы чувствуете, что это плохая затея.</span>")
	..()

/datum/action/innate/cult/blood_spell/emp/Activate()
	if(owner.holy_check())
		return
	owner.visible_message("<span class='warning'>Тело [owner] мигает ярко-синим цветом!</span>", \
						"<span class='cultitalic'>Вы произносите проклятые слова, выпуская электромагнитный импульс из тела.</span>")
	owner.emp_act(2)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(empulse), owner, 2, 5, TRUE, "cult")
	owner.whisper(invocation)
	charges--
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/shackles
	name = "Теневые оковы"
	desc = "Позволяет вам заковать жертву при касании и обеззвучить их при успехе."
	button_icon_state = "shackles"
	charges = 4
	magic_path = /obj/item/melee/blood_magic/shackles

/datum/action/innate/cult/blood_spell/construction
	name = "Искаженное строительство"
	desc = "Позволяет вашей руке искажать определённые металлические конструкции.<br><u>Превращает:</u><br>Плассталь в рунический металл<br>50 металла в оболочку конструкта<br>Cyborg Оболочки киборгов в оболочки конструктов<br>Шлюзы в хрупкие рунические после небольшой задержки (интент харм)"
	button_icon_state = "transmute"
	magic_path = "/obj/item/melee/blood_magic/construction"
	health_cost = 12

/datum/action/innate/cult/blood_spell/dagger
	name = "Призыв кинжала"
	desc = "Призывает ритуальный кинжал, необходимый для начертания рун."
	button_icon_state = "cult_dagger"

/datum/action/innate/cult/blood_spell/dagger/New()
	if(SSticker.mode)
		button_icon_state = SSticker.cultdat.dagger_icon
	..()

/datum/action/innate/cult/blood_spell/dagger/Activate()
	var/turf/T = get_turf(owner)
	owner.visible_message("<span class='warning'>Рука [owner] на мгновение мигает красным.</span>", \
						"<span class='cultitalic'>Красный свет начинает мерцать и обретать форму в вашей руке!</span>")
	var/obj/item/melee/cultblade/dagger/O = new(T)
	if(owner.put_in_hands(O))
		to_chat(owner, "<span class='warning'>[O.name] появляется в вашей руке!</span>")
	else
		owner.visible_message("<span class='warning'>[O.name] появляется у ног [owner]!</span>", \
							"<span class='cultitalic'>[O.name] материализуется у ваших ног.</span>")
	playsound(owner, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(4))
	charges--
	desc = base_desc
	desc += "<br><b><u>Осталось [charges] заряд(-ов)</u></b>."
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/equipment
	name = "Призыв снаряжения"
	desc = "Позволяет призвать боевое снаряжение на культиста при касании, включая броню культа в открытые слоты, болу культа и меч культа."
	button_icon_state = "equip"
	magic_path = /obj/item/melee/blood_magic/armor

/datum/action/innate/cult/blood_spell/horror
	name = "Галлюцинации"
	desc = "Даёт жертве на расстоянии галлюцинации. Тихое и невидимое заклинание."
	button_icon_state = "horror"
	var/obj/effect/proc_holder/horror/PH
	charges = 4

/datum/action/innate/cult/blood_spell/horror/New()
	PH = new()
	PH.attached_action = src
	..()

/datum/action/innate/cult/blood_spell/horror/Destroy()
	var/obj/effect/proc_holder/horror/destroy = PH
	. = ..()
	if(!QDELETED(destroy))
		QDEL_NULL(destroy)

/datum/action/innate/cult/blood_spell/horror/Activate()
	PH.toggle(owner) //the important bit
	return TRUE

/obj/effect/proc_holder/horror
	active = FALSE
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	var/datum/action/innate/cult/blood_spell/attached_action

/obj/effect/proc_holder/horror/Destroy()
	var/datum/action/innate/cult/blood_spell/AA = attached_action
	. = ..()
	if(!QDELETED(AA))
		QDEL_NULL(AA)

/obj/effect/proc_holder/horror/proc/toggle(mob/user)
	if(active)
		remove_ranged_ability(user, "<span class='cult'>Вы рассеиваете магию...</span>")
	else
		add_ranged_ability(user, "<span class='cult'>Вы готовитесь напугать жертву...</span>")

/obj/effect/proc_holder/horror/InterceptClickOn(mob/living/user, params, atom/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated() || !iscultist(user))
		user.ranged_ability.remove_ranged_ability(user)
		return
	if(user.holy_check())
		return
	var/turf/T = get_turf(ranged_ability_user)
	if(!isturf(T))
		return FALSE
	if(target in view(7, ranged_ability_user))
		if(!ishuman(target) || iscultist(target))
			return
		var/mob/living/carbon/human/H = target
		H.Hallucinate(120 SECONDS)
		attached_action.charges--
		attached_action.desc = attached_action.base_desc
		attached_action.desc += "<br><b><u> Осталось [attached_action.charges] заряд(-ов)</u></b>."
		attached_action.UpdateButtonIcon()
		user.ranged_ability.remove_ranged_ability(user, "<span class='cult'><b>[H] был проклят живыми кошмарами!</b></span>")
		if(attached_action.charges <= 0)
			to_chat(ranged_ability_user, "<span class='cult'>Вы истощили силу заклинания!</span>")
			qdel(src)

/datum/action/innate/cult/blood_spell/veiling
	name = "Сокрытие присутствия"
	desc = "Переключается между сокрытием и показом ближайших построек, рун и шлюзов культа."
	invocation = "Kla'atu barada nikt'o!"
	button_icon_state = "veiling"
	charges = 10
	var/revealing = FALSE //if it reveals or not

/datum/action/innate/cult/blood_spell/veiling/Activate()
	if(owner.holy_check())
		return
	if(!revealing) // Hiding stuff
		owner.visible_message("<span class='warning'>Тонкая серая пыль сыпится из руки [owner]!</span>", \
		"<span class='cultitalic'>Вы используете заклинания сокрытия, скрывая руны, постройки и шлюзы культа.</span>")
		charges--
		if(!SSticker.mode.cult_risen || !SSticker.mode.cult_ascendant)
			playsound(owner, 'sound/magic/smoke.ogg', 25, TRUE, SOUND_RANGE_SET(4)) // If Cult is risen/ascendant.
		else
			playsound(owner, 'sound/magic/smoke.ogg', 25, TRUE, SOUND_RANGE_SET(1)) // If Cult is unpowered.
		owner.whisper(invocation)
		for(var/obj/O in range(4, owner))
			O.cult_conceal()
		revealing = TRUE // Switch on use
		name = "Reveal Runes"
		button_icon_state = "revealing"

	else // Unhiding stuff
		owner.visible_message("<span class='warning'>Из руки [owner] светит красная вспышка!</span>", \
		"<span class='cultitalic'>Вы используете контрзаклинание, проявляя все руны, постройки и шлюзы культа.</span>")
		charges--
		owner.whisper(invocation)
		if(!SSticker.mode.cult_risen || !SSticker.mode.cult_ascendant)
			playsound(owner, 'sound/misc/enter_blood.ogg', 25, TRUE, SOUND_RANGE_SET(7)) // If Cult is risen/ascendant.
		else
			playsound(owner, 'sound/magic/smoke.ogg', 25, TRUE, SOUND_RANGE_SET(1)) // If Cult is unpowered.
		for(var/obj/O in range(5, owner)) // Slightly higher in case we arent in the exact same spot
			O.cult_reveal()
		revealing = FALSE // Switch on use
		name = "Conceal Runes"
		button_icon_state = "veiling"
	if(charges <= 0)
		qdel(src)
	desc = "[revealing ? "Показывает" : "Скрывает"] ближайшие постройки, шлюзы и руны культа."
	desc += "<br><b><u>Has [charges] use\s remaining</u></b>."
	UpdateButtonIcon()

/datum/action/innate/cult/blood_spell/manipulation
	name = "Blood Rites"
	desc = "Empowers your hand to manipulate blood. Use on blood or a noncultist to absorb blood to be used later, use on yourself or another cultist to heal them using absorbed blood. \
		\nUse the spell in-hand to cast advanced rites, such as summoning a magical Кровавое копьё, firing blood projectiles out of your hands, and more!"
	invocation = "Fel'th Dol Ab'orod!"
	button_icon_state = "manip"
	charges = 5
	magic_path = /obj/item/melee/blood_magic/manipulator

// The "magic hand" items
/obj/item/melee/blood_magic
	name = "\improper magical aura"
	desc = "A sinister looking aura that distorts the flow of reality around it."
	icon = 'icons/obj/items.dmi'
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	icon_state = "disintegrate"
	item_state = "disintegrate"
	flags = ABSTRACT | DROPDEL

	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	/// Does it have a source, AKA bloody empowerment.
	var/has_source = TRUE
	var/invocation
	var/uses = 1
	var/health_cost = 0 //The amount of health taken from the user when invoking the spell
	var/datum/action/innate/cult/blood_spell/source

/obj/item/melee/blood_magic/New(loc, spell)
	if(has_source)
		source = spell
		uses = source.charges
		health_cost = source.health_cost
	..()

/obj/item/melee/blood_magic/Destroy()
	if(has_source && !QDELETED(source))
		if(uses <= 0)
			source.hand_magic = null
			qdel(source)
			source = null
		else
			source.hand_magic = null
			source.charges = uses
			source.desc = source.base_desc
			source.desc += "<br><b><u>Осталось [uses] заряд(-ов)</u></b>."
			source.UpdateButtonIcon()
	return ..()

/obj/item/melee/blood_magic/customised_abstract_text(mob/living/carbon/owner)
	return "<span class='warning'>[owner.p_their(TRUE)] [owner.l_hand == src ? "left hand" : "right hand"] is burning in blood-red fire.</span>"

/obj/item/melee/blood_magic/attack_self(mob/living/user)
	afterattack(user, user, TRUE)

/obj/item/melee/blood_magic/attack(mob/living/M, mob/living/carbon/user)
	if(!iscarbon(user) || !iscultist(user))
		uses = 0
		qdel(src)
		return
	add_attack_logs(user, M, "used a cult spell ([src]) on")
	M.lastattacker = user.real_name

/obj/item/melee/blood_magic/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(invocation)
		user.whisper(invocation)
	if(health_cost && ishuman(user))
		user.cult_self_harm(health_cost)
	if(uses <= 0)
		qdel(src)
	else if(source)
		source.desc = source.base_desc
		source.desc += "<br><b><u>Осталось [uses] заряд(-ов)</u></b>."
		source.UpdateButtonIcon()

//The spell effects

//stun
/obj/item/melee/blood_magic/stun
	name = "аура Ослабления"
	desc = "Оглушит и обеззвучит жертву при касании. Ударьте их клинком культа для завершения заклинания, ."
	color = RUNE_COLOR_RED
	invocation = "Fuu ma'jin!"

/obj/item/melee/blood_magic/stun/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target) || !proximity)
		return
	var/mob/living/L = target
	if(iscultist(target))
		return
	if(user.holy_check())
		return
	user.visible_message("<span class='warning'>[user] сдерживает их руку, в которой взрывается с красной вспышкой!</span>", \
							"<span class='cultitalic'>Вы пытаетесь оглушить [L] с помощью заклинания!</span>")

	user.mob_light(LIGHT_COLOR_BLOOD_MAGIC, 3, _duration = 2)

	var/obj/item/nullrod/N = locate() in target
	if(N)
		target.visible_message("<span class='warning'>Святое оружие [target] поглощает красный свет!</span>", \
							"<span class='userdanger'>Ваше святое оружие поглощает красный свет!</span>")
	else
		to_chat(user, "<span class='cultitalic'>Со вспышкой красного света, [L] падает на землю!</span>")

		L.KnockDown(10 SECONDS)
		L.adjustStaminaLoss(60)
		L.apply_status_effect(STATUS_EFFECT_CULT_STUN)
		L.flash_eyes(1, TRUE)
		if(issilicon(target))
			var/mob/living/silicon/S = L
			S.emp_act(EMP_HEAVY)
		else if(iscarbon(target))
			var/mob/living/carbon/C = L
			C.Silence(6 SECONDS)
			C.Stuttering(16 SECONDS)
			C.CultSlur(20 SECONDS)
			C.Jitter(16 SECONDS)
			to_chat(user, "<span class='boldnotice'>Метка оглушения применена! Ударьте цель кинжалом, мечом или кровавым копьём для их полного оглушения!</span>")
	user.do_attack_animation(target)
	uses--
	..()


//Teleportation
/obj/item/melee/blood_magic/teleport
	name = "аура Телепорта"
	color = RUNE_COLOR_TELEPORT
	desc = "Телепортирует вас или культиста на руну телепорта."
	invocation = "Sas'so c'arta forbici!"

/obj/item/melee/blood_magic/teleport/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(user.holy_check())
		return
	var/list/potential_runes = list()
	var/list/teleportnames = list()
	var/list/duplicaterunecount = list()
	var/atom/movable/teleportee
	if(!iscultist(target) || !proximity)
		to_chat(user, "<span class='warning'>Вы можете телепортировать только рядомстоящих культистов!</span>")
		return
	if(user != target) // So that the teleport effect shows on the correct mob
		teleportee = target
	else
		teleportee = user

	for(var/R in GLOB.teleport_runes)
		var/obj/effect/rune/teleport/T = R
		var/resultkey = T.listkey
		if(resultkey in teleportnames)
			duplicaterunecount[resultkey]++
			resultkey = "[resultkey] ([duplicaterunecount[resultkey]])"
		else
			teleportnames.Add(resultkey)
			duplicaterunecount[resultkey] = 1
		potential_runes[resultkey] = T

	if(!length(potential_runes))
		to_chat(user, "<span class='warning'>Нет валидных рун для телепорта!</span>")
		log_game("Teleport spell failed - no other teleport runes")
		return
	if(!is_level_reachable(user.z))
		to_chat(user, "<span class='cultitalic'>Вы слишком далеко от станции для телепорта!</span>")
		log_game("Teleport spell failed - user in away mission")
		return

	var/input_rune_key = tgui_input_list(user, "Выберите руну для телепорта", "Руна для телепорта", potential_runes) //we know what key they picked
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(QDELETED(src) || !user || user.l_hand != src && user.r_hand != src || user.incapacitated() || !actual_selected_rune)
		return

	if(HAS_TRAIT(user, TRAIT_FLOORED))
		to_chat(user, "<span class='cultitalic'>Использование заклинание во время оглушения невозможно!</span>")
		return

	uses--

	var/turf/origin = get_turf(teleportee)
	var/turf/destination = get_turf(actual_selected_rune)
	INVOKE_ASYNC(actual_selected_rune, TYPE_PROC_REF(/obj/effect/rune, teleport_effect), teleportee, origin, destination)

	if(is_mining_level(user.z) && !is_mining_level(destination.z)) //No effect if you stay on lavaland
		actual_selected_rune.handle_portal("lava")
	else if(!is_station_level(user.z) || istype(get_area(user), /area/space))
		actual_selected_rune.handle_portal("space", origin)

	if(user == target)
		target.visible_message("<span class='warning'>Пыль сыпется из руки [user] и они исчезают со вспышкой красного света!</span>", \
		"<span class='cultitalic'>Вы произносите слова и внезапно оказываетесь в другом месте!</span>")
	else
		target.visible_message("<span class='warning'>Пыль сыпется из руки [user], и [target] исчезает со вспышкой красного света!</span>", \
		"<span class='cultitalic'>Вы внезапно оказываетесь в другом месте!</span>")
	destination.visible_message("<span class='warning'>В воздухе раздаётся гул и что-то появляется на руне!</span>", null, "<i>Вы слышите гул.</i>")
	teleportee.forceMove(destination)
	return ..()

//Shackles
/obj/item/melee/blood_magic/shackles
	name = "аура сковывания"
	desc = "Начнёт заковывать жертву в оковы и обеззвучит жертву на небольшой промежуток времени при успехе."
	invocation = "In'totum Lig'abis!"
	color = "#000000" // black

/obj/item/melee/blood_magic/shackles/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(user.holy_check())
		return
	if(iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		if(C.canBeHandcuffed() || C.get_arm_ignore())
			CuffAttack(C, user)
		else
			user.visible_message("<span class='cultitalic'>У этой жертвы недостаточно рук для завершения сковывания!</span>")
			return
		..()

/obj/item/melee/blood_magic/shackles/proc/CuffAttack(mob/living/carbon/C, mob/living/user)
	if(!C.handcuffed)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, TRUE, SOUND_RANGE_SET(7))
		C.visible_message("<span class='danger'>[user] начинает сковывать [C] с помощью тёмной магии!</span>", \
		"<span class='userdanger'>[user] начинает формировать оковы из тёмной магии на ваших запястьях!</span>")
		if(do_mob(user, C, 30))
			if(!C.handcuffed)
				C.handcuffed = new /obj/item/restraints/handcuffs/energy/cult/used(C)
				C.update_handcuffed()
				C.Silence(12 SECONDS)
				to_chat(user, "<span class='notice'>Вы заковываете [C].</span>")
				add_attack_logs(user, C, "shackled")
				uses--
			else
				to_chat(user, "<span class='warning'>[C] уже закован.</span>")
		else
			to_chat(user, "<span class='warning'>Не удалось сковать [C].</span>")
	else
		to_chat(user, "<span class='warning'>[C] уже скован.</span>")


/obj/item/restraints/handcuffs/energy/cult //For the shackling spell
	name = "теневые оковы"
	desc = "Оковы, связывающие ваши запястья зловещей магией."
	trashtype = /obj/item/restraints/handcuffs/energy/used
	flags = DROPDEL

/obj/item/restraints/handcuffs/energy/cult/used/dropped(mob/user)
	user.visible_message("<span class='danger'>Оковы [user] разбиваются с выплеском тёмной энергии!</span>", \
	"<span class='userdanger'>Ваши [name] разбиваются с выплеском тёмной энергии!</span>")
	. = ..()


//Construction: Converts 50 metal to a construct shell, plasteel to runed metal, or an airlock to brittle runed airlock
/obj/item/melee/blood_magic/construction
	name = "искажённая аура"
	desc = "Искажает определённые металлические конструкции при касании."
	invocation = "Ethra p'ni dedol!"
	color = "#000000" // black
	var/channeling = FALSE

/obj/item/melee/blood_magic/construction/examine(mob/user)
	. = ..()
	. += {"<u>Зловещее заклинание, преобразующее:</u>\n
	Пласталь в рунический металл\n
	[METAL_TO_CONSTRUCT_SHELL_CONVERSION] металла в оболочку конструкта\n
	Шлюзы в хрупкие рунические после небольшой задерки (harm intent)"}

/obj/item/melee/blood_magic/construction/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(user.holy_check())
		return
	if(proximity_flag)
		if(channeling)
			to_chat(user, "<span class='cultitalic'>Вы уже используете искажённое строительство!</span>")
			return
		var/turf/T = get_turf(target)

		//Metal to construct shell
		if(istype(target, /obj/item/stack/sheet/metal))
			var/obj/item/stack/sheet/candidate = target
			if(candidate.use(METAL_TO_CONSTRUCT_SHELL_CONVERSION))
				uses--
				to_chat(user, "<span class='warning'>Тёмное облако появляется из руки и окутывает металл, превращая его в оболочку конструкта!</span>")
				new /obj/structure/constructshell(T)
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(4))
			else
				to_chat(user, "<span class='warning'>Вам необходимо [METAL_TO_CONSTRUCT_SHELL_CONVERSION] металла для получения оболочки конструкта!</span>")
				return

		//Plasteel to runed metal
		else if(istype(target, /obj/item/stack/sheet/plasteel))
			var/obj/item/stack/sheet/plasteel/candidate = target
			var/quantity = candidate.amount
			if(candidate.use(quantity))
				uses--
				new /obj/item/stack/sheet/runed_metal(T, quantity)
				to_chat(user, "<span class='warning'>Тёмное облако появляется из руки и окутывает пласталь, превращая её в рунический металл!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(4))

		//Airlock to cult airlock
		else if(istype(target, /obj/machinery/door/airlock) && !istype(target, /obj/machinery/door/airlock/cult))
			channeling = TRUE
			playsound(T, 'sound/machines/airlockforced.ogg', 50, TRUE, SOUND_RANGE_SET(7))
			do_sparks(5, TRUE, target)
			if(do_after(user, 50, target = target))
				target.narsie_act(TRUE)
				uses--
				user.visible_message("<span class='warning'>Чёрные полоски появляются из руки [user] и цепляются за шлюз - искажая и портя его!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(7))
				channeling = FALSE
			else
				channeling = FALSE
				return
		else
			to_chat(user, "<span class='warning'>Заклинание не сработает на [target]!</span>")
			return
		..()

//Armor: Gives the target a basic cultist combat loadout
/obj/item/melee/blood_magic/armor
	name = "аура снаряжения"
	desc = "Снарядит культиста снаряжением культа в свободные слоты."
	color = "#33cc33" // green

/obj/item/melee/blood_magic/armor/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(user.holy_check())
		return
	if(iscarbon(target) && proximity)
		uses--
		var/mob/living/carbon/C = target
		var/armour = C.equip_to_slot_or_del(new /obj/item/clothing/suit/hooded/cultrobes/alt(user), SLOT_HUD_OUTER_SUIT)
		C.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(user), SLOT_HUD_JUMPSUIT)
		C.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), SLOT_HUD_BACK)
		C.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), SLOT_HUD_SHOES)

		if(C == user)
			qdel(src) //Clears the hands
		C.put_in_hands(new /obj/item/melee/cultblade(user))
		C.put_in_hands(new /obj/item/restraints/legcuffs/bola/cult(user))
		C.visible_message("<span class='warning'>Инородн[armour ? "ая" : "ое"] [armour ? "броня" : "снаряжение"] внезапно появляется на [C]!</span>")
		..()
//Used by blood rite, to recharge things like viel shifter or the cultest shielded robes
/obj/item/melee/blood_magic/empower
	name = "Кровавая перезарядка"
	desc = "Может быть использована на некоторых предметах культа, восстанавливая их первозданный вид."
	invocation = "Ditans Gut'ura Inpulsa!"
	color = "#9c0651"
	has_source = FALSE //special, only availible for a blood cost.

/obj/item/melee/blood_magic/empower/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(user.holy_check())
		return
	if(proximity_flag)

		// Veil Shifter
		if(istype(target, /obj/item/cult_shift))
			var/obj/item/cult_shift/S = target
			if(S.uses < 4)
				uses--
				to_chat(user, "<span class='warning'>Вы усиливаете [target] кровью, перезаряжая возможность к смещению!</span>")
				playsound(user, 'sound/magic/cult_spell.ogg', 25, TRUE, SOUND_RANGE_SET(7))
				S.uses = 4
				S.icon_state = "shifter"
			else
				to_chat(user, "<span class='warning'>[target] уже полностью заряжен!</span>")
				return
		else
			to_chat(user, "<span class='warning'>Заклинание не сработает на [target]!</span>")
			return
		..()

//Blood Rite: Absorb blood to heal cult members or summon weapons
/obj/item/melee/blood_magic/manipulator
	name = "аура кровавого обряда"
	desc = "Поглощает кровь из всего, к чего вы прикоснётесь. Касания культистов и конструктов их лечит. Используйте в руке для продвинутых обрядов."
	color = "#7D1717"

/obj/item/melee/blood_magic/manipulator/examine(mob/user)
	. = ..()
	. += "Кровавое копьё и Кровавый шквал стоят [BLOOD_SPEAR_COST] и [BLOOD_BARRAGE_COST] зарядов соответственно."
	. += "Кровавая сфера и Кровавая перезарядка стоят [BLOOD_ORB_COST] и [BLOOD_RECHARGE_COST] зарядов соответственно."
	. += "<span class='cultitalic'>Вы собрали [uses] заряд[uses > 1 ? "ов" : ""] крови.</span>"

/obj/item/melee/blood_magic/manipulator/proc/restore_blood(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(uses == 0)
		return
	if(!H.dna || (NO_BLOOD in H.dna.species.species_traits) || !isnull(H.dna.species.exotic_blood))
		return
	if(H.blood_volume >= BLOOD_VOLUME_SAFE)
		return
	var/restore_blood = BLOOD_VOLUME_SAFE - H.blood_volume
	if(uses * 2 < restore_blood)
		H.blood_volume += uses * 2
		to_chat(user, "<span class='danger'>Вы используете последние заряды для восстанов!</span>")
		uses = 0
	else
		H.blood_volume = BLOOD_VOLUME_SAFE
		uses -= round(restore_blood / 2)
		to_chat(user, "<span class='cult'>Кровавый обряд восстановил [H == user ? "ваш уровень" : "их уровень"] крови до безопасных значений!</span>")

/obj/item/melee/blood_magic/manipulator/proc/heal_human_damage(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(uses == 0)
		return
	var/overall_damage = H.getBruteLoss() + H.getFireLoss() + H.getToxLoss() + H.getOxyLoss()
	if(overall_damage == 0)
		to_chat(user, "<span class='warning'>[H] не требуется лечение!</span>")
		return

	var/ratio = uses / overall_damage
	if(H == user)
		to_chat(user, "<span class='warning'>Кровавое исцеление куда менее эффективно при использовании на себе!</span>")
		ratio *= 0.35 // Healing is half as effective if you can't perform a full heal
		uses -= round(overall_damage) // Healing is 65% more "expensive" even if you can still perform the full heal
	if(ratio > 1)
		ratio = 1
		uses -= round(overall_damage)
		H.visible_message("<span class='warning'>[H] был полностью вылечен с помощью [H == user ? "их Магии Крови" : " Магии Крови [H]"]!</span>",
			"<span class='cultitalic'>Вы были полностью вылечены с помощью [H == user ? "своей Магии Крови" : "Магии Крови [user]"]!</span>")
	else
		H.visible_message("<span class='warning'>[H] был частично вылечен с помощью [H == user ? "их Магии Крови" : "Магии Крови [H]"].</span>",
			"<span class='cultitalic'>вы были частично вылечены с помощью [H == user ? "своей Магии Крови" : "Магии Крови[user]"].</span>")
		uses = 0
	ratio *= -1
	H.adjustOxyLoss((overall_damage * ratio) * (H.getOxyLoss() / overall_damage), FALSE, null, TRUE)
	H.adjustToxLoss((overall_damage * ratio) * (H.getToxLoss() / overall_damage), FALSE, null, TRUE)
	H.adjustFireLoss((overall_damage * ratio) * (H.getFireLoss() / overall_damage), FALSE, null, TRUE)
	H.adjustBruteLoss((overall_damage * ratio) * (H.getBruteLoss() / overall_damage), FALSE, null, TRUE)
	H.updatehealth()
	playsound(get_turf(H), 'sound/magic/staff_healing.ogg', 25, extrarange = SOUND_RANGE_SET(7))
	new /obj/effect/temp_visual/cult/sparks(get_turf(H))
	user.Beam(H, icon_state="sendbeam", time = 15)

/obj/item/melee/blood_magic/manipulator/proc/heal_cultist(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(H.stat == DEAD)
		to_chat(user, "<span class='warning'>Только руна воскрешения может вернуть к жизни мёртвых!</span>")
		return
	var/charge_loss = uses
	restore_blood(user, H)
	heal_human_damage(user, H)
	charge_loss = charge_loss - uses
	if(!uses)
		to_chat(user, "<span class='danger'>Вы используете свои последние заряды для исцеления  [H == user ? "себя" : "[H]"], и заклинание рассеивается!</span>")
	else
		to_chat(user, "<span class='cultitalic'>Вы использовали [charge_loss] заряд[charge_loss > 1 ? "ов" : ""], и у вас осталось [uses] заряд[uses > 1 ? uses % 10 != 1 ? "ов" : "а" : ""].</span>")

/obj/item/melee/blood_magic/manipulator/proc/heal_construct(mob/living/carbon/human/user, mob/living/simple_animal/M)
	if(uses == 0)
		return
	var/missing = M.maxHealth - M.health
	if(!missing)
		to_chat(user, "<span class='warning'>[M] не требуется лечение!</span>")
		return
	if(uses > missing)
		M.adjustHealth(-missing)
		M.visible_message("<span class='warning'>[M] полностью вылечен при помощи Магии Крови [user]!</span>",
			"<span class='cultitalic'>Вы полностью вылечены при помощи Магии Крови [user]!</span>")
		uses -= missing
	else
		M.adjustHealth(-uses)
		M.visible_message("<span class='warning'>[M] был частично вылечен при помощи Магии Крови [user]!</span>",
			"<span class='cultitalic'>Вы были частично исцелены при помощи Магии Крови [user].</span>")
		uses = 0
	playsound(get_turf(M), 'sound/magic/staff_healing.ogg', 25, extrarange = SOUND_RANGE_SET(7))
	user.Beam(M, icon_state = "sendbeam", time = 10)

/obj/item/melee/blood_magic/manipulator/proc/steal_blood(mob/living/carbon/human/user, mob/living/carbon/human/H)
	if(H.stat == DEAD)
		to_chat(user, "<span class='warning'>Кровь в теле [H] перестала течь, придётся найти другой способ её извлечения.</span>")
		return
	if(H.AmountCultSlurring())
		to_chat(user, "<span class='danger'>Кровь [H] была осквернена более сильной формой Магии Крови, в таком виде она бесполезна!</span>")
		return
	if(!H.dna || (NO_BLOOD in H.dna.species.species_traits) || H.dna.species.exotic_blood != null)
		to_chat(user, "<span class='warning'>У [H] отсутствует полезная кровь!</span>")
		return
	if(H.blood_volume <= BLOOD_VOLUME_SAFE)
		to_chat(user, "<span class='warning'>[H] потерял слишком много крови - вы больше не можете их высасывать!</span>")
		return
	H.blood_volume -= 100
	uses += 50
	user.Beam(H, icon_state = "drainbeam", time = 10)
	playsound(get_turf(H), 'sound/misc/enter_blood.ogg', 50, extrarange = SOUND_RANGE_SET(7))
	H.visible_message("<span class='danger'>[user] высосал немного крови из тела [H]!</span>",
					"<span class='userdanger'>[user] высосал немного вашей крови!</span>")
	to_chat(user, "<span class='cultitalic'>Ваш Кровавый обряд получил 50 единиц крови путём высасывания крови из тела [H].</span>")
	new /obj/effect/temp_visual/cult/sparks(get_turf(H))

// This should really be split into multiple procs
/obj/item/melee/blood_magic/manipulator/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(user.holy_check())
		return
	if(!proximity)
		return ..()
	if(ishuman(target))
		if(iscultist(target))
			heal_cultist(user, target)
			target.clean_blood()
		else
			steal_blood(user, target)
		return

	if(isconstruct(target))
		heal_construct(user, target)
		return

	if(istype(target, /obj/item/blood_orb))
		var/obj/item/blood_orb/candidate = target
		if(candidate.blood)
			uses += candidate.blood
			to_chat(user, "<span class='warning'>Вы получаете [candidate.blood] крови из Кровавой сферы!</span>")
			playsound(user, 'sound/misc/enter_blood.ogg', 50, extrarange = SOUND_RANGE_SET(7))
			qdel(candidate)
			return
	blood_draw(target, user)

/obj/item/melee/blood_magic/manipulator/proc/blood_draw(atom/target, mob/living/carbon/human/user)
	var/temp = 0
	var/turf/T = get_turf(target)
	if(!T)
		return
	for(var/obj/effect/decal/cleanable/blood/B in range(T, 2))
		if(B.blood_state == BLOOD_STATE_HUMAN && (B.can_bloodcrawl_in()))
			if(B.bloodiness == 100) //Bonus for "pristine" bloodpools, also to prevent cheese with footprint spam
				temp += 30
			else
				temp += max((B.bloodiness ** 2) / 800, 1)
		new /obj/effect/temp_visual/cult/turf/open/floor(get_turf(B))
		qdel(B)
	for(var/obj/effect/decal/cleanable/trail_holder/TH in range(T, 2))
		new /obj/effect/temp_visual/cult/turf/open/floor(get_turf(TH))
		qdel(TH)
	if(temp)
		user.Beam(T, icon_state = "drainbeam", time = 15)
		new /obj/effect/temp_visual/cult/sparks(get_turf(user))
		playsound(T, 'sound/misc/enter_blood.ogg', 50, extrarange = SOUND_RANGE_SET(7))
		temp = round(temp)
		to_chat(user, "<span class='cultitalic'>Ваш кровавый обряд получил [temp] заряд[temp > 1 ? "ов" : ""] из источников крови поблизости!</span>")
		uses += max(1, temp)

/obj/item/melee/blood_magic/manipulator/attack_self(mob/living/user)
	if(user.holy_check())
		return
	var/list/options = list("Кровавая сфера (50)" = image(icon = 'icons/obj/cult.dmi', icon_state = "summoning_orb"),
							"Кровавая перезарядка (75)" = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "blood_charge"),
							"Кровавое копьё (150)" = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "bloodspear"),
							"Кровавый Шквал (300)" = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "blood_barrage"))
	var/choice = show_radial_menu(user, src, options)

	switch(choice)
		if("Кровавая сфера (50)")
			if(uses < BLOOD_ORB_COST)
				to_chat(user, "<span class='warning'>Вам нужно [BLOOD_ORB_COST] зарядо для выполнения данного обряда.</span>")
			else
				var/ammount = input("Сколько крови вы хотите передать? У вас есть [uses] единиц.", "Сколько крови?", 50) as null|num
				if(ammount < 50) // No 1 blood orbs, 50 or more.
					to_chat(user, "<span class='warning'>Требуется отдать как минимум 50 единиц крови.</span>")
					return
				if(ammount > uses) // No free blood either
					to_chat(user, "<span class='warning'>У вас нет столько лишних зарядов!</span>")
					return
				uses -= ammount
				var/turf/T = get_turf(user)
				qdel(src)
				var/obj/item/blood_orb/rite = new(T)
				rite.blood = ammount
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>[rite.name] появляется в вашей руке!</span>")
				else
					user.visible_message("<span class='warning'>[rite.name] появляется у ног [user]!</span>",
					"<span class='cult'>[rite.name] материализуется у ваших ног.</span>")

		if("Кровавая перезарядка (75)")
			if(uses < BLOOD_RECHARGE_COST)
				to_chat(user, "<span class='cultitalic'>Требуется [BLOOD_RECHARGE_COST] зарядов для исполнения обряда.</span>")
			else
				var/obj/rite = new /obj/item/melee/blood_magic/empower()
				uses -= BLOOD_RECHARGE_COST
				qdel(src)
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>Ваша рука сияет мощью!</span>")
				else
					to_chat(user, "<span class='warning'>Требуется свободная рука для исполнения обряда!</span>")
					uses += BLOOD_RECHARGE_COST // Refund the charges
					qdel(rite)

		if("Кровавое копьё (150)")
			if(uses < BLOOD_SPEAR_COST)
				to_chat(user, "<span class='warning'>Требуется [BLOOD_SPEAR_COST] зарядов для исполнения обряда.</span>")
			else
				uses -= BLOOD_SPEAR_COST
				var/turf/T = get_turf(user)
				qdel(src)
				var/datum/action/innate/cult/spear/S = new(user)
				var/obj/item/cult_spear/rite = new(T)
				S.Grant(user, rite)
				rite.spear_act = S
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>[rite.name] появляется у вас в руке!</span>")
				else
					user.visible_message("<span class='warning'>[rite.name] появляется у ног [user]!</span>",
					"<span class='cult'>[rite.name] материализуется у ваших ног.</span>")

		if("Кровавый шквал (300)")
			if(uses < BLOOD_BARRAGE_COST)
				to_chat(user, "<span class='cultitalic'>Требуется [BLOOD_BARRAGE_COST] зарядов для исполнения обряда.</span>")
			else
				var/obj/rite = new /obj/item/gun/projectile/shotgun/boltaction/enchanted/arcane_barrage/blood()
				uses -= BLOOD_BARRAGE_COST
				qdel(src)
				user.swap_hand()
				user.drop_item()
				if(user.put_in_hands(rite))
					to_chat(user, "<span class='cult'>Обе ваших руки начинают светиться мощью!</span>")
				else
					to_chat(user, "<span class='warning'>Требуется свободная рука для исполнения обряда!</span>")
					uses += BLOOD_BARRAGE_COST // Refund the charges
					qdel(rite)
