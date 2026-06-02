/// Pill sprites for UIs
/datum/asset/spritesheet/chem_master
	name = "chem_master"
	// SS220 EDIT START - We set what color of medipens will be available for crafting with the possibility of expansion
	var/static/list/medipen_colors = list(
		"red" = COLOR_RED,
		"orange" = COLOR_ORANGE,
		"blue" = COLOR_BLUE,
		"green" = COLOR_GREEN,
		"purple" = COLOR_PURPLE,
		"black" = COLOR_BLACK,
	)
	// SS220 EDIT END

/datum/asset/spritesheet/chem_master/create_spritesheets()
	for(var/pill_type in 1 to 20)
		Insert("pill[pill_type]", 'icons/obj/chemical.dmi', "pill[pill_type]")
	for(var/bandaid_type in 1 to 21)
		Insert("bandaid[bandaid_type]", 'icons/obj/chemical.dmi', "bandaid[bandaid_type]")
	for(var/bottle_type in list("bottle", "reagent_bottle"))
		Insert(bottle_type, 'icons/obj/chemical.dmi', bottle_type)
	// SS220 EDIT START Adding medipen sprites to the chem master for use in the autoinjector production mode
	for(var/color_name in medipen_colors)
		var/color = medipen_colors[color_name]
		var/icon/medipen_icon = icon('modular_ss220/objects/icons/medipens.dmi', "base")
		var/icon/wrapper_icon = icon('modular_ss220/objects/icons/medipens.dmi', "color_tag_wrapper")

		wrapper_icon.Blend(color, ICON_MULTIPLY)
		medipen_icon.Blend(wrapper_icon, ICON_OVERLAY)

		Insert("medipen_[color_name]", medipen_icon)
	// SS220 EDIT END

/datum/asset/spritesheet/chem_master/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(64, 64)
	pre_asset.Crop(16,16,48,48)
	pre_asset.Scale(32, 32)
	return pre_asset
