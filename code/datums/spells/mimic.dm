/datum/spell/mimic
	name = "Mimic"
	desc = "Изучите новую форму для имитации или мимикрируйте в уже известную."
	clothes_req = FALSE
	base_cooldown = 3 SECONDS
	action_icon_state = "morph_mimic"
	selection_activated_message = SPAN_SINISTER("Нажмите на цель, чтобы запомнить ее форму. Нажмите на себя, чтобы изменить форму.")
	create_attack_logs = FALSE
	/// Which form is currently selected
	var/datum/mimic_form/selected_form
	/// Which forms the user can become
	var/list/available_forms = list()
	/// How many forms the user can remember
	var/max_forms = 5
	/// Which index will be overriden next when the user wants to remember another form
	var/next_override_index = 1
	/// If a message is shown when somebody examines the user from close range
	var/perfect_disguise = FALSE

	var/static/list/black_listed_form_types = list(
		/atom/movable/screen,
		/obj/singularity,
		/obj/effect,
		/mob/living/simple_animal/hostile/megafauna,
		/obj/machinery/dna_vault,
		/obj/machinery/power/bluespace_tap,
		/obj/machinery/barsign,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/gravity_generator
	)


/datum/spell/mimic/create_new_targeting()
	var/datum/spell_targeting/click/T = new
	T.include_user = TRUE // To change forms
	T.allowed_type = /atom/movable
	T.try_auto_target = FALSE
	T.click_radius = -1
	return T

/datum/spell/mimic/valid_target(atom/target, user)
	if(is_type_in_list(target, black_listed_form_types))
		return FALSE
	if(istype(target, /atom/movable))
		var/atom/movable/AM = target
		if(AM.bound_height > world.icon_size || AM.bound_width > world.icon_size)
			return FALSE // No multitile structures
	if(user != target && ismorph(target))
		return FALSE
	return ..()

/datum/spell/mimic/cast(list/targets, mob/user)
	var/atom/movable/A = targets[1]
	if(A == user)
		INVOKE_ASYNC(src, PROC_REF(pick_form), user)
		return

	INVOKE_ASYNC(src, PROC_REF(remember_form), A, user)

/datum/spell/mimic/proc/remember_form(atom/movable/A, mob/user)
	if(A.name in available_forms)
		to_chat(user, SPAN_WARNING("[A] - уже доступная форма."))
		revert_cast(user)
		return
	if(length(available_forms) >= max_forms)
		to_chat(user, SPAN_WARNING("Вы начинаете забывать форму [available_forms[next_override_index]], чтобы выучить новую."))

	to_chat(user, SPAN_SINISTER("Вы начинаете запоминать форму [A]."))
	if(!do_after(user, 2 SECONDS, FALSE, user))
		to_chat(user, SPAN_WARNING("Вы потеряли концентрацию."))
		return

	// Forget the old form if needed
	if(length(available_forms) >= max_forms)
		qdel(available_forms[available_forms[next_override_index]]) // Delete the value using the key
		available_forms[next_override_index++] = A.name
		// Reset if needed
		if(next_override_index > max_forms)
			next_override_index = 1

	available_forms[A.name] = new /datum/mimic_form(A, user)
	to_chat(user, SPAN_SINISTER("Вы изучаете форму [A]."))

/datum/spell/mimic/proc/pick_form(mob/user)
	if(!length(available_forms) && !selected_form)
		to_chat(user, SPAN_WARNING("Доступных форм нет. Сначала изучите больше форм, применив это заклинание к другим объектам."))
		revert_cast(user)
		return

	var/list/forms = list()
	if(selected_form)
		forms += "Original Form"

	forms += available_forms.Copy()
	var/what = tgui_input_list(user, "Какой формой вы хотите стать сегодня?", "Мимикрировать", forms)
	if(!what)
		to_chat(user, SPAN_NOTICE("Вы решаете не менять форму."))
		revert_cast(user)
		return

	if(what == "Original Form")
		restore_form(user)
		return
	to_chat(user, SPAN_SINISTER("Вы начинаете превращаться в [what]."))
	if(!do_after(user, 2 SECONDS, FALSE, user))
		to_chat(user, SPAN_WARNING("Вы потеряли концентрацию."))
		return
	take_form(available_forms[what], user)

/datum/spell/mimic/proc/take_form(datum/mimic_form/form, mob/user)
	var/old_name = "[user]"
	if(ishuman(user))
		// Not fully finished yet
		var/mob/living/carbon/human/H = user
		H.name_override = form.name
	else
		user.appearance = form.appearance
		user.transform = initial(user.transform)
		user.pixel_y = initial(user.pixel_y)
		user.pixel_x = initial(user.pixel_x)
		user.layer = MOB_LAYER // Avoids weirdness when mimicking something below the vent layer
		user.density = form.density

	playsound(user, "bonebreak", 75, TRUE)
	show_change_form_message(user, old_name, "[user]")
	user.create_log(MISC_LOG, "Mimicked into [user]")

	if(!selected_form)
		RegisterSignal(user, COMSIG_PARENT_EXAMINE, PROC_REF(examine_override))
		RegisterSignal(user, COMSIG_MOB_DEATH, PROC_REF(on_death))

	selected_form = form

/datum/spell/mimic/proc/show_change_form_message(mob/user, old_name, new_name)
	user.visible_message(
		SPAN_WARNING("[old_name] искажается и медленно превращается в [new_name]!"),
		SPAN_SINISTER("Вы принимаете форму [new_name]."),
		SPAN_WARNING("Вы слышите громкий треск!")
	)

/datum/spell/mimic/proc/restore_form(mob/user, show_message = TRUE)
	selected_form = null
	var/old_name = "[user]"

	user.cut_overlays()
	user.icon = initial(user.icon)
	user.icon_state = initial(user.icon_state)
	user.density = initial(user.density)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.name_override = null
		H.regenerate_icons()
	else
		user.name = initial(user.name)
		user.desc = initial(user.desc)
		user.color = initial(user.color)

	playsound(user, "bonebreak", 150, TRUE)
	if(show_message)
		show_restore_form_message(user, old_name, "[user]")

	UnregisterSignal(user, list(COMSIG_PARENT_EXAMINE, COMSIG_MOB_DEATH))

/datum/spell/mimic/proc/show_restore_form_message(mob/user, old_name, new_name)
	user.visible_message(
		SPAN_WARNING("[old_name] трясется, искажается и быстро превращается в [new_name]!"),
		SPAN_SINISTER("Вы возвращаетесь к своей обычной форме."),
		SPAN_WARNING("Вы слышите громкий треск!")
	)

/datum/spell/mimic/proc/examine_override(datum/source, mob/user, list/examine_list)
	examine_list.Cut()
	examine_list += selected_form.examine_text
	if(!perfect_disguise && get_dist(user, source) <= 3)
		examine_list += SPAN_WARNING("Это выглядит не совсем правильно...")

/datum/spell/mimic/proc/on_death(mob/user, gibbed)
	if(!gibbed)
		restore_form(user, FALSE)
		show_death_message(user)

/datum/spell/mimic/proc/show_death_message(mob/user)
	user.visible_message(
		SPAN_WARNING("[user.declent_ru(NOMINATIVE)] дрожит и корчится, когда [user.ru_p_they()] умирает, возвращаясь к своей истинной форме!"),
		SPAN_DEADSAY("Ваша маскировка рассеивается по мере того, как ваши жизненные силы иссякают."),
		SPAN_WARNING("Вы слышите громкий треск, за которым следует глухой удар!")
	)


/datum/mimic_form
	/// How does the form look like?
	var/appearance
	/// What is the examine text paired with this form
	var/examine_text
	/// What the name of the form is
	var/name
	/// If the form has density
	var/density

/datum/mimic_form/New(atom/movable/form, mob/user)
	appearance = form.appearance
	examine_text = form.examine(user)
	name = form.name
	density = form.density

/datum/spell/mimic/morph
	action_background_icon_state = "bg_morph"

/datum/spell/mimic/morph/create_new_handler()
	var/datum/spell_handler/morph/H = new
	return H

/datum/spell/mimic/morph/valid_target(atom/target, user)
	if(target != user && ismorph(target))
		return FALSE
	return ..()

/datum/spell/mimic/morph/take_form(datum/mimic_form/form, mob/living/simple_animal/hostile/morph/user)
	..()
	user.assume()

/datum/spell/mimic/morph/restore_form(mob/living/simple_animal/hostile/morph/user, show_message = TRUE)
	..()
	user.restore()

/datum/spell/mimic/morph/show_change_form_message(mob/user, old_name, new_name)
	user.visible_message(
		SPAN_WARNING("[old_name] внезапно изгибается и меняет форму, становясь копией [new_name]!"),
		SPAN_NOTICE("Вы поворачиваете свое тело и принимаете форму [new_name]."),
		SPAN_WARNING("Вы слышите громкий треск!")
	)

/datum/spell/mimic/morph/show_restore_form_message(mob/user, old_name, new_name)
	user.visible_message(
		SPAN_WARNING("[old_name] внезапно распадается, превращаясь в груду зеленой плоти!"),
		SPAN_NOTICE("Вы возвращаетесь в свое обычное тело."),
		SPAN_WARNING("Вы слышите громкий треск, за которым следует глухой удар!")
	)

/datum/spell/mimic/morph/show_death_message(mob/user)
	user.visible_message(
		SPAN_WARNING("[user] скручивается и превращается в груду зеленой плоти!"),
		SPAN_USERDANGER("Ваша кожа лопается! Ваша плоть распадается на части! Никакая маскировка не спасет вас от сме..."),
		SPAN_WARNING("Вы слышите громкий треск, за которым следует глухой удар!")
	)
