/datum/asset/group/lobby
	children = list(
		/datum/asset/simple/lobby_fonts,
		/datum/asset/simple/lobby_title_screen_images
	)

/datum/asset/simple/lobby_fonts
	assets = list(
		"FixedsysExcelsior3.01Regular.ttf" = 'modular_ss220/title_screen/html/browser/FixedsysExcelsior3.01Regular.ttf',
	)

/datum/asset/simple/lobby_title_screen_images
	assets = list(
		DEFAULT_TITLE_SCREEN_IMAGE = 'modular_ss220/title_screen/icons/default.gif'
	)

/datum/asset/simple/lobby_title_screen_images/register()
	assets += SStitle.get_title_screens()
	return ..()
