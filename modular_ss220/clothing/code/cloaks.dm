/obj/item/clothing/suit/mantle/armor/captain/black
	name = "чёрная капитанская мантия"
	desc = "Носится верховным лидером станции NSS Cyberiad."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "capcloak_black"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "capcloak_black"

/obj/item/clothing/suit/mantle/armor/captain_black/Initialize(mapload)
	. = ..()
	desc = "Носится верховным лидером станции [station_name()]."

/obj/item/clothing/accessory/cloak
	name = "grey cloak"
	desc = "It's a cloak that can be worn around your neck in a pretty dull color."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "cloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "cloak"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = UPPER_TORSO | ARMS

/obj/item/clothing/accessory/cloak/head_of_security
	name = "head of security's cloak"
	desc = "Worn by the leader of Brigston, ruling the station with an iron fist."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "hoscloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "hoscloak"

/obj/item/clothing/accessory/cloak/quartermaster
	name = "quartermaster's cloak"
	desc = "Worn by the God-emperor of Cargonia, supplying the station with the necessary tools for survival."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "qmcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "qmcloak"

/obj/item/clothing/accessory/cloak/chief_medical_officer
	name = "chief medical officer's cloak"
	desc = "Worn by the leader of Medistan, the valiant men and women keeping pestilence at bay."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "cmocloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "cmocloak"

/obj/item/clothing/accessory/cloak/chief_engineer
	name = "chief engineer's white cloak"
	desc = "Worn by the leader of both Atmosia and Delamistan, wielder of unlimited power."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "cecloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "cecloak"

/obj/item/clothing/accessory/cloak/chief_engineer/white
	name = "chief engineer's white cloak"
	desc = "Worn by the leader of both Atmosia and Delamistan, wielder of unlimited power. This one is white."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "cecloak_white"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "cecloak_white"

/obj/item/clothing/accessory/cloak/research_director
	name = "research director's cloak"
	desc = "Worn by the leader of Scientopia, the greatest thaumaturgist and researcher of rapid unexpected self disassembly."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "rdcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "rdcloak"

/obj/item/clothing/accessory/cloak/captain
	name = "captain's cloak"
	desc = "Worn by the supreme leader of the NSS Cyberiad."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "capcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "capcloak"

/obj/item/clothing/accessory/cloak/captain/Initialize(mapload)
	. = ..()
	desc = "Worn by the supreme leader of [station_name()]."

/obj/item/clothing/accessory/cloak/head_of_personnel
	name = "head of personnel's cloak"
	desc = "Worn by the Head of Personnel. It smells faintly of bureaucracy."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "hopcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "hopcloak"

/obj/item/clothing/accessory/cloak/nanotrasen_representative
	name = "nanotrasen representative's cloak"
	desc = "Worn by a Nanotrasen representative. A faint whisper of denunciation can be heard from under the cloak."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "ntrcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "htrcloak"

/obj/item/clothing/accessory/cloak/blueshield
	name = "blueshield's cloak"
	desc = "Worn by a Blueshield officer, that faithfully defends its goals."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "blueshieldcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "blueshieldcloak"

/obj/item/clothing/accessory/cloak/healer
	name = "healer's cloak"
	desc = "Worn by the best and most skilled healers, the handlers of hyposprays, pills, auto-menders and first-aid kits."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "healercloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "healercloak"

/obj/item/clothing/accessory/cloak/bishop
	name = "bishop's cloak"
	desc = "Become the space pope."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "bishopcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "bishopcloak"

/obj/item/clothing/accessory/cloak/bishopblack
	name = "black bishop cloak"
	desc = "Become the space pope."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "blackbishopcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "blackbishopcloak"

/obj/item/clothing/accessory/cloak/syndiecap
	name = "syndicate captain's cloak"
	desc = "A cloak that inspires fear among Nanotrasen employees, worn by the greatest Syndicate captains."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "syndcapt"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "syndcapt"

/obj/item/clothing/accessory/cloak/syndieadm
	name = "syndicate admiral's cloak"
	desc = "A deep red cloak, worn by only the greatest of the Syndicate. If you are looking at this, you probably won't be looking at it for much longer."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "syndadmiral"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "syndadmiral"
