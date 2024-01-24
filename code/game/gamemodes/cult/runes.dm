GLOBAL_LIST_EMPTY(sacrificed) // A mixed list of minds and mobs
GLOBAL_LIST_EMPTY(teleport_runes) // I'll give you two guesses

/*
This file contains runes.
Runes are used by the cult to cause many different effects and are paramount to their success.
They are drawn with a ritual dagger in blood, and are distinguishable to cultists and normal crew by examining.
Fake runes can be drawn in crayon to fool people.
Runes can either be invoked by one's self or with many different cultists. Each rune has a specific incantation that the cultists will say when invoking it.
To draw a rune, use a ritual dagger.
*/

/obj/effect/rune
	/// Name non-cultists see
	name = "rune"
	/// Name that cultists see
	var/cultist_name = "basic rune"
	/// Description that non-cultists see
	desc = "Странное сборище символов, нарисованные, видимо, кровью."
	/// Description that cultists see
	var/cultist_desc = "стандартная руна без функции." //This is shown to cultists who examine the rune in order to determine its true purpose.
	anchored = TRUE
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	mouse_opacity = MOUSE_OPACITY_OPAQUE // So that runes aren't so hard to click
	var/visibility = 0
	var/view_range = 7
	invisibility = 25
	layer = SIGIL_LAYER
	color = COLOR_BLOOD_BASE

	/// What is said by cultists when the rune is invoked
	var/invocation = "Aiy ele-mayo!"
	///The amount of cultists required around the rune to invoke it. If only 1, any cultist can invoke it.
	var/req_cultists = 1
	/// Used for some runes, this is for when you want a rune to not be usable when in use.
	var/rune_in_use = FALSE

	/// How long the rune takes to create (Currently only different for the Nar'Sie rune)
	var/scribe_delay = 5 SECONDS
	/// How much damage you take from drawing the rune
	var/scribe_damage = 1

	/// If nearby cultists will also chant when invoked
	var/allow_excess_invokers = FALSE
	/// If constructs can invoke it
	var/construct_invoke = TRUE

	/// If the rune requires a keyword (e.g. Teleport runes)
	var/req_keyword = FALSE
	/// The actual keyword for the rune
	var/keyword

	/// How much damage cultists take when invoking it (This includes constructs)
	var/invoke_damage = 0
	/// The color of the rune. (Based on species blood color)
	var/rune_blood_color = COLOR_BLOOD_BASE

/obj/effect/rune/New(loc, set_keyword)
	..()
	if(set_keyword)
		keyword = set_keyword
	var/image/blood = image(loc = src)
	blood.override = 1
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		AI.client.images += blood

/obj/effect/rune/examine(mob/user)
	. = ..()
	if(iscultist(user) || user.stat == DEAD) //If they're a cultist or a ghost, tell them the effects
		. += "<b>Имя:</b> [cultist_name]"
		. += "<b>Эффекты:</b> [capitalize(cultist_desc)]"
		. += "<b>Необходимо аколитов:</b> [req_cultists]"
		if(req_keyword && keyword)
			. += "<b>Название:</b> <span class='cultitalic'>[keyword]</span>"

/obj/effect/rune/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/melee/cultblade/dagger) && iscultist(user))
		// Telerunes with portals open
		if(istype(src, /obj/effect/rune/teleport))
			var/obj/effect/rune/teleport/T = src // Can't erase telerunes if they have a portal open
			if(T.inner_portal || T.outer_portal)
				to_chat(user, "<span class='warning'>Сначала портал должен закрыться!</span>")
				return

		// Everything else
		var/obj/item/melee/cultblade/dagger/D = I
		user.visible_message("<span class='warning'>[user] начинает стирать [src] с помощью [I].</span>")
		if(do_after(user, initial(scribe_delay) * D.scribe_multiplier, target = src))
			to_chat(user, "<span class='notice'>Вы аккуратно стираете руну [lowertext(cultist_name)].</span>")
			qdel(src)
		return
	if(istype(I, /obj/item/nullrod))
		if(iscultist(user))//cultist..what are doing..cultist..staph...
			user.drop_item()
			user.visible_message("<span class='warning'>[I] внезапно светится белым светом, заставляя [user] в агонии это выбросить!</span>", \
			"<span class='danger'>[I] внезапно начинает светиться пронзающим белым светом, заставляя вас выбросить [I]!</span>") // TODO: Make this actually burn your hand
			return
		to_chat(user,"<span class='danger'>Вы прерываете магию [src] с помощью [I].</span>")
		qdel(src)
		return
	return ..()

/obj/effect/rune/attack_hand(mob/living/user)
	user.Move_Pulled(src) // So that you can still drag things onto runes
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>Вы не можете понять ни слова на [src].</span>")
		return
	var/list/invokers = can_invoke(user)
	if(length(invokers) >= req_cultists)
		invoke(invokers)
	else
		fail_invoke()

/obj/effect/rune/attack_animal(mob/living/simple_animal/M)
	if(isshade(M) || isconstruct(M))
		if(construct_invoke || !iscultist(M)) //if you're not a cult construct we want the normal fail message
			attack_hand(M)
		else
			to_chat(M, "<span class='warning'>Вы не можете воспользоваться руной!</span>")

/obj/effect/rune/cult_conceal() //for concealing spell
	visible_message("<span class='danger'>[src] исчезает.</span>")
	invisibility = INVISIBILITY_HIDDEN_RUNES
	alpha = 100 //To help ghosts distinguish hidden runes

/obj/effect/rune/cult_reveal() //for revealing spell
	invisibility = initial(invisibility)
	visible_message("<span class='danger'>[src] внезапно появляется!</span>")
	alpha = initial(alpha)

/obj/effect/rune/is_cleanable()
	return TRUE

/obj/effect/rune/cleaning_act(mob/user, atom/cleaner, cleanspeed = 5 SECONDS, text_verb = "стирает", text_description = " с помощью [cleaner].")
	if(issimulatedturf(loc))
		var/turf/simulated/T = get_turf(src)
		T.cleaning_act(user, cleaner, cleanspeed = cleanspeed, text_verb = text_verb, text_description = text_description, text_targetname = name) //Strings are deliberately "A = A" to avoid overrides
		return
	else
		..()


/*
There are a few different procs each rune runs through when a cultist activates it.
can_invoke() is called when a cultist activates the rune with an empty hand. If there are multiple cultists, this rune determines if the required amount is nearby.
invoke() is the rune's actual effects.
fail_invoke() is called when the rune fails, via not enough people around or otherwise. Typically this just has a generic 'fizzle' effect.
structure_check() searches for nearby cultist structures required for the invocation. Proper structures are pylons, forges, archives, and altars.
*/
/obj/effect/rune/proc/can_invoke(mob/living/user)
	if(user.holy_check())
		return
	//This proc determines if the rune can be invoked at the time. If there are multiple required cultists, it will find all nearby cultists.
	var/list/invokers = list() //people eligible to invoke the rune
	var/list/chanters = list() //people who will actually chant the rune when passed to invoke()
	if(invisibility == INVISIBILITY_HIDDEN_RUNES)//hidden rune
		return
	// Get the user
	if(user)
		chanters |= user
		invokers |= user
	// Get anyone nearby
	if(req_cultists > 1 || allow_excess_invokers)
		for(var/mob/living/L in range(1, src))
			if(iscultist(L))
				if(L == user)
					continue
				if(L.stat)
					continue
				invokers |= L

		if(length(invokers) >= req_cultists) // If there's enough invokers
			if(allow_excess_invokers)
				chanters |= invokers // Let the others join in too
			else
				invokers -= user
				shuffle(invokers)
				for(var/i in 0 to req_cultists)
					var/L = pick_n_take(invokers)
					chanters |= L
	return chanters

/obj/effect/rune/proc/invoke(list/invokers)
	//This proc contains the effects of the rune as well as things that happen afterwards. If you want it to spawn an object and then delete itself, have both here.
	SHOULD_CALL_PARENT(TRUE)
	var/ghost_invokers = 0
	for(var/M in invokers)
		var/mob/living/L = M
		if(!L)
			return
		if(L.has_status_effect(STATUS_EFFECT_SUMMONEDGHOST))
			ghost_invokers++
		if(invocation)
			if(!L.IsVocal() || L.cannot_speak_loudly())
				L.custom_emote(EMOTE_VISIBLE, message = pick("draws arcane sigils in the air.","gestures ominously.","silently mouths out an invocation.","places their hands on the rune, activating it."))
			else
				L.say(invocation)
			L.changeNext_move(CLICK_CD_MELEE)//THIS IS WHY WE CAN'T HAVE NICE THINGS
		if(invoke_damage)
			L.apply_damage(invoke_damage, BRUTE)
			to_chat(L, "<span class='cultitalic'>[src] saps your strength!</span>")
	do_invoke_glow()
	SSblackbox.record_feedback("nested tally", "runes_invoked", 1, list("[initial(cultist_name)]", "[length(SSticker.mode.cult)]")) // the name of the rune, and the number of cultists in the cult when it was invoked
	if(ghost_invokers)
		SSblackbox.record_feedback("nested tally", "runes_invoked_with_ghost", 1, list("[initial(cultist_name)]", "[ghost_invokers]")) //the name of the rune and the number of ghosts used to invoke it.

/**
  * Spawns the phase in/out effects for a cult teleport.
  *
  * Arguments:
  * * user - Mob to teleport
  * * location - Location to teleport from
  * * target - Location to teleport to
  */
/obj/effect/rune/proc/teleport_effect(mob/living/user, turf/location, target)
	new /obj/effect/temp_visual/dir_setting/cult/phase/out(location, user.dir)
	new /obj/effect/temp_visual/dir_setting/cult/phase(target, user.dir)
	// So that the mob only appears after the effect is finished
	user.notransform = TRUE
	user.invisibility = INVISIBILITY_MAXIMUM
	sleep(12)
	user.notransform = FALSE
	user.invisibility = 0

/obj/effect/rune/proc/do_invoke_glow()
	var/oldtransform = transform
	animate(src, transform = matrix() * 2, alpha = 0, time = 5) // Fade out
	animate(transform = oldtransform, alpha = 255, time = 0)

/obj/effect/rune/proc/fail_invoke(show_message = TRUE)
	//This proc contains the effects of a rune if it is not invoked correctly, through either invalid wording or not enough cultists. By default, it's just a basic fizzle.
	if(!invisibility && show_message) // No visible messages if not visible
		visible_message("<span class='warning'>The markings pulse with a small flash of red light, then fall dark.</span>")
	animate(src, color = rgb(255, 0, 0), time = 0)
	animate(src, color = rune_blood_color, time = 5)


/obj/effect/rune/proc/check_icon()
	if(!SSticker.mode)//work around for maps with runes and cultdat is not loaded all the way
		var/bits = make_bit_triplet()
		icon = get_rune(bits)
	else
		icon = get_rune_cult(invocation)


//Malformed Rune: This forms if a rune is not drawn correctly. Invoking it does nothing but hurt the user.
/obj/effect/rune/malformed
	cultist_name = "Искажённая"
	cultist_desc = "Бесмыссленная тарабарщина. Использование этой руны ни к чему хорошему не приведёт."
	invocation = "Ra'sha yoka!"
	invoke_damage = 30

/obj/effect/rune/malformed/invoke(list/invokers)
	..()
	for(var/M in invokers)
		var/mob/living/L = M
		to_chat(L, "<span class='cultitalic'><b>Вы чувствуете угасание своих жизненных сил. [SSticker.cultdat.entity_title3] недоволен.<b></span>")
	qdel(src)

/mob/proc/null_rod_check() //The null rod, if equipped, will protect the holder from the effects of most runes
	var/obj/item/nullrod/N = locate() in src
	if(N)
		return N
	return FALSE

//Rite of Enlightenment: Converts a normal crewmember to the cult, or offer them as sacrifice if cant be converted.
/obj/effect/rune/convert
	cultist_name = "Подношение"
	cultist_desc = "Предлагайте неверующих вашему Божеству, конвертируя или принося их в жертву. Жертвы с душами приведут к появлению камня с захваченной душой. Это также может быть сделано с мозгами."
	invocation = "Mah'weyh pleggh at e'ntrath!"
	icon_state = "offering"
	req_cultists = 1
	allow_excess_invokers = TRUE
	rune_in_use = FALSE

/obj/effect/rune/convert/invoke(list/invokers)
	if(rune_in_use)
		return

	var/list/offer_targets = list()
	var/turf/T = get_turf(src)
	for(var/mob/living/M in T)
		if(!iscultist(M) || (M.mind && is_sacrifice_target(M.mind)))
			if(isconstruct(M)) // No offering constructs please
				continue
			offer_targets += M

	// Offering a head/brain
	for(var/obj/item/organ/O in T)
		var/mob/living/brain/b_mob
		if(istype(O, /obj/item/organ/external/head)) // Offering a head
			var/obj/item/organ/external/head/H = O
			for(var/obj/item/organ/internal/brain/brain in H.contents)
				b_mob = brain.brainmob
				brain.forceMove(T)

		else if(istype(O, /obj/item/organ/internal/brain)) // Offering a brain
			var/obj/item/organ/internal/brain/brain = O
			b_mob = brain.brainmob

		if(b_mob && b_mob.mind && (!iscultist(b_mob) || is_sacrifice_target(b_mob.mind)))
			offer_targets += b_mob

	if(!length(offer_targets))
		fail_invoke()
		log_game("Offer rune failed - no eligible targets")
		rune_in_use = FALSE
		return

	rune_in_use = TRUE
	var/mob/living/L = pick(offer_targets)
	if(HAS_TRAIT(L, TRAIT_CULT_IMMUNITY))
		fail_invoke(FALSE)
		for(var/I in invokers)
			to_chat(I, "<span class='warning'>Жертва уже была недавно конвертирована. Подождите немного перед повторной попыткой!</span>")
		rune_in_use = FALSE
		return

	if(L.stat != DEAD && is_convertable_to_cult(L.mind))
		..()
		do_convert(L, invokers)
	else
		invocation = "Barhah hra zar'garis!"
		..()
		do_sacrifice(L, invokers)
	rune_in_use = FALSE

/obj/effect/rune/convert/proc/do_convert(mob/living/convertee, list/invokers)
	if(length(invokers) < 2)
		fail_invoke()
		for(var/I in invokers)
			to_chat(I, "<span class='warning'>Требуется два культиста для конвертации!</span>")
		return
	else
		convertee.visible_message("<span class='warning'>[convertee] корчится от боли, а метки под ним светятся кроваво-красным!</span>", \
								"<span class='cultlarge'><i>AAAAAAAAAAAAAA-</i></span>")
		SSticker.mode.add_cultist(convertee.mind)
		convertee.mind.special_role = "Cultist"
		to_chat(convertee, "<span class='cultitalic'><b>Кровь и голова пульсирует, а мир становится красным. Внезапно вы осознаёте ужасную, чудовищную правду. Завеса реальности была содрана \
		и что-то зловещее пустило свои корни .</b></span>")
		to_chat(convertee, "<span class='cultitalic'><b>Помогайте своим соратникам в их тёмных делах. Ваша цель теперь их цель, а их цель теперь ваша. Вы служите [SSticker.cultdat.entity_title3] превыше всего. Верните его в этот мир.\
		</b></span>")

		if(ishuman(convertee))
			var/mob/living/carbon/human/H = convertee
			var/brutedamage = convertee.getBruteLoss()
			var/burndamage = convertee.getFireLoss()
			if(brutedamage || burndamage) // If the convertee is injured
				// Heal 90% of all damage, including robotic limbs
				H.adjustBruteLoss(-(brutedamage * 0.9), robotic = TRUE)
				H.adjustFireLoss(-(burndamage * 0.9), robotic = TRUE)
				if(ismachineperson(H))
					H.visible_message("<span class='warning'>Тёмные силы чинят [convertee]!</span>",
					"<span class='cultitalic'>Урон был починен. Теперь пускайте кровь других.</span>")
				else
					H.visible_message("<span class='warning'>Раны на теле[convertee] исцеляются и закрываются!</span>",
					"<span class='cultitalic'>Ваши раны были исцелены. Now spread the blood to others.</span>")
					for(var/obj/item/organ/external/E in H.bodyparts)
						E.mend_fracture()
						E.fix_internal_bleeding()
						E.fix_burn_wound()
					for(var/datum/disease/critical/crit in H.viruses) // cure all crit conditions
						crit.cure()

			H.uncuff()
			H.Silence(6 SECONDS) //Prevent "HALP MAINT CULT" before you realise you're converted

			var/obj/item/melee/cultblade/dagger/D = new(get_turf(src))
			if(H.equip_to_slot_if_possible(D, SLOT_HUD_IN_BACKPACK, FALSE, TRUE))
				to_chat(H, "<span class='cultlarge'>В вашем рюкзаке есть нож. Используйте его для исполнения воли [SSticker.cultdat.entity_title1]. </span>")
			else
				to_chat(H, "<span class='cultlarge'>На полу лежит нож. Используйте его для исполнения воли [SSticker.cultdat.entity_title1].</span>")

/obj/effect/rune/convert/proc/do_sacrifice(mob/living/offering, list/invokers)
	var/mob/living/user = invokers[1] //the first invoker is always the user

	if(offering.stat != DEAD || (offering.mind && is_sacrifice_target(offering.mind))) //Requires three people to sacrifice living targets/sacrifice objective
		if(length(invokers) < 3)
			for(var/M in invokers)
				to_chat(M, "<span class='cultitalic'>[offering] слишком сильно связана с этим миром! Требуется три аколита!</span>")
			fail_invoke()
			log_game("Sacrifice rune failed - not enough acolytes and target is living")
			return

	var/sacrifice_fulfilled
	var/worthless = FALSE
	var/datum/game_mode/gamemode = SSticker.mode

	if(isliving(offering) && !isbrain(offering))
		var/mob/living/L = offering
		if(isrobot(L) || ismachineperson(L))
			L.adjustBruteLoss(250)
		else
			L.adjustCloneLoss(120)
		L.death(FALSE)

	if(offering.mind)
		GLOB.sacrificed += offering.mind
		if(is_sacrifice_target(offering.mind))
			sacrifice_fulfilled = TRUE
	else
		GLOB.sacrificed += offering

	new /obj/effect/temp_visual/cult/sac(loc)
	for(var/M in invokers)
		if(sacrifice_fulfilled)
			to_chat(M, "<span class='cultlarge'>\"Да! Именно этого я и хотел! Ты хорошо послужил.\"</span>")
			if(!SSticker.cultdat.mirror_shields_active) // Only show once
				to_chat(M, "<span class='cultitalic'>Доступно создание зеркальных щитов в печке.</span>")
				SSticker.cultdat.mirror_shields_active = TRUE
		else
			if(ishuman(offering) && offering.mind?.offstation_role && offering.mind.special_role != SPECIAL_ROLE_ERT) //If you try it on a ghost role, you get nothing
				to_chat(M, "<span class='cultlarge'>\"Нам обоим эта душа ни к чему.\"</span>")
				worthless = TRUE
			else if(ishuman(offering) || isrobot(offering))
				to_chat(M, "<span class='cultlarge'>\"Я принимаю эту жетрву.\"</span>")
			else
				to_chat(M, "<span class='cultlarge'>\"Я принимаю эту жалкую жертву.\"</span>")
	playsound(offering, 'sound/misc/demon_consume.ogg', 100, TRUE, SOUND_RANGE_SET(10))

	if(((ishuman(offering) || isrobot(offering) || isbrain(offering)) && offering.mind) && !worthless)
		var/obj/item/soulstone/stone = new /obj/item/soulstone(get_turf(src))
		stone.invisibility = INVISIBILITY_MAXIMUM // So it's not picked up during transfer_soul()
		stone.transfer_soul("FORCE", offering, user) // If it cannot be added
		stone.invisibility = 0
	else
		if(isrobot(offering))
			offering.dust() //To prevent the MMI from remaining
		else
			offering.gib()
		playsound(offering, 'sound/magic/disintegrate.ogg', 100, TRUE, SOUND_RANGE_SET(10))
	if(sacrifice_fulfilled)
		gamemode.cult_objs.succesful_sacrifice()
	return TRUE

/obj/effect/rune/teleport
	cultist_name = "Телепорт"
	cultist_desc = "Перемещает всё, что находится поверх руны, на другую руну телепорта."
	invocation = "Sas'so c'arta forbici!"
	icon_state = "teleport"
	req_keyword = TRUE
	light_power = 4
	var/obj/effect/temp_visual/cult/portal/inner_portal //The portal "hint" for off-station teleportations
	var/obj/effect/temp_visual/cult/rune_spawn/rune2/outer_portal
	var/listkey

/obj/effect/rune/teleport/New(loc, set_keyword)
	..()
	var/area/A = get_area(src)
	var/locname = initial(A.name)
	listkey = set_keyword ? "[set_keyword] [locname]":"[locname]"
	GLOB.teleport_runes += src

/obj/effect/rune/teleport/Destroy()
	GLOB.teleport_runes -= src
	QDEL_NULL(inner_portal)
	QDEL_NULL(outer_portal)
	return ..()

/obj/effect/rune/teleport/invoke(list/invokers)
	var/mob/living/user = invokers[1] //the first invoker is always the user
	var/list/potential_runes = list()
	var/list/teleportnames = list()
	var/list/duplicaterunecount = list()

	for(var/I in GLOB.teleport_runes)
		var/obj/effect/rune/teleport/R = I
		var/resultkey = R.listkey
		if(resultkey in teleportnames)
			duplicaterunecount[resultkey]++
			resultkey = "[resultkey] ([duplicaterunecount[resultkey]])"
		else
			teleportnames += resultkey
			duplicaterunecount[resultkey] = 1
		if(R != src && is_level_reachable(R.z))
			potential_runes[resultkey] = R

	if(!length(potential_runes))
		to_chat(user, "<span class='warning'>Нет валидных рун для телепортации!</span>")
		log_game("Teleport rune failed - no other teleport runes")
		fail_invoke()
		return

	if(!is_level_reachable(user.z))
		to_chat(user, "<span class='cultitalic'>Вы слишком далеко от станции для телепортации!</span>")
		log_game("Teleport rune failed - user in away mission")
		fail_invoke()
		return

	var/input_rune_key = tgui_input_list(user, "Выберите руну для телепортации.", "Телепорт к руне", potential_runes) //we know what key they picked
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(QDELETED(src) || QDELETED(actual_selected_rune) ||!Adjacent(user) || user.incapacitated())
		fail_invoke()
		return

	var/turf/T = get_turf(src)
	var/turf/target = get_turf(actual_selected_rune)
	var/movedsomething = FALSE
	var/moveuser = FALSE
	for(var/atom/movable/A in T)
		if(ishuman(A))
			if(A != user) // Teleporting someone else
				INVOKE_ASYNC(src, PROC_REF(teleport_effect), A, T, target)
			else // Teleporting yourself
				INVOKE_ASYNC(src, PROC_REF(teleport_effect), user, T, target)
		if(A.move_resist == INFINITY)
			continue  //object cant move, shouldnt teleport
		if(A == user)
			moveuser = TRUE
			movedsomething = TRUE
			continue
		if(!A.anchored)
			movedsomething = TRUE
			A.forceMove(target)

	if(movedsomething)
		..()
		if(is_mining_level(z) && !is_mining_level(target.z)) //No effect if you stay on lavaland
			actual_selected_rune.handle_portal("lava")
		else if(!is_station_level(z) || istype(get_area(src), /area/space))
			actual_selected_rune.handle_portal("space", T)
		user.visible_message("<span class='warning'>Раздаётся резкий треск набегающего воздуха и всё над руной исчезает!</span>",
							"<span class='cult'>[moveuser ? "Ваше зрение замыливается и вы оказываетесь в другом месте":" Вы отправляете всё, что на руне, прочь"].</span>")
		if(moveuser)
			user.forceMove(target)
	else
		fail_invoke()

/obj/effect/rune/teleport/proc/handle_portal(portal_type, turf/origin)
	var/turf/T = get_turf(src)
	if(inner_portal || outer_portal)
		close_portal() // To avoid stacking descriptions/animations
	playsound(T, pick('sound/effects/sparks1.ogg', 'sound/effects/sparks2.ogg', 'sound/effects/sparks3.ogg', 'sound/effects/sparks4.ogg'), 100, TRUE, 14)
	inner_portal = new /obj/effect/temp_visual/cult/portal(T)

	if(portal_type == "space")
		light_color = color
		desc += "<br><span class='boldwarning'>Разрыв в реальности показывает чёрную бездну с проблесками света... что-то недавно телепортировалось сюда из космоса.</span><br>"

		// Space base near the station
		if(is_station_level(origin.z))
			desc += "<u><span class='warning'>Кажется, бездна хочет вас потянуть в сторону [dir2text(get_dir(T, origin))], недалеко от станции!</span></u>"
		// Space base on another Z-level
		else
			desc += "<u><span class='warning'>Кажется, бездна хочет вас потянуть в сторону [dir2text(get_dir(T, origin))], в направлении [origin.z] сектора космоса!</span></u>"

	else
		inner_portal.icon_state = "lava"
		light_color = LIGHT_COLOR_FIRE
		desc += "<br><span class='boldwarning'>Разрыв в реальности показывает реки текущей лавы... что-то недавно телепортировалось сюда с шахт Лавалэнда!</span>"

	outer_portal = new(T, 60 SECONDS, color)
	light_range = 4
	update_light()
	addtimer(CALLBACK(src, PROC_REF(close_portal)), 60 SECONDS, TIMER_UNIQUE)

/obj/effect/rune/teleport/proc/close_portal()
	qdel(inner_portal)
	qdel(outer_portal)
	desc = initial(desc)
	light_range = 0
	update_light()


//Rune of Empowering : Enables carrying 4 blood spells, greatly reduce blood cost
/obj/effect/rune/empower
	cultist_name = "Усиление"
	cultist_desc = "Позволяет культистам подготовить большее количество заклинаний за куда меньшую цену."
	invocation = "H'drak v'loso, mir'kanas verbot!"
	icon_state = "empower"
	construct_invoke = FALSE

/obj/effect/rune/empower/invoke(list/invokers)
	. = ..()
	var/mob/living/user = invokers[1] //the first invoker is always the user
	for(var/datum/action/innate/cult/blood_magic/BM in user.actions)
		BM.Activate()

//Rite of Resurrection: Requires a dead or inactive cultist. When reviving the dead, you can only perform one revival for every three sacrifices your cult has carried out.
/obj/effect/rune/raise_dead
	cultist_name = "Возрождение"
	cultist_desc = "requires a dead, alive, mindless, or inactive cultist placed upon the rune. For each three bodies sacrificed to the dark patron, one body will be mended and their mind awoken. Mending living cultist requires two cultists at the rune"
	invocation = "Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!" //Depends on the name of the user - see below
	icon_state = "revive"
	var/static/sacrifices_used = -SOULS_TO_REVIVE // Cultists get one "free" revive
	allow_excess_invokers = TRUE

/obj/effect/rune/raise_dead/examine(mob/user)
	. = ..()
	if(iscultist(user) || user.stat == DEAD)
		. += "<b>Свободных жертв:</b><span class='cultitalic'> [length(GLOB.sacrificed) - sacrifices_used]</span>"
		. += "<b>Цена в жертвах для воскрешения:</b><span class='cultitalic> [SOULS_TO_REVIVE]</span>"

/obj/effect/rune/raise_dead/proc/revive_alive(mob/living/target)
	target.visible_message("<span class='warning'>Dark magic begins to surround [target], regenerating their body.</span>")
	if(!do_after(target, 10 SECONDS, FALSE, target, allow_moving = FALSE, progress = TRUE))
		target.visible_message("<span class='warning'>Dark magic silently disappears.</span>")
		return FALSE
	target.revive()
	return TRUE

/obj/effect/rune/raise_dead/proc/revive_dead(mob/living/target)
	target.revive()
	if(target.ghost_can_reenter())
		target.grab_ghost()
	return TRUE

/obj/effect/rune/raise_dead/invoke(list/invokers)
	var/turf/T = get_turf(src)
	var/mob/living/mob_to_revive
	var/list/potential_revive_mobs = list()
	var/mob/living/user = invokers[1]
	if(rune_in_use)
		return
	rune_in_use = TRUE
	var/diff = length(GLOB.sacrificed) - SOULS_TO_REVIVE - sacrifices_used
	var/revived_from_dead = FALSE
	if(diff < 0)
		to_chat(user, "<span class='cult'>Your cult must carry out [abs(diff)] more sacrifice\s before it can revive another cultist!</span>")
		fail_invoke()
		return
	for(var/mob/living/M in T.contents)
		if(!iscultist(M))
			continue
		potential_revive_mobs |= M
	if(!length(potential_revive_mobs))
		to_chat(user, "<span class='cultitalic'>There are no cultists on the rune!</span>")
		log_game("Raise Dead rune failed - no cultists to revive")
		fail_invoke()
		return
	if(length(potential_revive_mobs) > 1)
		mob_to_revive = tgui_input_list(user, "Choose a cultist to revive.", "Cultist to Revive", potential_revive_mobs)
	else // If there's only one, no need for a menu
		mob_to_revive = potential_revive_mobs[1]
	if(!validness_checks(mob_to_revive, user))
		fail_invoke()
		return

	if(mob_to_revive.stat != DEAD && length(invokers) < 2)
		to_chat(user, "<span class='cultitalic'>You need at least two cultists to heal cultist!</span>")
		log_game("Raise Dead rune failed - not enough cultists to heal alive")
		fail_invoke()
		return

	if(mob_to_revive.stat != DEAD)
		if(!revive_alive(mob_to_revive))
			fail_invoke()
			return
	else
		if(!revive_dead(mob_to_revive))
			fail_invoke()
			return
		revived_from_dead = TRUE
	..()
	sacrifices_used += SOULS_TO_REVIVE

	if(!mob_to_revive.get_ghost() && (!mob_to_revive.client || mob_to_revive.client.is_afk()))
		set waitfor = FALSE
		to_chat(user, "<span class='cult'>[mob_to_revive] was revived, but their mind is lost! Seeking a lost soul to replace it.</span>")
		var/list/mob/dead/observer/candidates = SSghost_spawns.poll_candidates("Would you like to play as a revived Cultist?", ROLE_CULTIST, TRUE, poll_time = 20 SECONDS, source = /obj/item/melee/cultblade/dagger)
		if(length(candidates) && !QDELETED(mob_to_revive))
			var/mob/dead/observer/C = pick(candidates)
			to_chat(mob_to_revive, "<span class='biggerdanger'>Your physical form has been taken over by another soul due to your inactivity! Ahelp if you wish to regain your form.</span>")
			message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(mob_to_revive)]) to replace an AFK player.")
			mob_to_revive.ghostize(FALSE)
			mob_to_revive.key = C.key
			dust_if_respawnable(C)
		else
			fail_invoke()
			return
	if(!revived_from_dead)
		mob_to_revive.visible_message("<span class='warning'>[mob_to_revive] draws in a huge breath, red light shining from [mob_to_revive.p_their()] eyes.</span>", \
								"<span class='cultlarge'>All your injuries are now gone!</span>")
		rune_in_use = FALSE
		return
	SEND_SOUND(mob_to_revive, sound('sound/ambience/antag/bloodcult.ogg'))
	to_chat(mob_to_revive, "<span class='cultlarge'>\"PASNAR SAVRAE YAM'TOTH. Arise.\"</span>")
	mob_to_revive.visible_message("<span class='warning'>[mob_to_revive] draws in a huge breath, red light shining from [mob_to_revive.p_their()] eyes.</span>", \
								"<span class='cultlarge'>You awaken suddenly from the void. You're alive!</span>")
	rune_in_use = FALSE

/obj/effect/rune/raise_dead/proc/validness_checks(mob/living/target_mob, mob/living/user)
	if(QDELETED(src))
		return FALSE
	if(QDELETED(user))
		return FALSE
	if(!Adjacent(user) || user.incapacitated())
		return FALSE
	if(QDELETED(target_mob))
		return FALSE
	var/turf/T = get_turf(src)
	if(target_mob.loc != T)
		to_chat(user, "<span class='cultitalic'>The cultist to revive has been moved!</span>")
		log_game("Raise Dead rune failed - revival target moved")
		return FALSE
	return TRUE

/obj/effect/rune/raise_dead/fail_invoke()
	..()
	rune_in_use = FALSE
	for(var/mob/living/M in range(0, src))
		if(iscultist(M) && M.stat == DEAD)
			M.visible_message("<span class='warning'>[M] twitches.</span>")

//Rite of the Corporeal Shield: When invoked, becomes solid and cannot be passed. Invoke again to undo.
/obj/effect/rune/wall
	cultist_name = "Barrier"
	cultist_desc = "when invoked makes a temporary wall to block passage. Can be destroyed by brute force. Can be invoked again to reverse this."
	invocation = "Khari'd! Eske'te tannin!"
	icon_state = "barrier"
	///The barrier summoned by the rune when invoked. Tracked as a variable to prevent refreshing the barrier's integrity. shieldgen.dm
	var/obj/machinery/shield/cult/barrier/B

/obj/effect/rune/wall/Initialize(mapload)
	. = ..()
	B = new /obj/machinery/shield/cult/barrier(loc)
	B.parent_rune = src

/obj/effect/rune/wall/Destroy()
	if(B && !QDELETED(B))
		QDEL_NULL(B)
	return ..()

/obj/effect/rune/wall/invoke(list/invokers)
	var/mob/living/user = invokers[1]
	..()
	var/amount = 1
	if(B.Toggle()) // Toggling on
		for(var/obj/effect/rune/wall/rune in orange(1, src)) // Chaining barriers
			if(!rune.B.density) // Barrier is currently invisible
				amount++ // Count the invoke damage for each rune
				rune.do_invoke_glow()
				rune.B.Toggle()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.cult_self_harm(2 * amount)

//Rite of Joined Souls: Summons a single cultist.
/obj/effect/rune/summon
	cultist_name = "Призыв культиста"
	cultist_desc = "Телепортирует одного культиста к руне. <b><i>(Нельзя телепортировать связанных культистов!)</b></i>"
	invocation = "N'ath reth sh'yro eth d'rekkathnor!"
	req_cultists = 2
	invoke_damage = 10
	icon_state = "summon"

/obj/effect/rune/summon/invoke(list/invokers)
	var/mob/living/user = invokers[1]
	var/list/cultists = list()

	for(var/datum/mind/M in SSticker.mode.cult)
		if(!(M.current in invokers) && M.current && M.current.stat != DEAD)
			cultists[M.current.real_name] = M.current
	var/input = tgui_input_list(user, "Кого вы хотите вызвать [src]?", "Аколиты", cultists)
	var/mob/living/cultist_to_summon = cultists[input]
	if(QDELETED(src) || !Adjacent(user) || user.incapacitated())
		return
	if(!cultist_to_summon)
		log_game("Summon Cultist rune failed - no target")
		return
	if(cultist_to_summon.stat == DEAD)
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] умер!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - target died")
		return
	if(cultist_to_summon.pulledby || cultist_to_summon.buckled)
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] сдерживает!</span>")
		to_chat(cultist_to_summon, "<span class='cult'>You feel a tugging sensation, but you are being held in place!")
		fail_invoke()
		log_game("Summon Cultist rune failed - target restrained")
		return
	if(!iscultist(cultist_to_summon))
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] не культист [SSticker.cultdat.entity_title3]!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - target was deconverted")
		return
	if(is_away_level(cultist_to_summon.z))
		to_chat(user, "<span class='cultitalic'>[cultist_to_summon] не в нашем измерении!</span>")
		fail_invoke()
		log_game("Summon Cultist rune failed - target in away mission")
		return

	cultist_to_summon.visible_message("<span class='warning'>[cultist_to_summon] suddenly disappears in a flash of red light!</span>", \
									"<span class='cultitalic'><b>Overwhelming vertigo consumes you as you are hurled through the air!</b></span>")
	..()
	INVOKE_ASYNC(src, PROC_REF(teleport_effect), cultist_to_summon, get_turf(cultist_to_summon), src)
	visible_message("<span class='warning'>[src] begins to bubble and rises into the form of [cultist_to_summon]!</span>")
	cultist_to_summon.forceMove(get_turf(src))
	qdel(src)

/**
  * # Blood Boil Rune
  *
  * When invoked deals up to 30 burn damage to nearby non-cultists and sets them on fire.
  *
  * On activation the rune charges for six seconds, changing colour, glowing, and giving out a warning to all nearby mobs.
  * After the charging period the rune burns any non-cultists in view and sets them on fire. After another short wait it does the same again with slightly higher damage.
  * If the cultists channeling the rune move away or are stunned at any point, the rune is deleted. So it can be countered pretty easily with flashbangs.
  */
/obj/effect/rune/blood_boil
	cultist_name = "Кипячение крови"
	cultist_desc = "boils the blood of non-believers who can see the rune, rapidly dealing extreme amounts of damage. Requires 2 invokers channeling the rune."
	invocation = "Dedo ol'btoh!"
	icon_state = "blood_boil"
	light_color = LIGHT_COLOR_LAVA
	req_cultists = 2
	invoke_damage = 15
	construct_invoke = FALSE
	var/tick_damage = 10 // 30 burn damage total + damage taken by being on fire/overheating
	rune_in_use = FALSE

/obj/effect/rune/blood_boil/invoke(list/invokers)
	if(rune_in_use)
		return
	..()
	rune_in_use = TRUE
	var/turf/T = get_turf(src)
	var/list/targets = list()
	for(var/mob/living/L in viewers(T))
		if(!iscultist(L) && L.blood_volume && !ismachineperson(L))
			var/atom/I = L.null_rod_check()
			if(I)
				if(isitem(I))
					to_chat(L, "<span class='userdanger'>[I] suddenly burns hotly before returning to normal!</span>")
				continue
			targets += L

	// Six seconds buildup
	visible_message("<span class='warning'>A haze begins to form above [src]!</span>")
	animate(src, color = "#FC9A6D", time = 6 SECONDS)
	set_light(6, 1, color)
	sleep(6 SECONDS)
	visible_message("<span class='boldwarning'>[src] turns a bright, burning orange!</span>")
	if(!burn_check())
		return

	for(var/I in targets)
		to_chat(I, "<span class='userdanger'>Your blood boils in your veins!</span>")
	do_area_burn(T, 1)
	animate(src, color = "#FFDF80", time = 5 SECONDS)
	sleep(5 SECONDS)
	if(!burn_check())
		return

	do_area_burn(T, 2)
	animate(src, color = "#FFFFFF", time = 5 SECONDS)
	sleep(5 SECONDS)
	if(!burn_check())
		return

	do_area_burn(T, 3)
	qdel(src)

/obj/effect/rune/blood_boil/proc/do_area_burn(turf/T, iteration)
	var/multiplier = iteration / 2 // Iteration 1 = 0.5, Iteration 2 = 1, etc.
	set_light(6, 1 * iteration, color)
	for(var/mob/living/L in viewers(T))
		if(!iscultist(L) && L.blood_volume && !ismachineperson(L))
			if(L.null_rod_check())
				continue
			L.take_overall_damage(0, tick_damage * multiplier)
			L.adjust_fire_stacks(2)
			L.IgniteMob()
	playsound(src, 'sound/effects/bamf.ogg', 100, TRUE)
	do_invoke_glow()
	sleep(0.6 SECONDS) // Only one 'animate()' can play at once, so this waits for the pulse to finish

/obj/effect/rune/blood_boil/proc/burn_check()
	. = TRUE
	if(QDELETED(src))
		return FALSE
	var/list/cultists = list()
	for(var/mob/living/M in range(1, src)) // Get all cultists currently in range
		if(iscultist(M) && !M.incapacitated())
			cultists += M

	if(length(cultists) < req_cultists) // Stop the rune there's not enough invokers
		visible_message("<span class='warning'>[src] теряет своё свечение и испаряется!</span>")
		qdel(src)

/obj/effect/rune/manifest
	cultist_name = "Мир духов"
	cultist_desc = "manifests a spirit servant of the Dark One and allows you to ascend as a spirit yourself. The invoker must not move from atop the rune, and will take damage for each summoned spirit."
	invocation = "Gal'h'rfikk harfrandid mud'gib!" //how the fuck do you pronounce this
	icon_state = "spirit_realm"
	construct_invoke = FALSE
	var/mob/dead/observer/ghost = null //The cult ghost of the user
	var/default_ghost_limit = 4 //Lowered by the amount of cult objectives done
	var/minimum_ghost_limit = 2 //But cant go lower than this
	var/ghosts = 0

/obj/effect/rune/manifest/examine(mob/user)
	. = ..()
	if(iscultist(user) || user.stat == DEAD)
		. += "<b>Количество призванных призраков:</b><span class='cultitalic'> [ghosts]</span>"
		. += "<b>Максимальное количество призраков:</b><span class='cultitalic'> [clamp(default_ghost_limit - SSticker.mode.cult_objs.sacrifices_done, minimum_ghost_limit, default_ghost_limit)]</span>"
		. += "Уменьшает до минимума в [minimum_ghost_limit] за каждую выполненную цель."

/obj/effect/rune/manifest/invoke(list/invokers)
	. = ..()
	var/mob/living/user = invokers[1]
	var/turf/T = get_turf(src)
	if(!(user in get_turf(src)))
		to_chat(user, "<span class='cultitalic'>Вы должны стоять на [src]!</span>")
		fail_invoke()
		log_game("Manifest rune failed - user not standing on rune")
		return
	if(user.has_status_effect(STATUS_EFFECT_SUMMONEDGHOST))
		to_chat(user, "<span class='cultitalic'>Призраки не могут призывать призраков!</span>")
		fail_invoke()
		log_game("Manifest rune failed - user is a ghost")
		return

	var/choice = alert(user, "Вы открываете соединение к миру духов...", null, "Призыв призрака культа", "Ascend as a Dark Spirit", "Cancel")
	if(choice == "Summon a Cult Ghost")
		if(!is_station_level(z) || istype(get_area(src), /area/space))
			to_chat(user, "<span class='cultitalic'>Завеса здесь недостаточно слаба, вы должны быть на станции!</span>")
			fail_invoke()
			log_game("Manifest rune failed - not on station")
			return
		if(user.health <= 40)
			to_chat(user, "<span class='cultitalic'>Ваше тело слишком слабо для поддержания духов, вылечитесь.</span>")
			fail_invoke()
			log_game("Manifest rune failed - not enough health")
			return list()
		if(ghosts >= clamp(default_ghost_limit - SSticker.mode.cult_objs.sacrifices_done, minimum_ghost_limit, default_ghost_limit))
			to_chat(user, "<span class='cultitalic'>Вы поддерживаете слишком много призраков!</span>")
			fail_invoke()
			log_game("Manifest rune failed - too many summoned ghosts")
			return list()
		summon_ghosts(user, T)

	else if(choice == "Ascend as a Dark Spirit")
		ghostify(user, T)


/obj/effect/rune/manifest/proc/summon_ghosts(mob/living/user, turf/T)
	notify_ghosts("Manifest rune created in [get_area(src)].", ghost_sound = 'sound/effects/ghost2.ogg', source = src)
	var/list/ghosts_on_rune = list()
	for(var/mob/dead/observer/O in T)
		if(!O.client)
			continue
		if(iscultist(O) || jobban_isbanned(O, ROLE_CULTIST))
			continue
		if(!HAS_TRAIT(O, TRAIT_RESPAWNABLE) || QDELETED(src) || QDELETED(O))
			continue
		if(O.mind.current && HAS_TRAIT(O.mind.current, SCRYING))
			continue
		ghosts_on_rune += O
	if(!length(ghosts_on_rune))
		to_chat(user, "<span class='cultitalic'>There are no spirits near [src]!</span>")
		fail_invoke()
		log_game("Manifest rune failed - no nearby ghosts")
		return list()

	var/mob/dead/observer/ghost_to_spawn = pick(ghosts_on_rune)
	var/mob/living/carbon/human/new_human = new(T)
	new_human.real_name = ghost_to_spawn.real_name
	new_human.key = ghost_to_spawn.key
	new_human.gender = ghost_to_spawn.gender
	new_human.alpha = 150 //Makes them translucent
	new_human.equipOutfit(/datum/outfit/ghost_cultist) //give them armor
	new_human.apply_status_effect(STATUS_EFFECT_SUMMONEDGHOST, user) //ghosts can't summon more ghosts, also lets you see actual ghosts
	for(var/obj/item/organ/external/current_organ in new_human.bodyparts)
		current_organ.limb_flags |= CANNOT_DISMEMBER //you can't chop of the limbs of a ghost, silly
	ghosts++
	playsound(src, 'sound/misc/exit_blood.ogg', 50, TRUE, SOUND_RANGE_SET(10))
	user.visible_message("<span class='warning'>A cloud of red mist forms above [src], and from within steps... a [new_human.gender == FEMALE ? "wo" : ""]man.</span>",
						"<span class='cultitalic'>Your blood begins flowing into [src]. You must remain in place and conscious to maintain the forms of those summoned. This will hurt you slowly but surely...</span>")

	var/obj/machinery/shield/cult/weak/shield = new(T)
	SSticker.mode.add_cultist(new_human.mind, 0)
	to_chat(new_human, "<span class='cultlarge'>You are a servant of the [SSticker.cultdat.entity_title3]. You have been made semi-corporeal by the cult of [SSticker.cultdat.entity_name], and you are to serve them at all costs.</span>")

	while(!QDELETED(src) && !QDELETED(user) && !QDELETED(new_human) && (user in T))
		if(new_human.InCritical())
			to_chat(user, "<span class='cultitalic'>You feel your connection to [new_human.real_name] severs as they are destroyed.</span>")
			if(ghost)
				to_chat(ghost, "<span class='cultitalic'>You feel your connection to [new_human.real_name] severs as they are destroyed.</span>")
			break
		if(user.stat || user.health <= 40)
			to_chat(user, "<span class='cultitalic'>Your body can no longer sustain the connection, and your link to the spirit realm fades.</span>")
			if(ghost)
				to_chat(ghost, "<span class='cultitalic'>Your body is damaged and your connection to the spirit realm weakens, any ghost you may have manifested are destroyed.</span>")
			break
		user.apply_damage(0.1, BRUTE)
		user.apply_damage(0.1, BURN)
		sleep(2) //Takes two pylons to sustain the damage taken by summoning one ghost

	qdel(shield)
	ghosts--
	if(new_human)
		new_human.visible_message("<span class='warning'>[new_human] suddenly dissolves into bones and ashes.</span>",
								"<span class='cultlarge'>Your link to the world fades. Your form breaks apart.</span>")
		for(var/obj/item/I in new_human.get_all_slots())
			new_human.unEquip(I)
		SSticker.mode.remove_cultist(new_human.mind, FALSE)
		new_human.dust()

/obj/effect/rune/manifest/proc/ghostify(mob/living/user, turf/T)
	ADD_TRAIT(user, SCRYING, CULT_TRAIT)
	user.add_atom_colour(RUNE_COLOR_DARKRED, ADMIN_COLOUR_PRIORITY)
	user.visible_message("<span class='warning'>[user] freezes statue-still, glowing an unearthly red.</span>",
					"<span class='cult'>You see what lies beyond. All is revealed. In this form you find that your voice booms above all others.</span>")
	ghost = user.ghostize(TRUE)
	var/datum/action/innate/cult/comm/spirit/CM = new
	var/datum/action/innate/cult/check_progress/V = new
	//var/datum/action/innate/cult/ghostmark/GM = new
	ghost.name = "Dark Spirit of [ghost.name]"
	ghost.color = "red"
	CM.Grant(ghost)
	V.Grant(ghost)
	//GM.Grant(ghost)
	while(!QDELETED(user))
		if(user.key || QDELETED(src))
			user.visible_message("<span class='warning'>[user] slowly relaxes, the glow around [user.p_them()] dimming.</span>",
								"<span class='danger'>You are re-united with your physical form. [src] releases its hold over you.</span>")
			user.Weaken(6 SECONDS)
			break
		if(user.health <= 10)
			to_chat(ghost, "<span class='cultitalic'>Your body can no longer sustain the connection!</span>")
			break
		if(!(user in T))
			user.visible_message("<span class='warning'>A spectral tendril wraps around [user] and pulls [user.p_them()] back to the rune!</span>")
			Beam(user, icon_state = "drainbeam", time = 2)
			user.forceMove(get_turf(src)) //NO ESCAPE :^)
		sleep(5)
	if(user.grab_ghost())
		CM.Remove(ghost)
		V.Remove(ghost)
		//GM.Remove(ghost)
	REMOVE_TRAIT(user, SCRYING, CULT_TRAIT)
	user.remove_atom_colour(ADMIN_COLOUR_PRIORITY, RUNE_COLOR_DARKRED)
	user = null
	rune_in_use = FALSE


//Ritual of Dimensional Rending: Calls forth the avatar of Nar'Sie upon the station.
/obj/effect/rune/narsie
	cultist_name = "Разрыв завесы"
	cultist_desc = "разрывает пространственный барьер, призывая ваше Божество."
	invocation = "TOK-LYR RQA-NAP G'OLT-ULOFT!!"
	req_cultists = 9
	icon = 'icons/effects/96x96.dmi'
	icon_state = "rune_large"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	mouse_opacity = MOUSE_OPACITY_ICON //we're huge and easy to click
	scribe_delay = 45 SECONDS //how long the rune takes to create
	scribe_damage = 10 //how much damage you take doing it
	var/used = FALSE

/obj/effect/rune/narsie/New()
	..()
	cultist_name = "Призыв [SSticker.cultdat ? SSticker.cultdat.entity_name : "вашего Божества"]"
	cultist_desc = "разрывает пространственный барьер, призывая [SSticker.cultdat ? SSticker.cultdat.entity_title3 : "Ваше Божество"]."

/obj/effect/rune/narsie/check_icon()
	return

/obj/effect/rune/narsie/cult_conceal() //can't hide this, and you wouldn't want to
	return

/obj/effect/rune/narsie/is_cleanable() //No, you can't just yeet a cleaning grenade to remove it.
	return FALSE

/obj/effect/rune/narsie/invoke(list/invokers)
	if(used)
		return
	var/mob/living/user = invokers[1]
	var/datum/game_mode/gamemode = SSticker.mode
	if(!is_station_level(user.z))
		message_admins("[key_name_admin(user)] tried to summon an eldritch horror off station")
		log_game("Summon Nar'Sie rune failed - off station Z level")
		return
	if(gamemode.cult_objs.cult_status == NARSIE_HAS_RISEN)
		for(var/M in invokers)
			to_chat(M, "<span class='cultlarge'>\"Я уже здесь. Нет нужды пытаться повторно меня призвать.\"</span>")
		log_game("Summon god rune failed - already summoned")
		return

	//BEGIN THE SUMMONING
	gamemode.cult_objs.succesful_summon()
	used = TRUE
	color = COLOR_RED
	..()

	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M)) // exclude people in the lobby
			SEND_SOUND(M, sound('modular_ss220/aesthetics_sounds/sound/narsie/narsie_summon.ogg')) //SS220 EDIT
			to_chat(M, "<span class='cultitalic'><b>Завеса <span class='big'>была...</span> <span class='reallybig'>РАЗОРВАНА!!!--</span></b></span>")

	icon_state = "rune_large_distorted"
	var/turf/T = get_turf(src)
	sleep(40)
	new /obj/singularity/narsie/large(T) //Causes Nar'Sie to spawn even if the rune has been removed

/obj/effect/rune/narsie/attackby(obj/I, mob/user, params)	//Since the narsie rune takes a long time to make, add logging to removal.
	if((istype(I, /obj/item/melee/cultblade/dagger) && iscultist(user)))
		log_game("Руна Призыва НарСи была стёрта [key_name(user)] с помощью ринуального клинка")
		message_admins("[key_name_admin(user)] удалил руну Нар'Си ритуальным клинком")
	if(istype(I, /obj/item/nullrod))	//Begone foul magiks. You cannot hinder me.
		log_game("Руна Призыва НарСи была стёрта [key_name(user)] с помощью нулевого стержня")
		message_admins("[key_name_admin(user)] erased a Narsie rune with a null rod")
	return ..()
