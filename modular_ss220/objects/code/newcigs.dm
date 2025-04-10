// Советские сиги
/obj/item/storage/fancy/cigarettes/cigpack_soviet
	name = "\improper Despojnsko Belovodje packet"
	desc = "Imported directly from Despoina, soviet aquatic colony. Still smells like sea salt."
	icon = 'modular_ss220/objects/icons/newcigs.dmi'
	icon_state = "sovietpacket"
	item_state = "sovietpacket"
	lefthand_file = 'modular_ss220/objects/icons/inhands/newcigs_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/newcigs_righthand.dmi'
	cigarette_type = /obj/item/clothing/mask/cigarette/rollie/sovietunfiltered

/obj/item/clothing/mask/cigarette/rollie/sovietunfiltered
	name = "unfiltered cigarette"
	desc = "Because filters are for pussies!"
	list_reagents = list("nicotine" = 40, "ash" = 20, )
	icon = 'modular_ss220/objects/icons/newcigs.dmi'
	icon_on = "unfilteredcigon"
	icon_off = "unfilteredcigoff"
	icon_state = "unfilteredcigoff"
	item_state = "unfilteredcigoff"
	icon_override = 'modular_ss220/objects/icons/inhead/newcigs_head.dmi'
	lefthand_file = 'modular_ss220/objects/icons/inhands/newcigs_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/newcigs_righthand.dmi'
	sprite_sheets = list(
		"Vox" = 'modular_ss220/objects/icons/inhead/species/vox/mask.dmi',
		"Unathi" = 'modular_ss220/objects/icons/inhead/species/unathi/mask.dmi',
		"Tajaran" = 'modular_ss220/objects/icons/inhead/species/tajaran/mask.dmi',
		"Vulpkanin" = 'modular_ss220/objects/icons/inhead/species/vulpkanin/mask.dmi',
		"Grey" = 'modular_ss220/objects/icons/inhead/species/grey/mask.dmi')

/obj/machinery/economy/vending/cigarette/Initialize(mapload)
	products += list(/obj/item/storage/fancy/cigarettes/cigpack_soviet = 6)
	prices += list(/obj/item/storage/fancy/cigarettes/cigpack_soviet = 35)
	return ..()
