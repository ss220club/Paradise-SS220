/datum/title_screen
	/// The preamble html that includes all styling and layout.
	var/title_html = DEFAULT_TITLE_HTML
	/// The current notice text, or null.
	var/notice
	/// The current title screen being displayed, as `/datum/asset_cache_item`
	var/datum/asset_cache_item/screen_image

/datum/title_screen/New(title_html = DEFAULT_TITLE_HTML, notice, screen_image_file)
	src.title_html = title_html
	src.notice = notice
	set_screen_image(screen_image_file)

/datum/title_screen/proc/set_screen_image(screen_image_file)
	if(!screen_image_file)
		return

	if(!isfile(screen_image_file))
		screen_image_file = fcopy_rsc(screen_image_file)

	screen_image = SSassets.transport.register_asset("[screen_image_file]", screen_image_file)

/datum/title_screen/proc/show_to(client/viewer)
	if(!viewer)
		return

	winset(viewer, "title_browser", "is-disabled=false;is-visible=true")
	winset(viewer, "paramapwindow.status_bar", "is-visible=false")

	var/datum/asset/lobby_asset = get_asset_datum(/datum/asset/simple/lobby)
	lobby_asset.send(viewer)

	SSassets.transport.send_assets(viewer, screen_image.name)

	viewer << browse(get_title_html(viewer, viewer.mob), "window=title_browser")

/datum/title_screen/proc/hide_from(client/viewer)
	if(viewer?.mob)
		winset(viewer, "title_browser", "is-disabled=true;is-visible=false")
		winset(viewer, "paramapwindow.status_bar", "is-visible=true")

/**
 * Get the HTML of title screen.
 */
/datum/title_screen/proc/get_title_html(client/viewer, mob/user)
	var/list/html = list(title_html)
	var/mob/new_player/player = user

	var/screen_image_url = SSassets.transport.get_asset_url(asset_cache_item = screen_image)
	if(screen_image_url)
		html += {"<img src="[screen_image_url]" class="bg" alt="">"}

	if(notice)
		html += {"
		<div class="container_notice">
			<p class="menu_notice">[notice]</p>
		</div>
	"}

	html += {"<div class="container_menu">"}
	html += {"
		<div class="container_logo">
		<img class="logo" src="[SSassets.transport.get_asset_url(asset_name = "SS220_Logo.png")]">
		<span id="character_slot">На смену прибывает...</span>
		<span id="character_slot">[viewer.prefs.active_character.real_name]</span>
		</div>
	"}
	html += {"<div class="container_buttons">"}
	if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
		html += {"<a id="ready" class="menu_button" href='byond://?src=[player.UID()];ready=1'>[player.ready ? "Готов" : "Не готов"]</a>"}
	else
		html += {"
			<a class="menu_button" href='byond://?src=[player.UID()];late_join=1'>Присоединиться</a>
			<a class="menu_button" href='byond://?src=[player.UID()];manifest=1'>Список экипажа</a>
		"}

	html += {"<a class="menu_button" href='byond://?src=[player.UID()];observe=1'>Наблюдать</a>"}
	html += {"
		<hr>
		<a class="menu_button" id="be_antag" href='byond://?src=[player.UID()];skip_antag=1'>[viewer.skip_antag ? "Включить антагонистов" : "Выключить антагонистов"]</a>
		<a class="menu_button" href='byond://?src=[player.UID()];show_preferences=1'>Настройка персонажа</a>
		<a class="menu_button" href='byond://?src=[player.UID()];game_preferences=1'>Настройки игры</a>
		<hr>
		<a class="menu_button" href='byond://?src=[player.UID()];server_swap=1'>Сменить сервер</a>
	"}
	html += {"</div>"}
	html += {"
		<div class="container_links">
		<a class="link_button" href='byond://?src=[player.UID()];wiki=1'><i class="fab fa-wikipedia-w"></i></a>
		<a class="link_button" href='byond://?src=[player.UID()];discord=1'><i class="fab fa-discord"></i></a>
		<a class="link_button" href='byond://?src=[player.UID()];changelog=1'><i class="fas fa-newspaper"></i></a>
		</div>
	"}

	html += "</div>"
	html += {"
		<script language="JavaScript">
			var ready_int = 0;
			var ready_mark = document.getElementById("ready");
			var ready_marks = \[ "Не готов", "Готов" \];
			function ready(setReady) {
				if(setReady) {
					ready_int = setReady;
					ready_mark.innerHTML = ready_marks\[ready_int\];
				}
				else {
					ready_int++;
					if (ready_int === ready_marks.length)
						ready_int = 0;
					ready_mark.innerHTML = ready_marks\[ready_int\];
				}
			}
			var antag_int = 0;
			var antag_mark = document.getElementById("be_antag");
			var antag_marks = \[ "Включить антагонистов", "Выключить антагонистов" \];
			function skip_antag(setAntag) {
				if(setAntag) {
					antag_int = setAntag;
					antag_mark.innerHTML = antag_marks\[antag_int\];
				}
				else {
					antag_int++;
					if (antag_int === antag_marks.length)
						antag_int = 0;
					antag_mark.innerHTML = antag_marks\[antag_int\];
				}
			}

			var character_name_slot = document.getElementById("character_slot");
			function update_current_character(name) {
				character_name_slot.textContent = name.toUpperCase();
			}
		</script>
		"}

	html += "</body></html>"

	return html.Join()
