/obj/item/dnainjector
	name = "DNA-Injector"
	desc = "Инъекция модифицирующая ДНК испытуемого."
	icon = 'icons/obj/medical.dmi'
	icon_state = "dnainjector"
	inhand_icon_state = "dnainjector"
	belt_icon = "syringe"
	var/block = 0
	var/datum/dna2_record/buf = null
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "biotech=1"

	var/damage_coeff = 1
	var/used = FALSE

	// USE ONLY IN PREMADE SYRINGES.  WILL NOT WORK OTHERWISE.
	var/datatype = 0
	var/value = 0
	var/forcedmutation = FALSE //Will it give the mutation, guaranteed?

/obj/item/dnainjector/Initialize(mapload)
	. = ..()

	var/init_block = GetInitBlock()
	if(init_block)
		block = init_block

	if(datatype && block)
		buf = new
		buf.dna = new
		buf.types = datatype
		buf.dna.ResetSE()
		SetValue(value)

// Override this with a var reference to do setup
/obj/item/dnainjector/proc/GetInitBlock()
	return null

/obj/item/dnainjector/Destroy()
	QDEL_NULL(buf)
	return ..()

/obj/item/dnainjector/proc/GetRealBlock(selblock)
	if(selblock == 0)
		return block
	else
		return selblock

/obj/item/dnainjector/proc/GetState(selblock = 0)
	var/real_block = GetRealBlock(selblock)
	if(buf.types & DNA2_BUF_SE)
		return buf.dna.GetSEState(real_block)
	else
		return buf.dna.GetUIState(real_block)

/obj/item/dnainjector/proc/SetState(on, selblock = 0)
	var/real_block = GetRealBlock(selblock)
	if(buf.types & DNA2_BUF_SE)
		return buf.dna.SetSEState(real_block,on)
	else
		return buf.dna.SetUIState(real_block,on)

/obj/item/dnainjector/proc/GetValue(selblock = 0)
	var/real_block = GetRealBlock(selblock)
	if(buf.types & DNA2_BUF_SE)
		return buf.dna.GetSEValue(real_block)
	else
		return buf.dna.GetUIValue(real_block)

/obj/item/dnainjector/proc/SetValue(val, selblock = 0)
	var/real_block = GetRealBlock(selblock)
	if(buf.types & DNA2_BUF_SE)
		return buf.dna.SetSEValue(real_block,val)
	else
		return buf.dna.SetUIValue(real_block,val)

/obj/item/dnainjector/proc/inject(mob/living/M, mob/user)
	if(used)
		return
	if(isliving(M))
		M.apply_effect(rand(20 / (damage_coeff ** 2), 50 / (damage_coeff ** 2)), IRRADIATE)
	var/mob/living/carbon/human/H
	if(ishuman(M))
		H = M

	if(!buf)
		stack_trace("Применение [src.declent_ru(GENITIVE)] персонажем [user.declent_ru(NOMINATIVE)] на [M.declent_ru(PREPOSITIONAL)] не было правильно исполнено.")
		return

	spawn(0) //Some mutations have sleeps in them, like monkey
		if(!HAS_TRAIT(M, TRAIT_BADDNA) && !HAS_TRAIT(M, TRAIT_GENELESS)) // prevents drained people from having their DNA changed
			var/prev_ue = M.dna.unique_enzymes
			// UI in syringe.
			if(buf.types & DNA2_BUF_UI)
				if(!block) //isolated block?
					M.dna.UI = buf.dna.UI.Copy()
					M.dna.UpdateUI()
					M.UpdateAppearance()
					if(buf.types & DNA2_BUF_UE) //unique enzymes? yes

						M.real_name = buf.dna.real_name
						M.name = buf.dna.real_name
						M.dna.real_name = buf.dna.real_name
						M.dna.unique_enzymes = buf.dna.unique_enzymes
				else
					M.dna.SetUIValue(block,src.GetValue())
					M.UpdateAppearance()
			if(buf.types & DNA2_BUF_SE)
				if(!block) //isolated block?
					M.dna.SE = buf.dna.SE.Copy()
					M.dna.UpdateSE()
				else
					M.dna.SetSEValue(block,src.GetValue())
				domutcheck(M, forcedmutation ? MUTCHK_FORCED : FALSE)
				M.update_mutations()
			if(H)
				H.sync_organ_dna(assimilate = 0, old_ue = prev_ue)

/obj/item/dnainjector/attack__legacy__attackchain(mob/M, mob/user)
	if(used)
		to_chat(user, SPAN_WARNING("Этот инъектор уже использован!"))
		return
	if(!M.dna || HAS_TRAIT(M, TRAIT_GENELESS) || HAS_TRAIT(M, TRAIT_BADDNA)) //You know what would be nice? If the mob you're injecting has DNA, and so doesn't cause runtimes.
		return FALSE

	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("Вам не удаётся понять что с этим делать!"))
		return FALSE

	var/attack_log = "ввел изолированный [name]"

	if(buf && buf.types & DNA2_BUF_SE)
		if(block)
			if(GetState() && block == GLOB.monkeyblock && ishuman(M))
				attack_log = "ввёл изолированный [name] (MONKEY)"
				message_admins("[key_name_admin(user)] ввёл [key_name_admin(M)] изолированный [name] [SPAN_WARNING("(MONKEY)")]")

		else
			if(GetState(GLOB.monkeyblock) && ishuman(M))
				attack_log = "ввёл изолированный [name] (MONKEY)"
				message_admins("[key_name_admin(user)] ввёл [key_name_admin(M)] изолированный [name] [SPAN_WARNING("(MONKEY)")]")


	if(M != user)
		M.visible_message(SPAN_DANGER("[user.declent_ru(NOMINATIVE)] пытается инъецировать [M.declent_ru(GENITIVE)] используя [src.declent_ru(ACCUSATIVE)]!"), SPAN_USERDANGER("[user.declent_ru(NOMINATIVE)] пытается инъецировать [M.declent_ru(GENITIVE)] используя [src.declent_ru(ACCUSATIVE)]!"))
		if(!do_mob(user, M))
			return
		M.visible_message("<span class='danger'>[user.declent_ru(NOMINATIVE)] провёл инъекцию [M.declent_ru(DATIVE)] используя [src.declent_ru(ACCUSATIVE)]!", \
						"<span class='userdanger'>[user.declent_ru(NOMINATIVE)] провёл инъекцию [M.declent_ru(DATIVE)] используя [src.declent_ru(ACCUSATIVE)]!")
	else
		to_chat(user, SPAN_NOTICE("Вы инъецировали себя используя [src.declent_ru(ACCUSATIVE)]."))

	add_attack_logs(user, M, attack_log, ATKLOG_ALL)

	inject(M, user)
	used = TRUE
	icon_state = "dnainjector0"
	desc += " Он уже был использован."

/obj/item/dnainjector/hulkmut
	name = "DNA-Injector (Hulk)"
	desc = "Это сделает вас крепче и сильнее, ценой паршивого состояния кожи."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/hulkmut/GetInitBlock()
	return GLOB.hulkblock

/obj/item/dnainjector/antihulk
	name = "DNA-Injector (Anti-Hulk)"
	desc = "Исправляет зеленый загар и делает из вас сосунка как раньше."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antihulk/GetInitBlock()
	return GLOB.hulkblock

/obj/item/dnainjector/firemut
	name = "DNA-Injector (Fire)"
	desc = "Согревает вас на генетическом уровне от любых морозов."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/firemut/GetInitBlock()
	return GLOB.fireblock

/obj/item/dnainjector/antifire
	name = "DNA-Injector (Anti-Fire)"
	desc = "Отбирает у вас лишнее тепло, делая уязвимым к холодам."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antifire/GetInitBlock()
	return GLOB.fireblock

/obj/item/dnainjector/telemut
	name = "DNA-Injector (Tele.)"
	desc = "Профессор Х! Коляска в комплект не входит, в отличие от силы трогать предметы на расстоянии."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/telemut/GetInitBlock()
	return GLOB.teleblock

/obj/item/dnainjector/telemut/darkbundle
	name = "DNA injector"
	desc = "Прекрасно. Позволь ненависти течь в твоих жилах и встань на тёмную сторону силы."

/obj/item/dnainjector/antitele
	name = "DNA-Injector (Anti-Tele.)"
	desc = "Отведёт от вас прочь способность перемещать вещи силой мысли."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antitele/GetInitBlock()
	return GLOB.teleblock

/obj/item/dnainjector/nobreath
	name = "DNA-Injector (Breathless)"
	desc = "Задержи дыхание и считай до бесконечности."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/nobreath/GetInitBlock()
	return GLOB.breathlessblock

/obj/item/dnainjector/antinobreath
	name = "DNA-Injector (Anti-Breathless)"
	desc = "Задержи дыхание и считай до ста."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antinobreath/GetInitBlock()
	return GLOB.breathlessblock

/obj/item/dnainjector/remoteview
	name = "DNA-Injector (Remote View)"
	desc = "Смотрите в стенку на любом расстоянии за теми, кто обзавелся этой силой вместе с вами."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/remoteview/GetInitBlock()
	return GLOB.remoteviewblock

/obj/item/dnainjector/antiremoteview
	name = "DNA-Injector (Anti-Remote View)"
	desc = "Заставляет вас пройтись, чтобы найти свой объект слежки."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiremoteview/GetInitBlock()
	return GLOB.remoteviewblock

/obj/item/dnainjector/regenerate
	name = "DNA-Injector (Regeneration)"
	desc = "Оплаченная медицинская страховка. Самолечение!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/regenerate/GetInitBlock()
	return GLOB.regenerateblock

/obj/item/dnainjector/antiregenerate
	name = "DNA-Injector (Anti-Regeneration)"
	desc = "У вас нет денег на медпомощь? Теперь и страховки не будет."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiregenerate/GetInitBlock()
	return GLOB.regenerateblock

/obj/item/dnainjector/morph
	name = "DNA-Injector (Morph)"
	desc = "Полное преображение и без дурацкого зеркала."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/morph/GetInitBlock()
	return GLOB.morphblock

/obj/item/dnainjector/antimorph
	name = "DNA-Injector (Anti-Morph)"
	desc = "Лечит раздвоение, растроение... много личностей в одной шкуре."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antimorph/GetInitBlock()
	return GLOB.morphblock

/obj/item/dnainjector/noprints
	name = "DNA-Injector (No Prints)"
	desc = "Лучше чем пара окрашенных изоляционных перчаток. А главное - большая анонимность!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/noprints/GetInitBlock()
	return GLOB.noprintsblock

/obj/item/dnainjector/antinoprints
	name = "DNA-Injector (Anti-No Prints)"
	desc = "Теперь нарушать закон придётся только в нормальных перчатках."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antinoprints/GetInitBlock()
	return GLOB.noprintsblock

/obj/item/dnainjector/insulation
	name = "DNA-Injector (Shock Immunity)"
	desc = "220 Вольт - это пустяк. Полная защита от электричества!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/insulation/GetInitBlock()
	return GLOB.shockimmunityblock

/obj/item/dnainjector/antiinsulation
	name = "DNA-Injector (Anti-Shock Immunity)"
	desc = "Лучше обзавестись изоляционными перчатками..."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiinsulation/GetInitBlock()
	return GLOB.shockimmunityblock

/obj/item/dnainjector/small_size
	name = "DNA-Injector (Small Size)"
	desc = "Делает из вас дварфа, гнома, ребёнка или бегающий гвоздь. Как повезёт."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/small_size/GetInitBlock()
	return GLOB.smallsizeblock

/obj/item/dnainjector/anti_small_size
	name = "DNA-Injector (Anti-Small Size)"
	desc = "Возвращает ваш рост к норме, чтобы никто не спрашивал паспорт."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/anti_small_size/GetInitBlock()
	return GLOB.smallsizeblock

/obj/item/dnainjector/eatmut
	name = "DNA-Injector (Matter Eater)"
	desc = "С этим вы можете и корову съесть. Буквально."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/eatmut/GetInitBlock()
	return GLOB.eatblock

/obj/item/dnainjector/antieat
	name = "DNA-Injector (Anti-Matter Eater)"
	desc = "Возвращает вашу скучную диету трёх омлетов за день."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antieat/GetInitBlock()
	return GLOB.eatblock

/////////////////////////////////////
/obj/item/dnainjector/antiglasses
	name = "DNA-Injector (Anti-Glasses)"
	desc = "Выбрось к черту эти очки!"
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiglasses/GetInitBlock()
	return GLOB.glassesblock

/obj/item/dnainjector/glassesmut
	name = "DNA-Injector (Glasses)"
	desc = "А говорили тебе за консолью долго не сидеть. Ищи очки для зрения."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/glassesmut/GetInitBlock()
	return GLOB.glassesblock

/obj/item/dnainjector/epimut
	name = "DNA-Injector (Epi.)"
	desc = "Лучше не щелкать переключатель света несколько раз..."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/epimut/GetInitBlock()
	return GLOB.epilepsyblock

/obj/item/dnainjector/antiepi
	name = "DNA-Injector (Anti-Epi.)"
	desc = "Поможет вам избавиться от ощущения, что комната трясется."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiepi/GetInitBlock()
	return GLOB.epilepsyblock

/obj/item/dnainjector/anticough
	name = "DNA-Injector (Anti-Cough)"
	desc = "Избавит вас от боли в горле."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/anticough/GetInitBlock()
	return GLOB.coughblock

/obj/item/dnainjector/coughmut
	name = "DNA-Injector (Cough)"
	desc = "Нашлёт длительные кошмары на ваше горло."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/coughmut/GetInitBlock()
	return GLOB.coughblock

/obj/item/dnainjector/clumsymut
	name = "DNA-Injector (Clumsy)"
	desc = "Создает нелепые ситуации и делает обладателя этой мутации рассеяным."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/clumsymut/GetInitBlock()
	return GLOB.clumsyblock

/obj/item/dnainjector/anticlumsy
	name = "DNA-Injector (Anti-Clumy)"
	desc = "Убирает путаницу в вашей жизни."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/anticlumsy/GetInitBlock()
	return GLOB.clumsyblock

/obj/item/dnainjector/stuttmut
	name = "DNA-Injector (Stutt.)"
	desc = "Вызывает у в-в-вас н-нер-в-вный тик."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/stuttmut/GetInitBlock()
	return GLOB.nervousblock


/obj/item/dnainjector/antistutt
	name = "DNA-Injector (Anti-Stutt.)"
	desc = "Исправляет нарушение речи и делает вас собраннее."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antistutt/GetInitBlock()
	return GLOB.nervousblock

/obj/item/dnainjector/blindmut
	name = "DNA-Injector (Blind)"
	desc = "Ослепляет вас. Поразительно, правда?"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/blindmut/GetInitBlock()
	return GLOB.blindblock

/obj/item/dnainjector/antiblind
	name = "DNA-Injector (Anti-Blind)"
	desc = "Если вы это читаете, то он вам и не нужен."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiblind/GetInitBlock()
	return GLOB.blindblock

/obj/item/dnainjector/paraplegicmut
	name = "DNA-Injector (Paraplegic)"
	desc = "Напомнит вам о вашей любви к поцелуям с поверхностью под ногами."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/paraplegicmut/GetInitBlock()
	return GLOB.paraplegicblock

/obj/item/dnainjector/antiparaplegic
	name = "DNA-Injector (Anti-Paraplegic)"
	desc = "Возвращает ваши ноги на рабочую смену."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antiparaplegic/GetInitBlock()
	return GLOB.paraplegicblock

/obj/item/dnainjector/deafmut
	name = "DNA-Injector (Deaf)"
	desc = "Вызывает генетическую утрату слуха."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/deafmut/GetInitBlock()
	return GLOB.deafblock

/obj/item/dnainjector/antideaf
	name = "DNA-Injector (Anti-Deaf)"
	desc = "Устраняет проблемы со слухом, вызванные генетикой."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antideaf/GetInitBlock()
	return GLOB.deafblock

/obj/item/dnainjector/hallucination
	name = "DNA-Injector (Halluctination)"
	desc = "То что вы видите, не всегда является реальностью."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/hallucination/GetInitBlock()
	return GLOB.hallucinationblock

/obj/item/dnainjector/antihallucination
	name = "DNA-Injector (Anti-Hallucination)"
	desc = "Больше никаких призраков! Только реальные угрозы вашей жизни."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/antihallucination/GetInitBlock()
	return GLOB.hallucinationblock

/obj/item/dnainjector/h2m
	name = "DNA-Injector (Human > Monkey)"
	desc = "Откатывает вас на ступень эволюции назад, если вы еще не там."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/h2m/GetInitBlock()
	return GLOB.monkeyblock

/obj/item/dnainjector/m2h
	name = "DNA-Injector (Monkey > Human)"
	desc = "Делает вас больше и умнее, но это не точно."
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/m2h/GetInitBlock()
	return GLOB.monkeyblock


/obj/item/dnainjector/comic
	name = "DNA-Injector (Comic)"
	desc = "Хонк!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	forcedmutation = TRUE

/obj/item/dnainjector/comic/GetInitBlock()
	return GLOB.comicblock

/obj/item/dnainjector/anticomic
	name = "DNA-Injector (Ant-Comic)"
	desc = "Хонк...?"
	datatype = DNA2_BUF_SE
	value = 0x001
	forcedmutation = TRUE

/obj/item/dnainjector/anticomic/GetInitBlock()
	return GLOB.comicblock
