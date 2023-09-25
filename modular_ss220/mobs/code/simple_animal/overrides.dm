// Animals additions
/mob/living/simple_animal/pig
	death_sound = 'modular_ss220/mobs/sound/creatures/pig_death.ogg'
	damaged_sound = list()
	talk_sound = list('modular_ss220/mobs/sound/creatures/pig_talk1.ogg', 'modular_ss220/mobs/sound/creatures/pig_talk2.ogg')

/mob/living/simple_animal/cow
	death_sound = 'modular_ss220/mobs/sound/creatures/cow_death.ogg'
	damaged_sound = list('modular_ss220/mobs/sound/creatures/cow_damaged.ogg')
	talk_sound = list('modular_ss220/mobs/sound/creatures/cow_talk1.ogg', 'modular_ss220/mobs/sound/creatures/cow_talk2.ogg')

/mob/living/simple_animal/chicken
	death_sound = 'modular_ss220/mobs/sound/creatures/chicken_death.ogg'
	damaged_sound = list('modular_ss220/mobs/sound/creatures/chicken_damaged1.ogg', 'modular_ss220/mobs/sound/creatures/chicken_damaged2.ogg')
	talk_sound = list('modular_ss220/mobs/sound/creatures/chicken_talk.ogg')

/mob/living/simple_animal/goose
	death_sound = 'modular_ss220/mobs/sound/creatures/duck_quak1.ogg'
	talk_sound = list('modular_ss220/mobs/sound/creatures/duck_talk1.ogg', 'modular_ss220/mobs/sound/creatures/duck_talk2.ogg', 'modular_ss220/mobs/sound/creatures/duck_talk3.ogg', 'modular_ss220/mobs/sound/creatures/duck_quak1.ogg', 'modular_ss220/mobs/sound/creatures/duck_quak2.ogg', 'modular_ss220/mobs/sound/creatures/duck_quak3.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/duck_aggro1.ogg', 'modular_ss220/mobs/sound/creatures/duck_aggro2.ogg')

/mob/living/simple_animal/mouse
	var/non_standard = FALSE // for no "mouse_" with mouse_color
	death_sound = 'modular_ss220/mobs/sound/creatures/rat_death.ogg'
	talk_sound = list('modular_ss220/mobs/sound/creatures/rat_talk.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/rat_wound.ogg')

/mob/living/simple_animal/hostile/bear
	var/trigger_sound = 'modular_ss220/mobs/sound/creatures/bear_rawr.ogg'
	death_sound = 'modular_ss220/mobs/sound/creatures/bear_death.ogg'
	talk_sound = list('modular_ss220/mobs/sound/creatures/bear_talk1.ogg', 'modular_ss220/mobs/sound/creatures/bear_talk2.ogg', 'modular_ss220/mobs/sound/creatures/bear_talk3.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/bear_onerawr1.ogg', 'modular_ss220/mobs/sound/creatures/bear_onerawr2.ogg', 'modular_ss220/mobs/sound/creatures/bear_onerawr3.ogg')
