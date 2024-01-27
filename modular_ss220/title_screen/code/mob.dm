/**
 * Shows the titlescreen to a new player.
 */
/mob/proc/show_title_screen()
	if(!client)
		return
	winset(src, "title_browser", "is-disabled=true;is-visible=true")
	winset(src, "status_bar", "is-visible=false")

	var/datum/asset/lobby_asset = get_asset_datum(/datum/asset/group/lobby)
	lobby_asset.send(src)

	src << browse(get_title_html(), "window=title_browser")

/**
 * Get the HTML of title screen.
 */
/mob/proc/get_title_html()
	var/dat = SStitle.title_html
	dat += {"<img src="[SSassets.transport.get_asset_url(SStitle.get_current_title_screen())]" class="bg" alt="">"}

	if(SStitle.current_notice)
		dat += {"
		<div class="container_notice">
			<p class="menu_notice">[SStitle.current_notice]</p>
		</div>
	"}

	dat += "</body></html>"

	return dat

/**
 * Removes the titlescreen entirely from a mob.
 */
/mob/proc/hide_title_screen()
	if(client?.mob)
		winset(client, "title_browser", "is-disabled=true;is-visible=false")
		winset(client, "status_bar", "is-visible=true")
