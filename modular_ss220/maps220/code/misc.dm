/obj/machinery/wish_granter_dark
	name = "Исполнитель Желаний"
	desc = "Вы уже не уверены в этом..."
	icon = 'modular_ss220/maps220/icons/wish_granter.dmi'
	icon_state = "wish_granter"

	anchored = TRUE
	density = TRUE
	power_state = NO_POWER_USE

	/// The various mutations that are given when making a Power wish
	var/power_mutations
	/// How many times can be used
	var/charges = 1
	/// Has it been clicked once? (Need for warning users)
	var/insisting = FALSE

/obj/machinery/wish_granter_dark/Initialize(mapload)
	. = ..()
	power_mutations = list(/datum/mutation/meson_vision, /datum/mutation/night_vision, /datum/mutation/cold_resist, /datum/mutation/grant_spell/cryo)

/obj/machinery/wish_granter_dark/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user))
		. += SPAN_CULTSPEECH("Ваше культисткое чутье подсказывает вам, что [name] искушает вас, дабы завладеть вашей душой.")
	if(!charges)
		. += SPAN_NOTICE("[name] не подаёт никаких признаков активности.")
	else
		. += SPAN_NOTICE("[name] издаётся манящим кроваво-красным светом.")

/obj/machinery/wish_granter_dark/update_icon_state()
	if(!charges)
		icon_state = initial(icon_state) + "_dormant"
	if(insisting)
		icon_state = initial(icon_state) + "_pulse"

/obj/machinery/wish_granter_dark/attack_hand(mob/living/carbon/human/user as mob)
	usr.set_machine(src)

	if(!charges)
		to_chat(user, SPAN_NOTICE("[name] никак не реагирует."))
		return

	else if(!ishuman(user))
		to_chat(user, SPAN_WARNING("Вы чувствуете темное движение внутри [name], которого опасаются ваши инстинкты."))
		return

	else if(is_special_character(user))
		to_chat(user, SPAN_NOTICE("Что-то инстинктивно заставляет вас отстраниться."))
		return

	else if(!insisting)
		to_chat(user, SPAN_CULT("Ваше первое прикосновение заставляет [name] зашевелиться, прислушиваясь к вам. Вы действительно уверены, что хотите это сделать?"))
		insisting = TRUE
		update_icon(UPDATE_ICON_STATE)
		return

	insisting = FALSE
	var/wish = tgui_input_list(user, "Вы хотите...", "Желание", list("Силу", "Богатство", "Бессмертие", "Покой"))
	if(!wish)
		return
	charges--
	update_icon(UPDATE_ICON_STATE)

	var/mob/living/carbon/human/human = user
	var/become_shadow = TRUE
	var/list/output = list()
	switch(wish)
		if("Силу")
			for(var/mutation_type in power_mutations)
				var/datum/mutation/mutation = GLOB.dna_mutations[mutation_type]
				mutation.activate(human)

		if("Богатство")
			var/obj/structure/closet/syndicate/resources/everything/C = new /obj/structure/closet/syndicate/resources/everything(loc)
			var/dice = pickweight(list(
				/obj/item/dice/d20/fate,
				/obj/item/dice/d20/fate/one_use = 9,
			))
			new dice(C)

		if("Бессмертие")
			user.verbs |= /mob/living/carbon/human/proc/immortality

		if("Покой")
			for(var/mob/living/basic/netherworld/faithless/F in GLOB.mob_living_list)
				F.death()
			become_shadow = FALSE

	if(become_shadow && !isshadowperson(human))
		to_chat(user, SPAN_WARNING("Ваша плоть темнеет!"))
		to_chat(user, SPAN_WARNING("Ваше тело бурно реагирует на свет, однако естественным образом исцеляется в темноте..."))
		output.Add(SPAN_USERDANGER("Ваше желание исполнено, но какой ценой?..."))
		output.Add(SPAN_DANGER("[name] наказывает вас за ваш эгоизм, забирая душу и деформируя тело, чтобы оно соответствовало тьме в вашем сердце."))
		output.Add(SPAN_REVENBIGNOTICE("Вы теперь <b>Тень</b>, раса живущих во тьме гуманоидов."))
		output.Add(SPAN_REVENBOLDNOTICE("Помимо ваших новых качеств, вы психически не изменились и сохраняете свою прежнюю личность."))
		human.set_species(/datum/species/shadow)
		user.regenerate_icons()
	else
		output.Add(SPAN_BOLDNOTICE("Вы чувствуете как избежали горькой судьбы..."))
		output.Add(SPAN_NOTICE("Каким бы инопланетным разумом ни обладал [name], оно удовлетворяет ваше желание.\nНаступает тишина..."))

	to_chat(user, chat_box_red(output.Join("<br>")))

#define TRAIT_REVIVAL_IN_PROGRESS "revival_in_progress"

/mob/living/carbon/human/proc/immortality()
	set category = "Бессмертие"
	set name = "Возрождение"

	if(stat != DEAD)
		to_chat(src, SPAN_NOTICE("Вы еще живы!"))
		return

	if(HAS_TRAIT(src, TRAIT_REVIVAL_IN_PROGRESS))
		to_chat(src, SPAN_NOTICE("Вы уже восстаёте из мертвых!"))
		return

	ADD_TRAIT(src, TRAIT_REVIVAL_IN_PROGRESS, "Immortality")
	to_chat(src, SPAN_NOTICE("Смерть - ещё не конец!"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, resurrect)), rand(80 SECONDS, 120 SECONDS))

/mob/living/carbon/human/proc/resurrect()
	revive()
	REMOVE_TRAIT(src, TRAIT_REVIVAL_IN_PROGRESS, "Immortality")
	to_chat(src, SPAN_NOTICE("Вы вернулись из небытия."))
	visible_message(SPAN_WARNING("[name] восстаёт из мертвых, исцелив все свои раны!"))

#undef TRAIT_REVIVAL_IN_PROGRESS
