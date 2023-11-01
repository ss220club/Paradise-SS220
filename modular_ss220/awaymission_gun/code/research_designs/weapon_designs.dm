/datum/design/gate_gun_mk1
	name = "Gate Energy Gun MK1"
	desc = "An energy gun with an experimental miniaturized reactor. Only works in the gate" //не отображаемое описание, т.к. печатается без кейса
	id = "gate_energy_gun"
	req_tech = list("combat" = 3, "magnets" = 3, "powerstorage" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 6000, MAT_GLASS = 1500, MAT_URANIUM = 1500, MAT_TITANIUM = 500)
	build_path = /obj/item/gun/energy/laser/awaymission_aeg/rnd
	locked = 0
	category = list("Weapons")
