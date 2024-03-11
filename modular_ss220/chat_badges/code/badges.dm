#define CHAT_BADGES_DMI 'modular_ss220/chat_badges/icons/chatbadges.dmi'

GLOBAL_LIST(badge_icons_cache)

/client/proc/get_ooc_badged_name()
	var/donator_badge = get_donator_badge()
	var/worker_badge = get_worker_badge()
	var/icon/donator_badge_icon = donator_badge ? get_badge_icon_cached(donator_badge) : null
	var/icon/worker_badge_icon = worker_badge ? get_badge_icon_cached(worker_badge) : null

	return "[donator_badge_icon ? bicon(donator_badge_icon) : ""][worker_badge_icon ? bicon(worker_badge_icon) : ""][key]"

/client/proc/get_donator_badge()
	if(donator_level && (prefs.toggles & PREFTOGGLE_DONATOR_PUBLIC))
		return donator_level > 3 ? "Trusted" : "Paradise"

	if(prefs.unlock_content && (prefs.toggles & PREFTOGGLE_MEMBER_PUBLIC))
		return "Trusted"

/client/proc/get_worker_badge()
	var/list/rank_badge_map = list(
		"Максон" = "Wycc",
		"Банда" = "Streamer",
		"Братюня" = "Streamer",
		"Сестрюня" = "Streamer",
		"Хост" = "Host",
		"Ведущий Разработчик" = "HeadDeveloper",
		"Старший Разработчик" = "Developer",
		"Разработчик" = "Developer",
		"Начальный Разработчик" = "MiniDeveloper",
		"Бригадир Мапперов" = "HeadMapper",
		"Маппер" = "Mapper",
		"Спрайтер" = "Spriceter",
		"Маленький Работяга" = "WikiLore",
		"Старший Администратор" = "HeadAdmin",
		"Администратор" = "GameAdmin",
		"Триал Администратор" = "TrialAdmin",
		"Ментор" = "Mentor"
	)
	return rank_badge_map[holder?.rank]

/proc/get_badge_icon_cached(badge)
	LAZYSET(GLOB.badge_icons_cache, badge, icon(CHAT_BADGES_DMI, badge))
	return GLOB.badge_icons_cache[badge]

#undef CHAT_BADGES_DMI
