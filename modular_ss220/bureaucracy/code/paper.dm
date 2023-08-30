/obj/item/paper
	var/paper_width_big = 600
	var/paper_height_big = 700

/obj/item/paper/show_content(mob/user, forceshow = 0, forcestars = 0, infolinks = 0, view = 1)
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/paper)
	assets.send(user)

	var/data
	var/stars = (!user?.say_understands(null, GLOB.all_languages["Galactic Common"]) && !forceshow) || forcestars
	if(stars) //assuming all paper is written in common is better than hardcoded type checks
		data = "[header][stars(info)][footer][stamps]"
	else
		data = "[header]<div id='markdown'>[infolinks ? info_links : info]</div>[footer][stamps]"
	if(view)
		if(!istype(src, /obj/item/paper/form) && length(info) > 1024)
			paper_width = paper_width_big
			paper_height = paper_height_big
		var/datum/browser/popup = new(user, "Paper[UID()]", , paper_width, paper_height)
		popup.stylesheets = list()
		popup.set_content(data)
		if(!stars)
			popup.add_script("marked.js", 'html/browser/marked.js')
			popup.add_script("marked-paradise.js", 'html/browser/marked-paradise.js')
		popup.add_head_content("<title>[name]</title>")
		popup.open()
	return data
