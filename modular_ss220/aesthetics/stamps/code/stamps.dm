// It's just works :skull:
/obj/item/paper/stamp(obj/item/stamp/S)
	if(istype(S, /obj/item/stamp/custom))
		stamps += (!stamps || stamps == "" ? "<HR>" : "") + "<img src=large_[S.icon_state].png>"
		var/image/stampoverlay_custom = image('modular_ss220/aesthetics/stamps/icons/stamps.dmi')
		var/x = rand(-2, 0)
		var/y = rand(-1, 2)
		offset_x += x
		offset_y += y
		stampoverlay_custom.pixel_x = x
		stampoverlay_custom.pixel_y = y
		stampoverlay_custom.icon_state = "paper_[S.icon_state]"
		stamp_overlays += stampoverlay_custom

		if(!ico)
			ico = new
		ico += "paper_[S.icon_state]"
		if(!stamped)
			stamped = new
		stamped += S.type

		update_icon(UPDATE_OVERLAYS)
	else
		. = ..()

// TODO: Paperplane overlays code. Now there's no overlays at all on paperplanes because of /obj/item/paperplane/update_overlays()

// I've made subclass for custom stamps, just for istype would work without more shiitier code that i already gave us
/obj/item/stamp/custom
	name = "DO NOT USE"
	icon_state = ""

/obj/item/stamp/custom/warden
	name = "warden's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ward"
	item_color = "hosred"

/obj/item/stamp/custom/ploho
	name = "'Very Bad, Redo' rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ploho"
	item_color = "hop"

/obj/item/stamp/custom/bigdeny
	name = "\improper BIG DENY rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-BIGdeny"
	item_color = "redcoat"

/obj/item/stamp/custom/navcom
	name = "Nanotrasen Naval Command rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-navcom"
	item_color = "captain"

/obj/item/stamp/custom/mime
	name = "mime's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-mime"
	item_color = "mime"

/obj/item/stamp/custom/ussp
	name = "old USSP rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ussp"
	item_color = "redcoat"

// Adding new stamps to the list
/datum/asset/simple/paper/New()
	assets += list(
		"large_stamp-ward.png"     	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ward.png',
		"large_stamp-ploho.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ploho.png',
		"large_stamp-BIGdeny.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-BIGdeny.png',
		"large_stamp-navcom.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-navcom.png',
		"large_stamp-mime.png"     	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-mime.png',
		"large_stamp-ussp.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ussp.png'
	)
