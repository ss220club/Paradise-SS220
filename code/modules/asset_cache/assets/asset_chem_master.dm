/// Pill sprites for UIs
/datum/asset/spritesheet/chem_master
	name = "chem_master"

/datum/asset/spritesheet/chem_master/create_spritesheets()
	for(var/pill_type in 1 to 20)
		Insert("pill[pill_type]", 'icons/obj/chemical.dmi', "pill[pill_type]")
	for(var/bandaid_type in 1 to 21)
		Insert("bandaid[bandaid_type]", 'icons/obj/chemical.dmi', "bandaid[bandaid_type]")
	for(var/bottle_type in list("bottle", "reagent_bottle"))
		Insert(bottle_type, 'icons/obj/chemical.dmi', bottle_type)
	// SS220 EDIT START - Adding Medipens In Chemaster
	for(var/medipen_type in list("medipen", "medipen_red", "medipen_org", "medipen_blu", "medipen_grn"))
		Insert(medipen_type, 'modular_ss220/aesthetics/medipens/icon/medipens.dmi', medipen_type)
	// SS220 EDIT END

/datum/asset/spritesheet/chem_master/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(64, 64)
	pre_asset.Crop(16,16,48,48)
	pre_asset.Scale(32, 32)
	return pre_asset
