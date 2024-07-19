/obj/effect/mob_spawn/treacherous_flesh
	name = "Зародыш коварной плоти"
	desc = "Небольшой красный сгусток. Похоже, это зародыш чего-то ужасного."
	mob_name = "Коварная Плоть"
	roundstart = FALSE
	death = FALSE
	mob_type = /mob/living/treacherous_flesh
	description = "Вы паразитический организм, внутри живого органика. Ваша цель - размножение и ассимиляция всего экипажа. Растите, развивайтесь, убивайте."
	flavour_text = "Вы коварная плоть - паразитический организм, живущий внутри разумного органика. Вы крупный антагонист и имеете право ликвидировать экипаж без особых причин. \
	Постепенно вы будете эволюционировать, получая новые способности и набирая силу. Когда вы закончите своё развитие - покиньте эту оболочку через специальный навык и помогите молодняку повторить ваш путь. \
	Не спешите раскрывать своё существования. Пока вы не предпринимаете никаких действий, единственный способ вас обнаружить - хирургическая операция. Затаитесь и выжидайте."
	icon_state = "spawner"
	icon = 'modular_ss220/lazarus/icons/treacherous_flesh.dmi'
	var/mob/living/carbon/human/host

/obj/effect/mob_spawn/treacherous_flesh/create(ckey, flavour = TRUE, name, mob/user = usr)
	if(!isnull(host) && !isnull(user) && !isnull(ckey))
		var/mob/living/treacherous_flesh/flesh = new mob_type(host.loc)
		flesh.ckey = ckey
		flesh.infest(host)
		if(flavour)
			to_chat(flesh, "[flavour_text]")
		log_game("[ckey] became treacherous flesh inside [host.name]")
		qdel(src)
