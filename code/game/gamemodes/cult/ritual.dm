#define CULT_ELDERGOD "eldergod"
#define CULT_SLAUGHTER "slaughter"

/obj/item/melee/cultblade/dagger
	name = "ритуальный нож"
	desc = "Странный нож, используемый зловещими групами для \"подготовки\" тела перед жертвоприношением смоим тёмным богам."
	icon_state = "blood_dagger"
	item_state = "blood_dagger"
	w_class = WEIGHT_CLASS_SMALL
	force = 15
	throwforce = 25
	armour_penetration_flat = 35
	sprite_sheets_inhand = null // Override parent
	var/drawing_rune = FALSE
	var/scribe_multiplier = 1 // Lower is faster

/obj/item/melee/cultblade/dagger/adminbus
	name = "ritual dagger of scribing, +1"
	desc = "VERY fast culto scribing at incredible hihg speed"
	force = 16
	scribe_multiplier = 0.1

/obj/item/melee/cultblade/dagger/New()
	..()
	if(SSticker.mode)
		icon_state = SSticker.cultdat.dagger_icon
		item_state = SSticker.cultdat.dagger_icon

/obj/item/melee/cultblade/dagger/examine(mob/user)
	. = ..()
	if(iscultist(user) || user.stat == DEAD)
		. += "<span class='cult'>Нож, подаренный вам [SSticker.cultdat.entity_title3]. Даёт возможность чертить руны и получить знания из Архивов культа [SSticker.cultdat.entity_name].</span>"
		. += "<span class='cultitalic'>Атакуя культистов, вы уберёте святую воду из них.</span>"
		. += "<span class='cultitalic'>Атакуя неверных, вы разорвёте их плоть. Дополнительно, если вы их недавно ослабили Магией Крови, удар их полностью оглушит.</span>"

/obj/item/melee/cultblade/dagger/attack(mob/living/M, mob/living/user)
	if(iscultist(M))
		if(M.reagents && M.reagents.has_reagent("holywater")) //allows cultists to be rescued from the clutches of ordained religion
			if(M == user) // Targeting yourself
				to_chat(user, "<span class='warning'>Вы не можете извлечь святую воду из себя!</span>")
			else // Targeting someone else
				to_chat(user, "<span class='cult'>Вы убираете порчу из тела [M].</span>")
				to_chat(M, "<span class='cult'>[user] убирает порчу из вашего тела.</span>")
				M.reagents.del_reagent("holywater")
				add_attack_logs(user, M, "ударил [src], выводя из них святую воду.")
		return FALSE
	else
		var/datum/status_effect/cult_stun_mark/S = M.has_status_effect(STATUS_EFFECT_CULT_STUN)
		if(S)
			S.trigger()
	. = ..()

/obj/item/melee/cultblade/dagger/attack_self(mob/user)
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>[src] покрыт непонятными надписями и знаками.</span>")
		return
	scribe_rune(user)

/obj/item/melee/cultblade/dagger/proc/narsie_rune_check(mob/living/user, area/A)
	var/datum/game_mode/gamemode = SSticker.mode

	if(gamemode.cult_objs.cult_status < NARSIE_NEEDS_SUMMONING)
		to_chat(user, "<span class='cultitalic'><b>[SSticker.cultdat.entity_name]</b> Ещё не готов к призыву!</span>")
		return FALSE
	if(gamemode.cult_objs.cult_status == NARSIE_HAS_RISEN)
		to_chat(user, "<span class='cultlarge'>\"Я уже здесь. Нет нужды меня призывать.\"</span>")
		return FALSE

	var/list/summon_areas = gamemode.cult_objs.obj_summon.summon_spots
	if(!(A in summon_areas))
		to_chat(user, "<span class='cultlarge'>[SSticker.cultdat.entity_name] может быть призван в местах с слабой Завесой - в [english_list(summon_areas)]!</span>")
		return FALSE
	var/confirm_final = alert(user, "Это ПОСЛЕДНИЙ шаг по призыву божества. Это долгий и мучительный ритуал, а экипаж будет уведомлён о вашем присутствии И вашем местоположении!",
	"Вы готовы к финальной битве?", "Жизнь за [SSticker.cultdat.entity_name]!", "Нет")
	if(user)
		if(confirm_final == "Нет" || confirm_final == null)
			to_chat(user, "<span class='cultitalic'><b>Вы решаете лучше подготовиться перед начертанием руны.</b></span>")
			return FALSE
		else
			if(locate(/obj/effect/rune) in range(1, user))
				to_chat(user, "<span class='cultlarge'>Вам нужно очищенное от рун пространство для призыва [SSticker.cultdat.entity_title1]!</span>")
				return FALSE
			else
				return TRUE

/obj/item/melee/cultblade/dagger/proc/can_scribe(mob/living/user)
	if(!src || !user || loc != user || user.incapacitated())
		return FALSE
	if(drawing_rune)
		to_chat(user, "<span class='warning'>Вы уже чертите руну!</span>")
		return FALSE

	var/turf/T = get_turf(user)
	if(isspaceturf(T))
		return FALSE
	if((locate(/obj/effect/rune) in T) || (locate(/obj/effect/rune/narsie) in range(1, T)))
		to_chat(user, "<span class='warning'>Здесь уже расположена руна!</span>")
		return FALSE
	return TRUE


/obj/item/melee/cultblade/dagger/proc/scribe_rune(mob/living/user)
	var/list/shields = list()
	var/list/possible_runes = list()
	var/keyword

	if(!can_scribe(user)) // Check this before anything else
		return

	// Choosing a rune
	for(var/I in (subtypesof(/obj/effect/rune) - /obj/effect/rune/malformed))
		var/obj/effect/rune/R = I
		var/rune_name = initial(R.cultist_name)
		if(rune_name)
			possible_runes[rune_name] = R
	if(!length(possible_runes))
		return

	var/chosen_rune = tgui_input_list(user, "Выберите руну для начертания.", "Сигилы Силы", possible_runes)
	if(!chosen_rune)
		return
	var/obj/effect/rune/rune = possible_runes[chosen_rune]
	var/narsie_rune = FALSE
	if(rune == /obj/effect/rune/narsie)
		narsie_rune = TRUE
	if(initial(rune.req_keyword))
		keyword = stripped_input(user, "Напишите название для руны.", "Введите название")
		if(!keyword)
			return

	// Check everything again, in case they moved
	if(!can_scribe(user))
		return

	// Check if the rune is allowed
	var/area/A = get_area(src)
	var/turf/runeturf = get_turf(user)
	var/datum/game_mode/gamemode = SSticker.mode
	if(ispath(rune, /obj/effect/rune/summon))
		if(!is_station_level(runeturf.z) || istype(A, /area/space))
			to_chat(user, "<span class='cultitalic'>Завеса слаба для призыва культиста, вы должны находиться на станции!</span>")
			return

	if(ispath(rune, /obj/effect/rune/teleport))
		if(!is_level_reachable(user.z))
			to_chat(user, "<span class='cultitalic'>Вы слишком далеко от станции для телепортации!</span>")
			return

	var/old_color = user.color // we'll temporarily redden the user for better feedback to fellow cultists. Store this to revert them back.
	if(narsie_rune)
		if(!narsie_rune_check(user, A))
			return // don't do shit
		var/list/summon_areas = gamemode.cult_objs.obj_summon.summon_spots
		if(!(A in summon_areas)) // Check again to make sure they didn't move
			to_chat(user, "<span class='cultlarge'>Ритуал может быть начат только в местах со слабой завесой - in [english_list(summon_areas)]!</span>")
			return
		GLOB.major_announcement.Announce("Образы древнего богоподобного существа соединяются воединно в [A.map_name] из неизвестного измерения. Прервите ритуал любой ценой, пока станция не была уничтожена! Действие космических законов и стандартных рабочих процедур приостановлено. Всему экипажу - ликвидировать культистов на месте.", "Отдел по делам Высших Измерений.", 'sound/AI/spanomalies.ogg')
		for(var/I in spiral_range_turfs(1, user, 1))
			var/turf/T = I
			var/obj/machinery/shield/cult/narsie/N = new(T)
			shields |= N
		user.color = COLOR_RED

	// Draw the rune
	var/mob/living/carbon/human/H = user
	H.cult_self_harm(initial(rune.scribe_damage))
	var/others_message
	if(!narsie_rune)
		others_message = "<span class='warning'>[user] разрезает своё тело и начинает чертить своей кровью!</span>"
	else
		others_message = "<span class='biggerdanger'>[user] разрезает своё тело и начинает чертить что-то особенно зловещее своей кровью!</span>"
	user.visible_message(others_message,
		"<span class='cultitalic'>Вы разрезаете своё тело и начинаете чертить сигил [SSticker.cultdat.entity_title3].</span>")

	drawing_rune = TRUE // Only one at a time
	var/scribe_successful = do_after(user, initial(rune.scribe_delay) * scribe_multiplier, target = runeturf)
	for(var/V in shields) // Only used for the 'Tear Veil' rune
		var/obj/machinery/shield/S = V
		if(S && !QDELETED(S))
			qdel(S)
	user.color = old_color
	drawing_rune = FALSE
	if(!scribe_successful)
		return

	user.visible_message("<span class='warning'>[user] создаёт странный круг с помощью своей крови.</span>",
						"<span class='cultitalic'>Вы заканчиваете начертание древних меток [SSticker.cultdat.entity_title3].</span>")

	var/obj/effect/rune/R = new rune(runeturf, keyword)
	if(narsie_rune)
		for(var/obj/effect/rune/I in orange(1, R))
			qdel(I)
	SSblackbox.record_feedback("tally", "runes_scribed", 1, "[R.cultist_name]")
	R.blood_DNA = list()
	R.blood_DNA[H.dna.unique_enzymes] = H.dna.blood_type
	R.add_hiddenprint(H)
	R.color = H.dna.species.blood_color
	R.rune_blood_color = H.dna.species.blood_color
	to_chat(user, "<span class='cult'>The [lowertext(initial(rune.cultist_name))] rune [initial(rune.cultist_desc)]</span>")
