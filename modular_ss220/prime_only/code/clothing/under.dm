// MARK: Under

/obj/item/clothing/under/rank/cargo/expedition_prime
	name = "navy expedition uniform"
	desc = "Экспедиционная форма военного образца с опознавательными знаками Нанотрейзен."
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 20, ACID = 20)
	icon = 'modular_ss220/prime_only/icons/object/under.dmi'
	icon_state = "expedition_prime_navy"
	item_state = "expedition_prime_navy"
	item_color = "expedition_prime_navy"
	sprite_sheets = list(
		"Human" = 'modular_ss220/prime_only/icons/mob/under.dmi',
		"Vox" = 'modular_ss220/prime_only/icons/mob/species/vox/under/cargo.dmi',
		"Drask" = 'modular_ss220/prime_only/icons/mob/species/drask/under/cargo.dmi',
		"Kidan" = 'modular_ss220/prime_only/icons/mob/species/kidan/under/cargo.dmi',
		)

/obj/item/clothing/under/rank/cargo/expedition_prime/green
	name = "green expedition uniform"
	icon_state = "expedition_prime_green"
	item_state = "expedition_prime_green"
	item_color = "expedition_prime_green"

/obj/item/clothing/under/rank/cargo/expedition_prime/tan
	name = "tan expedition uniform"
	icon_state = "expedition_prime_tan"
	item_state = "expedition_prime_tan"
	item_color = "expedition_prime_tan"

/obj/item/clothing/under/rank/cargo/expedition_prime/grey
	name = "grey expedition uniform"
	icon_state = "expedition_prime_grey"
	item_state = "expedition_prime_grey"
	item_color = "expedition_prime_grey"

/obj/item/clothing/under/midnight_under
	name = "профессиональный тактический костюм"
	desc = "Костюм настоящих профессионалов. Лёгкий и практичный, обладает встроенной активной терморегуляционной системой и повышенной прочностью за счет вплетенных пластитановых волокон. \
		Надевая его, вы чувстуете себя менее заметным."
	icon = 'modular_ss220/prime_only/icons/object/under.dmi'
	icon_state = "midnight_under"
	item_state = "midnight_under"
	item_color = "midnight_under"
	sprite_sheets = list(
		"Human" = 'modular_ss220/prime_only/icons/mob/under.dmi',
	)
	species_restricted = list("Human") // Уточню
	armor = list(MELEE = 10, BULLET = 10, LASER = 5, ENERGY = 5, BOMB = 5, RAD = 0, FIRE = 5, ACID = 50)
