//A temporary solution until they change it at upstream
/datum/asset/simple/paper/New()
	assets += list(
		"large_stamp-ward.png"     	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ward.png',
		"large_stamp-ploho.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ploho.png',
		"large_stamp-BIGdeny.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-BIGdeny.png',
		"large_stamp-navcom.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-navcom.png',
		"large_stamp-mime.png"     	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-mime.png',
		"large_stamp-ussp.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ussp.png',
		"large_stamp-nct.png"		= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-nct.png',
		"large_stamp-navytsf.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-navytsf.png',
		"large_stamp-reptsf.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-reptsf.png',
		"large_stamp-usspcom.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-usspcom.png',
		"large_stamp-ussprep.png"	= 'modular_ss220/aesthetics/stamps/icons/paper_icons/large_stamp-ussprep.png',
		"tsflogo.png" = 'modular_ss220/aesthetics/stamps/icons/paper_icons/tsflogo.png',
		"ussplogo.png" = 'modular_ss220/aesthetics/stamps/icons/paper_icons/ussplogo.png'
	)
	..()

// It's just works :skull:
/obj/item/paper/stamp(obj/item/stamp/stamp)
	if(stamp.stampoverlay_custom_icon)
		stamps += (!stamps || stamps == "" ? "<HR>" : "") + "<img src=large_[stamp.icon_state].png>"
		var/image/stampoverlay = image(stamp.stampoverlay_custom_icon)
		var/x = rand(-2, 0)
		var/y = rand(-1, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y
		stampoverlay.icon_state = "paper_[stamp.icon_state]"
		stamp_overlays += stampoverlay

		if(!ico)
			ico = new
		ico += "paper_[stamp.icon_state]"
		if(!stamped)
			stamped = new
		stamped += stamp.type

		update_icon(UPDATE_OVERLAYS)
	else
		. = ..()

// TODO: Paperplane overlays code. Now there's no overlays at all on paperplanes because of /obj/item/paperplane/update_overlays()

/obj/item/stamp
	var/stampoverlay_custom_icon

/obj/item/stamp/warden
	name = "warden's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ward"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/ploho
	name = "'Very Bad, Redo' rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ploho"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/bigdeny
	name = "\improper BIG DENY rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-BIGdeny"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/navcom
	name = "Nanotrasen Naval Command rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-navcom"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/mime
	name = "mime's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-mime"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/ussp
	name = "old USSP rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ussp"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/nct
	name = "Nanotrasen Career Trainer's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-nct"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/navytsf
	name = "Trans Solar Federation Navy Command rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-navytsf"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/reptsf
	name = "Trans Solar Federation Representative's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-reptsf"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/repussp
	name = "USSP Representative's rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-ussprep"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'

/obj/item/stamp/comussp
	name = "USSP Command rubber stamp"
	icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
	icon_state = "stamp-usspcom"
	stampoverlay_custom_icon = 'modular_ss220/aesthetics/stamps/icons/stamps.dmi'
