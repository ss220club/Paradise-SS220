
/datum/vox_pack/melee
	name = "DEBUG Melee Vox Pack"
	category = VOX_PACK_MELEE


// ============== Щиты ==============

/datum/vox_pack/melee/shield
	name = "Энергощит"
	desc = "Энергетический компактный ручной щит, пособный отражать энергетические снаряды, но не может блокировать прямые воздействия."
	reference = "ME_SH"
	cost = 2000
	contains = list(/obj/item/shield/energy)


// ============== Мечи ==============

/datum/vox_pack/melee/sword
	name = "Энергосабля"
	desc = "Энергетическая сабля для абордажей кораблей."
	reference = "ME_SW"
	cost = 500
	contains = list(/obj/item/melee/energy/sword/pirate)

/datum/vox_pack/melee/sword/purple
	name = "Энергомеч (Фиолетовый)"
	desc = "Энергетический меч для прижигания ран отрубленных конечностей неприятеля. Цвет решительности, цвет Рейдеров. Классика Воксов."
	reference = "ME_SWP"
	cost = 2500
	contains = list(/obj/item/melee/energy/sword/saber/purple)

/datum/vox_pack/melee/sword/blue
	name = "Энергомеч (Синий)"
	desc = "Энергетический меч для прижигания ран отрубленных конечностей неприятеля. Цвет силы и стойкости. Его носят бастионы мира Воксов."
	reference = "ME_SWB"
	cost = 3250
	contains = list(/obj/item/melee/energy/sword/saber/blue)

/datum/vox_pack/melee/sword/green
	name = "Энергомеч (Зелёный)"
	desc = "Энергетический меч для прижигания ран отрубленных конечностей неприятеля. Цвет миротворцев, тех, кто не любит насилие и причиняет его с большой неохотой. С этим мечом причиняют добро и наносят радость."
	reference = "ME_SWG"
	cost = 3250
	contains = list(/obj/item/melee/energy/sword/saber/green)

/datum/vox_pack/melee/sword/red
	name = "Энергомеч (Красный)"
	desc = "Энергетический меч для прижигания ран отрубленных конечностей неприятеля. Цвет ненависти, гнева и злого злодейства злыхх злыдней. Безвкусица."
	reference = "ME_SWR"
	cost = 4000
	contains = list(/obj/item/melee/energy/sword/saber/red)

/datum/vox_pack/melee/sword/red
	name = "Уничтожитель насекомых"
	desc = "Всеми признанный лучший уничтожитель нианов и киданов."
	reference = "ME_SWR"
	cost = 150
	contains = list(/obj/item/melee/flyswatter)


// ============== Раскладываемое ==============

/datum/vox_pack/melee/dropwall
	name = "Генератор щита"
	desc = "Щитовой развертываемый генератор, активирующий временное укрытие, которое блокирует снаряды и взрывы с определенного направления, в то же время позволяя остальным снарядам свободно проходить сзади."
	reference = "ME_DW"
	cost = 500
	contains = list(/obj/item/grenade/barrier/dropwall)


