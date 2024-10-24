/// Almost straight copy-paste of show_location_blurb. Shows "welcome message" for NT special members.
/mob/living/carbon/human/proc/show_custom_blurb(client/show_blurb_to, datum/mind/antag_check)
	PRIVATE_PROC(TRUE)

	if(!show_blurb_to?.mob)
		return

	var/multiline_blurb = ""
	var/atom/movable/screen/text/blurb/custom_blurb = new()

	switch(show_blurb_to.mob.mind.special_role)
		if(SPECIAL_ROLE_DEATHSQUAD)
			SEND_SOUND(show_blurb_to, sound('sound/machines/typewriter.ogg')) // Needs custom sound
			multiline_blurb += "Инициировано пробуждение.\n"
			multiline_blurb += "Клон: [show_blurb_to.mob.real_name].\n"
			multiline_blurb += "Состояние: В полной боевой готовности.\n"
			multiline_blurb += "Локация: АКН «Трурль». Отдел экстренного реагирования подразделения «ОМИКРОН 19».\n"
			multiline_blurb += "Инициализация протоколов...\n"
			multiline_blurb += "Цель миссии: Обеспечить выполнение приказов центрального командования.\n"
			multiline_blurb += "Приоритет: Максимальная эффективность и оперативность.\n"
			multiline_blurb += "Ожидается дальнейшее руководство и инструкции.\n"
		if(SPECIAL_ROLE_ERT)
			SEND_SOUND(show_blurb_to, sound('sound/machines/typewriter.ogg')) // Needs custom sound
			multiline_blurb += "Инициировано пробуждение.\n"
			multiline_blurb += "Член отряда: [show_blurb_to.mob.real_name].\n"
			multiline_blurb += "Локация: АКН «Трурль». Отдел экстренного реагирования.\n"
			multiline_blurb += "Ожидается дальнейшее руководство и инструкции.\n"
		if(SPECIAL_ROLE_NUKEOPS)
			custom_blurb.text_color = COLOR_BLACK
			custom_blurb.background_r = 255
			custom_blurb.background_g = 0
			custom_blurb.background_b = 0
			multiline_blurb += "Оперативник, [show_blurb_to.mob.real_name].\n"
			multiline_blurb += "Задача: Доставить и активировать боеголовку.\n"
			multiline_blurb += "Приоритет: Выполнить задачу любой ценой, минимизируя потери.\n"
			multiline_blurb += "BEGIN_MISSION.\n"


	// Colors of NT logo
	custom_blurb.text_color = COLOR_WHITE
	custom_blurb.text_outline_width = 1
	custom_blurb.chars_per_interval = 1
	custom_blurb.background_r = 10
	custom_blurb.background_g = 35
	custom_blurb.background_b = 55
	custom_blurb.background_a = 255
	custom_blurb.font_family = "Courier New"

	// Base & Animations
	custom_blurb.blurb_text = uppertext(multiline_blurb)
	custom_blurb.hold_for = 3 SECONDS
	custom_blurb.appear_animation_duration = 1 SECONDS
	custom_blurb.fade_animation_duration = 0.5 SECONDS

	custom_blurb.show_to(show_blurb_to)

/client/create_deathsquad_commando(obj/spawn_location, is_leader = FALSE)
	. = ..()
	var/mob/living/carbon/human/new_commando = .
	var/commando_leader_rank = "Ординал"
	var/commando_name = pick(GLOB.deathsquad_names)

	if(is_leader)
		new_commando.real_name = "[commando_leader_rank] [commando_name] - [rand(1, 99)]"
	else
		new_commando.real_name = "[commando_name] - [rand(100, 999)]"
