/datum/spell/aoe/conjure/build/mime_wall
	name = "Invisible Wall"
	desc = "Метериальные пантомимы!"
	summon_type = list(/obj/structure/forcefield/mime)
	invocation_type = "emote"
	invocation_emote_self = SPAN_NOTICE("Вы возводите перед собой стену.")
	summon_lifespan = 20 SECONDS
	base_cooldown = 30 SECONDS
	clothes_req = FALSE
	cast_sound = null
	human_req = TRUE
	antimagic_flags = NONE

	action_icon_state = "mime"
	action_background_icon_state = "bg_mime"

/datum/spell/aoe/conjure/build/mime_wall/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, SPAN_NOTICE("Сначала вы должны принять обет молчания."))
			return
		invocation = "<B>[usr.name]</B> выглядит так, как будто перед [usr.ru_p_them()] находится стена."
	else
		invocation_type ="none"
	..()

/datum/spell/mime/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/mime/speak
	name = "Speech"
	desc = "Примите или нарушьте обет молчания."
	clothes_req = FALSE
	base_cooldown = 5 MINUTES
	human_req = TRUE

	action_icon_state = "mime_silence"
	action_background_icon_state = "bg_mime"

/datum/spell/mime/speak/Click()
	if(!usr)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.mind.miming)
		still_recharging_msg = SPAN_WARNING("Вы не можете так быстро нарушить свой обет молчания!")
	else
		still_recharging_msg = SPAN_WARNING("Вам придется подождать, прежде чем вы сможете снова дать свой обет молчания!")
	..()

/datum/spell/mime/speak/cast(list/targets,mob/user = usr)
	for(var/mob/living/carbon/human/H in targets)
		H.mind.miming=!H.mind.miming
		if(H.mind.miming)
			to_chat(H, SPAN_NOTICE("Вы даёте обет молчания."))
		else
			to_chat(H, SPAN_NOTICE("Вы нарушаете свой обет молчания."))

//Advanced Mimery traitor item spells

/datum/spell/forcewall/mime
	name = "Invisible Greater Wall"
	desc = "Возведите невидимую стену шириной в три метра."
	wall_type = /obj/effect/forcefield/mime
	invocation_type = "emote"
	invocation_emote_self = SPAN_NOTICE("Вы возводите перед собой широкую стену.")
	base_cooldown = 60 SECONDS
	sound =  null

	action_icon_state = "mime_bigwall"
	action_background_icon_state = "bg_mime"

/datum/spell/forcewall/mime/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, SPAN_NOTICE("Сначала вы должны посвятить себя тишине."))
			return
		invocation = "<B>[usr.name]</B> выглядит так, как будто перед [usr.ru_p_them()] находится стена."
	else
		invocation_type ="none"
	..()

/datum/spell/mime/fingergun
	name = "Finger Gun"
	desc = "Стреляйте летальными бесшумными пулями прямо из пальцев! Для каждой активации доступно по 3 пули. Используйте пальцы, чтобы спрятать их в кобуру."
	clothes_req = FALSE
	base_cooldown = 30 SECONDS
	human_req = TRUE
	antimagic_flags = NONE

	action_icon_state = "fingergun"
	action_background_icon_state = "bg_mime"
	var/gun = /obj/item/gun/projectile/revolver/fingergun
	var/obj/item/gun/projectile/revolver/fingergun/current_gun

/datum/spell/mime/fingergun/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/human/C in targets)
		if(!current_gun)
			to_chat(user, SPAN_NOTICE("Вы приготавливаете свои пальцы для стрельбы!"))
			current_gun = new gun(get_turf(user), src)
			C.drop_item()
			C.put_in_hands(current_gun)
			RegisterSignal(C, COMSIG_MOB_WILLINGLY_DROP, PROC_REF(holster_hand))
		else
			holster_hand(user, TRUE)
			revert_cast(user)


/datum/spell/mime/fingergun/Destroy()
	current_gun = null
	return ..()

/datum/spell/mime/fingergun/proc/holster_hand(atom/target, any=FALSE)
	SIGNAL_HANDLER
	if(!current_gun || !any && action.owner.get_active_hand() != current_gun)
		return
	to_chat(action.owner, SPAN_NOTICE("Вы прячете пальцы в кобуру. Возможно, в другой раз..."))
	QDEL_NULL(current_gun)

/datum/spell/mime/fingergun/fake
	desc = "Представьте, что вы стреляете бесшумными пулями прямо из пальцев! Для каждой активации доступно по 3 пули. Используйте пальцы, чтобы спрятать их в кобуру."
	gun = /obj/item/gun/projectile/revolver/fingergun/fake

// Mime Spellbooks

/obj/item/spellbook/oneuse/mime
	spell = /datum/spell/aoe/conjure/build/mime_wall
	spellname = "Invisible Wall"
	name = "Miming Manual : "
	desc = "В нем содержатся различные фотографии мимов в середине выступления, а также несколько иллюстрированных руководств."
	icon_state = "bookmime"

/obj/item/spellbook/oneuse/mime/attack_self__legacy__attackchain(mob/user)
	var/datum/spell/S = new spell
	for(var/datum/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == S.type)
			if(user.mind)
				to_chat(user, SPAN_NOTICE("Вы уже читали его раньше."))
			return
	if(used)
		recoil(user)
	else
		user.mind.AddSpell(S)
		to_chat(user, SPAN_NOTICE("Вы листаете страницы. Ваше понимание границ реальности увеличивается. Теперь вы можете использовать [spellname]!"))
		user.create_log(MISC_LOG, "learned the spell [spellname] ([S])")
		user.create_attack_log("<font color='orange'>[key_name(user)] learned the spell [spellname] ([S]).</font>")
		onlearned(user)

/obj/item/spellbook/oneuse/mime/recoil(mob/user)
	to_chat(user, SPAN_NOTICE("Вы листаете страницы. Там нет ничего интересного для вас."))

/obj/item/spellbook/oneuse/mime/onlearned(mob/user)
	used = TRUE
	if(!locate(/datum/spell/mime/speak) in user.mind.spell_list) //add vow of silence if not known by user
		user.mind.AddSpell(new /datum/spell/mime/speak)
		to_chat(user, SPAN_NOTICE("Вы узнали, как использовать тишину для улучшения своего таланта."))

/obj/item/spellbook/oneuse/mime/fingergun
	spell = /datum/spell/mime/fingergun
	spellname = "Finger Gun"
	desc = "Содержит иллюстрации с изображением оружия и способы имитации его использования."

/obj/item/spellbook/oneuse/mime/fingergun/fake
	spell = /datum/spell/mime/fingergun/fake

/obj/item/spellbook/oneuse/mime/greaterwall
	spell = /datum/spell/forcewall/mime
	spellname = "Invisible Greater Wall"
	desc = "Содержит иллюстрации самых великих стен в истории театра иллюзий."
