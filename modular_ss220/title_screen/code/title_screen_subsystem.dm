#define TITLE_SCREENS_LOCATION "config/title_screens/images/"

/datum/controller/subsystem/title
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE
	/// The current title screen being displayed, as a file path text.
	var/current_title_screen
	/// The current notice text, or null.
	var/current_notice
	/// The preamble html that includes all styling and layout.
	var/title_html
	/// The list of possible title screens to rotate through, as: title_screen_name -> title_screen_path
	var/list/title_screens = list()

/datum/controller/subsystem/title/Initialize()
	if(!fexists("config/title_html.txt"))
		error(span_boldwarning("Unable to read title_html.txt, reverting to backup title html, please check your server config and ensure this file exists."))
		title_html = DEFAULT_TITLE_HTML
	else
		title_html = file2text("config/title_html.txt")

	load_title_screens()
	change_title_screen()

/datum/controller/subsystem/title/Recover()
	current_title_screen = SStitle.current_title_screen
	current_notice = SStitle.current_notice
	title_html = SStitle.title_html
	title_screens = SStitle.title_screens

/**
 * Iterates over all files in `TITLE_SCREENS_LOCATION` and loads all valid title screens to `title_screens` var.
 */
/datum/controller/subsystem/title/proc/load_title_screens()
	var/list/valid_title_screens = list()
	for(var/screen in flist(TITLE_SCREENS_LOCATION))
		if(validate_title_screen(screen))
			valid_title_screens += screen

	for(var/title_screen_name in valid_title_screens)
		var/file_path = "[TITLE_SCREENS_LOCATION][title_screen_name]"
		ASSERT(fexists(file_path))
		title_screens[title_screen_name] = fcopy_rsc(file_path)

/**
 * Checks wheter passed title is valid
 * Currently validates extension and checks whether it's special image like default title screen etc.
 */
/datum/controller/subsystem/title/proc/validate_title_screen(title_screen_to_validate)
	var/static/list/title_screens_to_ignore = list("blank.png", DEFAULT_TITLE_SCREEN_IMAGE)
	if(title_screen_to_validate in title_screens_to_ignore)
		return FALSE

	var/list/name_parts = splittext(title_screen_to_validate, ".")
	if(length(name_parts) < 2)
		return FALSE

	var/static/list/supported_extensions = list("gif", "jpg", "jpeg","png", "svg")
	var/extension = name_parts[length(name_parts)]
	return (extension in supported_extensions)

/**
 * Returns the list of all loaded title screens, if no title screens present, tries to load them.
 */
/datum/controller/subsystem/title/proc/get_title_screens()
	if(!length(title_screens))
		load_title_screens()

	return title_screens.Copy()

/**
 * Returns current title screen or if null, default one.
 */
/datum/controller/subsystem/title/proc/get_current_title_screen()
	return current_title_screen || DEFAULT_TITLE_SCREEN_IMAGE

/**
 * Show the title screen to all new players.
 */
/datum/controller/subsystem/title/proc/show_title_screen()
	for(var/mob/new_player/new_player in GLOB.player_list)
		INVOKE_ASYNC(new_player, TYPE_PROC_REF(/mob/new_player, show_title_screen))

/**
 * Adds a notice to the main title screen in the form of big red text!
 */
/datum/controller/subsystem/title/proc/set_notice(new_title)
	current_notice = new_title ? sanitize_text(new_title) : null
	show_title_screen()

/**
 * Changes the title screen to a new image.
 */
/datum/controller/subsystem/title/proc/change_title_screen(new_screen)
	if(new_screen)
		current_title_screen = new_screen
	else
		if(length(title_screens))
			current_title_screen = pick(title_screens)
		else
			current_title_screen = DEFAULT_TITLE_SCREEN_IMAGE

	show_title_screen()

#undef TITLE_SCREENS_LOCATION
