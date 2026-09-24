#define CHAT_BADGES_DMI 'modular_ss220/chat_badges/icons/chatbadges.dmi'

#define span_tooltip_img(tip, main_text) ("<span class=\"tooltip-img\" data-tooltip=\"" + tip + "\">" + main_text + "</span>")


GLOBAL_LIST(badge_icons_cache)

GLOBAL_LIST_INIT(donor_chat_effects, list(
	"None" = null,
	"Metal" = "metal",
	"Glowing" = "glowing",
))

/client/proc/get_ooc_badged_name()
	var/list/badge_parts = list()

	for(var/badge in get_donator_badge())
		var/icon/donator_badge_icon = get_badge_icon(badge)
		if(donator_badge_icon)
			var/tooltip = badge

			if(findtext(badge, "Tier-"))
				tooltip = "Уровень подписки: [donator_level]"

			badge_parts += span_tooltip_img(tooltip, bicon(donator_badge_icon))
	var/worker_badge = get_worker_badge()
	var/icon/worker_badge_icon = get_badge_icon(worker_badge)
	if(worker_badge_icon)
		badge_parts += span_tooltip_img(worker_badge, bicon(worker_badge_icon))

	var/badge_part = jointext(badge_parts, "&nbsp;")

	var/list/parts = list()
	if(badge_part)
		parts += badge_part

	if(donator_level >= 3 && (prefs.toggles & PREFTOGGLE_DONATOR_PUBLIC))
		var/selected_pref = GLOB.donor_chat_effects[prefs.donor_chat_effect]
		var/donor_color = prefs.ooccolor
		var/donor_shine = selected_pref ? "class='tier-[donator_level] [selected_pref]'" : ""

		parts += "<span [donor_shine] style='[donor_shine ? "--shine-color: [donor_color];" : "color: [donor_color];"]></span>"

	parts += key

	return jointext(parts, "<div style='display: inline-block; width: 3px;'></div>")

/client/proc/get_donator_badge()
	var/list/parts = list()
	if(donator_level && (prefs.toggles & PREFTOGGLE_DONATOR_PUBLIC))
		var/badged_type = "Tier-[donator_level]"
		if(badged_type)
			parts += badged_type

	if(prefs.unlock_content && (prefs.toggles & PREFTOGGLE_MEMBER_PUBLIC))
		parts += "Trusted"

	return parts

/client/proc/get_worker_badge()
	var/static/list/rank_badge_map = list(
		"Максон" = "Wycc",
		"Банда" = "Streamer",
		"Братюня" = "Streamer",
		"Сестрюня" = "Streamer",
		"Хост" = "Host",
		"Ведущий Разработчик" = "HeadDeveloper",
		"Мейнтейнер" = "Developer",
		"Разработчик" = "MiniDeveloper",
		"Маппер" = "Mapper",
		"Спрайтер" = "Spriceter",
		"Маленький Работяга" = "WikiLore",
		"Старший Администратор" = "HeadAdmin",
		"Зам Старшего Администратора" = "HeadAdmin",
		"Администратор" = "GameAdmin",
		"Младший Администратор" = "TrialAdmin",
		"Ментор" = "Mentor"
	)
	return rank_badge_map[holder?.rank]

/client/proc/get_badge_icon(badge)
	if(isnull(badge))
		return null

	var/icon/badge_icon = LAZYACCESS(GLOB.badge_icons_cache, badge)
	if(isnull(badge_icon))
		badge_icon = icon(CHAT_BADGES_DMI, badge)
		LAZYSET(GLOB.badge_icons_cache, badge, badge_icon)

	return badge_icon

#undef CHAT_BADGES_DMI
