
/datum/vox_pack/melee
	name = "DEBUG Melee Vox Pack"
	category = VOX_PACK_EQUIPMENT


// ============== Щиты ==============

/datum/vox_pack/melee/shield
	name = "Энергощит"
	desc = "Энергетический компактный ручной щит, пособный отражать энергетические снаряды, но не может блокировать прямые воздействия."
	reference = "ME_SH"
	cost = 2000
	contains = list(/obj/item/shield/energy)


// ============== Мечи ==============

/datum/vox_pack/melee/sword
	name = "Энергосабля (Фиолетовая)"
	desc = "Энергетическая сабля для прижигания ран отрубленных конечностей неприятеля. Цвет решительности, цвет Рейдеров. Классика Воксов."
	reference = "ME_SWP"
	cost = 2000
	contains = list(/obj/item/melee/energy/sword/saber/purple)

/datum/vox_pack/melee/sword
	name = "Энергосабля (Синяя)"
	desc = "Энергетическая сабля для прижигания ран отрубленных конечностей неприятеля. Цвет силы и стойкости. Его носят бастионы мира Воксов."
	reference = "ME_SWB"
	cost = 2500
	contains = list(/obj/item/melee/energy/sword/saber/blue)

/datum/vox_pack/melee/sword
	name = "Энергосабля (Зеленая)"
	desc = "Энергетическая сабля для прижигания ран отрубленных конечностей неприятеля. Цвет миротворцев, тех, кто не любит насилие и причиняет его с большой неохотой. С этим мечом причиняют добро и наносят радость."
	reference = "ME_SWG"
	cost = 2500
	contains = list(/obj/item/melee/energy/sword/saber/green)

/datum/vox_pack/melee/sword
	name = "Энергосабля (Красная)"
	desc = "Энергетическая сабля для прижигания ран отрубленных конечностей неприятеля. Цвет ненависти, гнева и злого злодейства злыхх злыдней. Безвкусица."
	reference = "ME_SWR"
	cost = 3000
	contains = list(/obj/item/melee/energy/sword/saber/red)


// ============== Раскладываемое ==============

/datum/vox_pack/melee/dropwall
	name = "Энергосабля (Красная)"
	desc = "Щитовой развертываемый генератор развертывающий временное укрытие, которое блокирует снаряды и взрывы с определенного направления, в то же время позволяя остальным снарядам свободно проходить сзади."
	reference = "ME_DW"
	cost = 500
	contains = list(/obj/item/grenade/barrier/dropwall)


