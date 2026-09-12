/atom/movable/screen/buildmode
	icon = 'icons/misc/buildmode.dmi'
	var/datum/click_intercept/buildmode/bd
	plane = HUD_PLANE_BUILDMODE

/atom/movable/screen/buildmode/New(bld)
	bd = bld
	return ..()

/atom/movable/screen/buildmode/Destroy()
	bd = null
	return ..()

/atom/movable/screen/buildmode/mode
	name = "Toggle Mode"
	icon_state = "buildmode_basic"
	screen_loc = "NORTH,WEST"

/atom/movable/screen/buildmode/mode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("left"))
		bd.toggle_modeswitch()
	else if(pa.Find("right"))
		bd.mode.change_settings(usr)
	update_icon()
	return TRUE

/atom/movable/screen/buildmode/mode/update_icon_state()
	icon_state = bd.mode.get_button_overlay_iconstate()

/atom/movable/screen/buildmode/help
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"
	name = "Buildmode Help"

/atom/movable/screen/buildmode/help/Click()
	bd.mode.show_help(usr)
	return TRUE

/atom/movable/screen/buildmode/bdir
	icon_state = "build"
	screen_loc = "NORTH,WEST+2"
	name = "Change Dir"

/atom/movable/screen/buildmode/bdir/update_icon(updates=UPDATE_ICON_STATE)
	dir = bd.build_dir
	..()

/atom/movable/screen/buildmode/bdir/Click()
	bd.toggle_dirswitch()
	update_icon()
	return TRUE

// used to switch between modes
/atom/movable/screen/buildmode/modeswitch
	var/datum/buildmode_mode/modetype

/atom/movable/screen/buildmode/modeswitch/New(bld, mt)
	modetype = mt
	icon_state = "buildmode_[initial(modetype.key)]"
	name = initial(modetype.key)
	return ..(bld)

/atom/movable/screen/buildmode/modeswitch/Click()
	bd.change_mode(modetype)
	return TRUE

// used to switch between dirs
/atom/movable/screen/buildmode/dirswitch
	icon_state = "build"

/atom/movable/screen/buildmode/dirswitch/New(bld, newdir)
	dir = newdir
	name = dir2text(dir)
	return ..(bld)

/atom/movable/screen/buildmode/dirswitch/Click()
	bd.change_dir(dir)
	return TRUE

/atom/movable/screen/buildmode/quit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"
	name = "Quit Buildmode"

/atom/movable/screen/buildmode/quit/Click()
	bd.quit()
	return TRUE

// ============================================================================
// buildmode_hud.dm — ДОПОЛНЕНИЕ (добавить в конец файла)
// ============================================================================
// Четыре новые кнопки, нужные только режиму Save. Не регистрируются в общем
// create_buttons() вместе с остальными четырьмя (Mode/Help/Dir/Quit) — те
// висят всегда, для любого режима. Эти же добавляются/убираются точечно, в
// /datum/buildmode_mode/save/enter_mode() и exit_mode() (см. save.dm) —
// поэтому у любого другого режима (Basic, Advanced, Fill и т.д.) их на
// экране просто не будет.
//
// Иконки-заглушки (icon_state) ниже почти наверняка не существуют в
// buildmode.dmi прямо сейчас — спрайтов под них у меня нет, я не могу
// нарисовать/добавить бинарный .dmi файл. Если новых спрайтов рисовать
// пока не будете — временно укажите тут любой существующий icon_state
// (например "buildhelp") просто чтобы кнопка не была пустым квадратом,
// и замените, когда появятся нормальные иконки.

/atom/movable/screen/buildmode/save_undo
	name = "Undo"
	icon_state = "buildmode_undo" // TODO: спрайта пока нет
	screen_loc = "NORTH,WEST+4"

/atom/movable/screen/buildmode/save_undo/Click()
	var/datum/buildmode_mode/save/S = bd.mode
	if(!istype(S))
		return TRUE
	S.undo_action(usr)
	return TRUE

/atom/movable/screen/buildmode/save_redo
	name = "Redo"
	icon_state = "buildmode_redo" // TODO: спрайта пока нет
	screen_loc = "NORTH,WEST+5"

/atom/movable/screen/buildmode/save_redo/Click()
	var/datum/buildmode_mode/save/S = bd.mode
	if(!istype(S))
		return TRUE
	S.redo_action(usr)
	return TRUE

/atom/movable/screen/buildmode/save_savezone
	name = "Save Zone"
	icon_state = "buildmode_savezone" // TODO: спрайта пока нет
	screen_loc = "NORTH,WEST+6"

/atom/movable/screen/buildmode/save_savezone/Click()
	var/datum/buildmode_mode/save/S = bd.mode
	if(!istype(S))
		return TRUE
	S.save_selection(usr)
	return TRUE

/atom/movable/screen/buildmode/save_modetoggle
	name = "Toggle Point/Area Selection"
	icon_state = "buildmode_areapoint" // TODO: спрайта пока нет
	screen_loc = "NORTH,WEST+7"

/atom/movable/screen/buildmode/save_modetoggle/Click()
	var/datum/buildmode_mode/save/S = bd.mode
	if(!istype(S))
		return TRUE
	S.toggle_selection_mode(usr)
	update_icon()
	return TRUE

/atom/movable/screen/buildmode/save_modetoggle/update_icon_state()
	var/datum/buildmode_mode/save/S = bd.mode
	if(istype(S) && S.selection_mode == SAVE_SELMODE_POINT)
		icon_state = "buildmode_areapoint_point" // TODO: спрайта пока нет
	else
		icon_state = "buildmode_areapoint" // TODO: спрайта пока нет
