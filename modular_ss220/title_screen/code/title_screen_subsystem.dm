#define TITLE_SCREENS_LOCATION "config/title_screens/images/"

/datum/controller/subsystem/title
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE
	/// Currently set title screen
	var/datum/title_screen/current_title_screen
	/// The list of possible title screens to rotate through, as: title_screen_name -> title_screen_path
	var/list/title_screens = list()

/datum/controller/subsystem/title/Initialize()
	setup_title_screen()

/datum/controller/subsystem/title/Recover()
	current_title_screen = SStitle.current_title_screen
	title_screens = SStitle.title_screens

/**
 * Iterates over all files in `TITLE_SCREENS_LOCATION` and loads all valid title screens to `title_screens` var.
 */
/datum/controller/subsystem/title/proc/load_title_screens()
	var/list/valid_title_screens = list()
	for(var/screen in flist(TITLE_SCREENS_LOCATION))
		if(validate_title_screen_name(screen))
			valid_title_screens += screen

	for(var/title_screen_name in valid_title_screens)
		var/file_path = "[TITLE_SCREENS_LOCATION][title_screen_name]"
		if(fexists(file_path))
			title_screens[title_screen_name] = fcopy_rsc(file_path)

/**
 * Checks wheter passed title is valid
 * Currently validates extension and checks whether it's special image like default title screen etc.
 */
/datum/controller/subsystem/title/proc/validate_title_screen_name(title_screen_to_validate)
	var/static/list/title_screens_to_ignore = list("blank.png", DEFAULT_TITLE_SCREEN_IMAGE_NAME)
	if(title_screen_to_validate in title_screens_to_ignore)
		return FALSE

	var/static/list/supported_extensions = list("gif", "jpg", "jpeg","png", "svg")
	var/extension = findlasttext_char(title_screen_to_validate, ".")
	return (extension in supported_extensions)

/**
 * Show the title screen to all new players.
 */
/datum/controller/subsystem/title/proc/show_title_screen(list/viewers)
	for(var/mob/new_player/viewer in viewers)
		INVOKE_ASYNC(current_title_screen, TYPE_PROC_REF(/datum/title_screen, show_to), viewer)

/**
 * Adds a notice to the main title screen in the form of big red text!
 */
/datum/controller/subsystem/title/proc/set_notice(new_title)
	current_title_screen.notice = new_title ? sanitize_text(new_title) : null
	show_title_screen()

/**
 * Changes the title screen to a new image.
 */
/datum/controller/subsystem/title/proc/change_title_screen()
	var/screen_image_file_name
	var/screen_image_file
	if(length(title_screens))
		screen_image_file_name = pick(title_screens)
		screen_image_file = title_screens[screen_image_file_name]
	else
		screen_image_file_name = DEFAULT_TITLE_SCREEN_IMAGE_NAME
		screen_image_file = DEFAULT_TITLE_SCREEN_IMAGE_PATH

	if(current_title_screen)
		current_title_screen.set_screen_image(screen_image_file_name, screen_image_file)
	else
		current_title_screen = new(screen_image_file_name = screen_image_file_name, screen_image_file = screen_image_file)

	show_title_screen()

/datum/controller/subsystem/title/proc/setup_title_screen()
	load_title_screens()
	change_title_screen()
	if(!fexists("config/title_html.txt"))
		error(span_boldwarning("Unable to read title_html.txt, reverting to backup title html, please check your server config and ensure this file exists."))
		current_title_screen.title_html = DEFAULT_TITLE_HTML
	else
		current_title_screen.title_html = file2text("config/title_html.txt")

#undef TITLE_SCREENS_LOCATION
