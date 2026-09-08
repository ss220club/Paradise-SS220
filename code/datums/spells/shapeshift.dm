/datum/spell/shapeshift
	name = "Shapechange"
	desc = "Примите на время облик другого существа, чтобы использовать его природные способности. Если вы сделали свой выбор, его уже нельзя изменить."
	clothes_req = FALSE
	base_cooldown = 200
	cooldown_min = 50
	invocation = "RAC'WA NO!"
	invocation_type = "shout"
	action_icon_state = "shapeshift"

	var/shapeshift_type
	var/list/current_shapes = list()
	var/list/current_casters = list()
	var/list/possible_shapes = list(/mob/living/basic/mouse,
		/mob/living/simple_animal/pet/dog/corgi,
		/mob/living/simple_animal/bot/ed209,
		/mob/living/simple_animal/hostile/construct/armoured)

/datum/spell/shapeshift/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/shapeshift/cast(list/targets, mob/user = usr)
	for(var/mob/living/M in targets)
		if(!shapeshift_type)
			var/list/animal_list = list()
			for(var/path in possible_shapes)
				var/mob/living/simple_animal/A = path
				animal_list[initial(A.name)] = path
			shapeshift_type = tgui_input_list(M, "Выберите свой Звериный облик!", "Пришло время меняться!", animal_list)
			if(!shapeshift_type) //If you aren't gonna decide I am!
				shapeshift_type = pick(animal_list)
			shapeshift_type = animal_list[shapeshift_type]
		if(M in current_shapes)
			Restore(M)
		else
			Shapeshift(M)

/datum/spell/shapeshift/proc/Shapeshift(mob/living/caster)
	for(var/mob/living/M in caster)
		if(M.status_flags & GODMODE)
			to_chat(caster, SPAN_WARNING("Вы уже превратились!"))
			return

	var/mob/living/shape = new shapeshift_type(get_turf(caster))
	caster.forceMove(shape)
	caster.status_flags |= GODMODE

	current_shapes |= shape
	current_casters |= caster
	clothes_req = FALSE
	human_req = FALSE

	caster.mind.transfer_to(shape)

/datum/spell/shapeshift/proc/Restore(mob/living/shape)
	var/mob/living/caster
	for(var/mob/living/M in shape)
		if(M in current_casters)
			caster = M
			break
	if(!caster)
		return
	caster.forceMove(get_turf(shape))
	caster.status_flags &= ~GODMODE

	clothes_req = initial(clothes_req)
	human_req = initial(human_req)
	current_casters.Remove(caster)
	current_shapes.Remove(shape)

	shape.mind.transfer_to(caster)
	qdel(shape) //Gib it maybe ?

/datum/spell/shapeshift/dragon
	name = "Dragon Form"
	desc = "Превратитесь в Пепельного Дрейка."
	invocation = "*scream"

	shapeshift_type = /mob/living/simple_animal/hostile/megafauna/dragon/lesser
	current_shapes = list(/mob/living/simple_animal/hostile/megafauna/dragon/lesser)
	current_casters = list()
	possible_shapes = list(/mob/living/simple_animal/hostile/megafauna/dragon/lesser)

/datum/spell/shapeshift/dragon/Shapeshift(mob/living/caster)
	caster.visible_message(SPAN_DANGER("[caster.declent_ru(NOMINATIVE)] кричит в агонии, когда кости и когти вырываются из его плоти!"),
		SPAN_DANGER("Вы начинаете перевоплощаться."))
	if(!do_after(caster, 5 SECONDS, FALSE, caster))
		to_chat(caster, SPAN_WARNING("Вы теряете концентрацию и не можете продолжить колдовать!"))
		return
	return ..()

/datum/spell/shapeshift/bats
	name = "Bat Form"
	desc = "Примите облик стаи летучих мышей."
	invocation = "none"
	invocation_type = "none"
	action_icon_state = "vampire_bats"
	gain_desc = "Вы получили способность превращаться в летучую мышь. Это слабая форма, не имеющая способностей и полезная только для скрытности."

	shapeshift_type = /mob/living/basic/scarybat/adminvampire
	current_shapes = list(/mob/living/basic/scarybat/adminvampire)
	current_casters = list()
	possible_shapes = list(/mob/living/basic/scarybat/adminvampire)

/datum/spell/shapeshift/hellhound
	name = "Lesser Hellhound Form"
	desc = "Примите облик Адского пса."
	invocation = "none"
	invocation_type = "none"
	action_background_icon_state = "bg_demon"
	action_icon_state = "glare"
	gain_desc = "Вы получили возможность превращаться в Адского пса. Это боевая форма с различными способностями, выносливая, но не неуязвимая. Со временем она может восстановиться во время отдыха."

	shapeshift_type = /mob/living/basic/hellhound
	current_shapes = list(/mob/living/basic/hellhound)
	current_casters = list()
	possible_shapes = list(/mob/living/basic/hellhound)

/datum/spell/shapeshift/hellhound/greater
	name = "Greater Hellhound Form"
	shapeshift_type = /mob/living/basic/hellhound/greater
	current_shapes = list(/mob/living/basic/hellhound/greater)
	current_casters = list()
	possible_shapes = list(/mob/living/basic/hellhound/greater)
