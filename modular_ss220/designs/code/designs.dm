/datum/design/holosign_atmos
	name = "ATMOS holofan projector"
	desc = "A holographic projector that creates holographic barriers that prevent changes in atmosphere conditions."
	id = "atmos_holofan"
	req_tech = list("programming" = 3, "bluespace" = 5, "engineering" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2000, MAT_GLASS = 3000, MAT_PLASMA = 3000, MAT_DIAMOND = 100)
	build_path = /obj/item/holosign_creator/atmos
	construction_time = 10 SECONDS
	category = list("Equipment")

/datum/design/electrolyzer
	name = "Machine Board (Gas electrolyzer)"
	desc = "The circuit board for a Gas electrolyzer."
	id = "electrolyzer"
	req_tech = list("programming" = 4, "engineering" = 6, "toxins" = 5)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 150)
	build_path = /obj/item/circuitboard/electrolyzer
	category = list("Engineering Machinery")
