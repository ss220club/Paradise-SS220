/mob/living/basic/crab
	death_sound = 'modular_ss220/mobs/sound/creatures/crack_death2.ogg'
	mob_size = MOB_SIZE_SMALL
	holder_type = /obj/item/holder/crab

/mob/living/basic/crab/sea
	name = "морской краб"
	desc = "Кто проживает на дне океана?"
	icon = 'modular_ss220/mobs/icons/mob/animal.dmi'
	icon_state = "bluecrab"
	icon_living = "bluecrab"
	icon_dead = "bluecrab_dead"
	health = 50
	maxHealth = 50
	butcher_results = list(/obj/item/food/meat = 3)

/mob/living/basic/crab/royal
	name = "королевский краб"
	desc = "Величественный королевский краб."
	icon = 'modular_ss220/mobs/icons/mob/animal.dmi'
	icon_state = "royalcrab"
	icon_living = "royalcrab"
	icon_dead = "royalcrab_dead"
	health = 50
	maxHealth = 50
	butcher_results = list(/obj/item/food/meat = 5)

/mob/living/basic/crab/evil
	holder_type = /obj/item/holder/evilcrab
