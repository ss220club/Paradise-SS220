var/global/const/VOX_RAID_FREQ = 1245

var/global/list/radiochannels |= list(
	"Vox Raider"	= V_RAID_FREQ,
)

/obj/item/radio/headset/vox
	name = "vox headset"
	desc = "Наушник дальней связи для поддержания связи со стаей."
	origin_tech = "syndicate=3"
	ks1type = /obj/item/encryptionkey/vox
	requires_tcomms = FALSE
	instant = TRUE // Work instantly if there are no comms
	freqlock = TRUE

/obj/item/radio/headset/vox/alt
	name = "vox protect headset"
	desc = "Наушник дальней связи для поддержания связи со стаей. Защищает ушные раковины от громких звуков"
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	origin_tech = "syndicate=3"
	flags = EARBANGPROTECT
