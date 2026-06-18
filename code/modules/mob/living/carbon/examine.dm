/**
 * Get the message parts, in order, for a proper examine.
 * Message parts should be as follows:
 * - Pronoun/intro for how they've got it on them
 * - The item itself
 * - Preposition for where it is
 * - the location it's in
 *
 * Arguments represent whether to skip a certain slot when handling the message.
 */
/mob/living/carbon/proc/examine_visible_clothing(skip_gloves = FALSE, skip_suit_storage = FALSE, skip_jumpsuit = FALSE, skip_shoes = FALSE, skip_mask = FALSE, skip_ears = FALSE, skip_eyes = FALSE, skip_face = FALSE)
	return list(
		list("[ru_p_hold()]", l_hand, "в", "левой руке"),
		list("[ru_p_hold()]", r_hand, "в", "правой руке"),
		list("[ru_p_wear()]", head, "на", "голове"),
		list("[ru_p_wear()]", wear_suit, null, null),
		list("[ru_p_carry()]", back, "на", "своей спине"),
	)

/**
 * Special handlers for processing limbs go here, based on limb names in examine_visible_clothing.
 */
/mob/living/carbon/proc/examine_handle_individual_limb(limb_name)
	return ""

/// Identify what this mob in particular is.
/mob/living/carbon/proc/examine_what_am_i(skip_jumpsuit, skip_face)
	return "."

/// Add whatever you want to start the damage block with here.
/mob/living/carbon/proc/examine_start_damage_block(skip_gloves = FALSE, skip_suit_storage = FALSE, skip_jumpsuit = FALSE, skip_shoes = FALSE, skip_mask = FALSE, skip_ears = FALSE, skip_eyes = FALSE, skip_face = FALSE)
	return ""

/mob/living/carbon/proc/examine_get_brute_message()
	return "bruising"

/**
 * Add specific damage flavor here.
 */
/mob/living/carbon/proc/examine_damage_flavor()

	var/msg = ""

	var/damage = getBruteLoss() //no need to calculate each of these twice

	if(damage)
		var/brute_message = examine_get_brute_message()
		if(damage < 60)
			msg += "[ru_p_they(TRUE)] [damage < 30 ? "немного" : "умеренно"] [brute_message].\n"
		else
			msg += "<b>[ru_p_they(TRUE)] серьёзно [brute_message]!</b>\n"

	damage = getFireLoss()
	if(damage)
		if(damage < 60)
			msg += "У [ru_p_theirs()] [damage < 30 ? "небольшие" : "умеренные"] ожоги.\n"
		else
			msg += "<b>У [ru_p_theirs()] серьёзные ожоги!</b>\n"

	damage = getCloneLoss()
	if(damage)
		if(damage < 60)
			msg += "У [ru_p_theirs()] [damage < 30 ? "небольшие" : "умеренные"] клеточные повреждения.\n"
		else
			msg += "<b>У [ru_p_theirs()] серьёзные клеточные повреждения!</b>\n"

	return msg

/**
 * Add any extra info which should be within the "damage" block, the big warning span.
 */
/mob/living/carbon/proc/examine_extra_damage_flavor()
	return ""

/**
 * Add some last information in before HUDs get put through.
 */
/mob/living/carbon/proc/examine_extra_general_flavor(mob/user)
	return ""

/mob/living/carbon/proc/examine_show_ssd()
	if(!HAS_TRAIT(src, SCRYING))
		if(!key)
			return "[SPAN_DEADSAY("У [ru_p_theirs()] наблюдается кататония. Стресс, связанный с жизнью в открытом космосе, должно быть, оказался для [ru_p_theirs()] слишком сильным. Восстановление маловероятно.")]\n"
		else if(!client)
			return "[ru_p_them(TRUE)] внезапно одолел сон, вероятно вызванный Синдромом Расстройства Сна (SSD). [ru_p_they()] может скоро проснуться.\n"

	return ""

/mob/living/carbon/examine(mob/user)
	if(HAS_TRAIT(src, TRAIT_UNKNOWN))
		return list(SPAN_NOTICE("Вы с трудом можете разглядеть хоть какие-либо детали..."))

	var/skipgloves = FALSE
	var/skipsuitstorage = FALSE
	var/skipjumpsuit = FALSE
	var/skipshoes = FALSE
	var/skipmask = FALSE
	var/skipears = FALSE
	var/skipeyes = FALSE
	var/skipface = FALSE
	var/hallucinating = HAS_TRAIT(user, TRAIT_EXAMINE_HALLUCINATING)

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE
		skipeyes |= wear_mask.flags_inv & HIDEEYES

	var/msg = "<span class='notice'>Это "
	if(HAS_TRAIT(src, TRAIT_I_WANT_BRAINS))
		msg = "[SPAN_NOTICE("Это <span class='warning'>ковыляющий труп")] "

	msg += "<em>[name]</em>"

	// Show what you are
	msg += examine_what_am_i(skipgloves, skipsuitstorage, skipjumpsuit, skipshoes, skipmask, skipears, skipeyes, skipface)
	msg += "\n"

	// All the things wielded/worn that can be reasonably described with a common template:
	var/list/message_parts = examine_visible_clothing(skipgloves, skipsuitstorage, skipjumpsuit, skipshoes, skipmask, skipears, skipeyes, skipface)
	var/list/abstract_items = list()
	var/list/grab_items = list()

	for(var/parts in message_parts)
		var/action = parts[1]
		var/obj/item/item = parts[2]
		var/preposition = parts[3]
		var/limb_name = parts[4]
		var/accessories = null
		if(length(parts) >= 5)
			accessories = parts[5]

		if(item)
			if(HAS_TRAIT(item, TRAIT_SKIP_EXAMINE))
				continue
			if(istype(item, /obj/item/grab))
				grab_items |= item

			if(item.flags & ABSTRACT)
				abstract_items |= item
			else
				var/item_words = item.declent_ru(ACCUSATIVE)
				if(item.blood_DNA)
					item_words = "[item.blood_color != "#030303" ? ru_blood_stained(item) : ru_oil_stained(item)] [item.declent_ru(ACCUSATIVE)]"
				var/submsg = "[ru_p_they(TRUE)] [action] [bicon(item)] [item_words]"
				if(accessories)
					submsg += ", закрепляя поверх [accessories]"
				if(limb_name)
					submsg += "[preposition] [limb_name]"
				if(item.blood_DNA)
					submsg = "[SPAN_WARNING("[submsg]!")]\n"
				else
					submsg = "[submsg].\n"
				msg += submsg
		else
			// add any extra info on the limbs themselves
			msg += examine_handle_individual_limb(limb_name)

	// hallucinating?
	if(hallucinating && prob(50))
		// List of hallucination messages
		var/list/hallucination_texts = list(
			"Вы моргаете, и на мгновение, [ru_p_them()] тело мерцает словно мираж, а [ru_p_them()] взгляд пробирает вас до муражек.",
			"[ru_p_they(TRUE)] будто бы в окружении целого роя маленьких светящихся бабочек.",
			"[ru_p_they(TRUE)] [ru_p_wear()] корону, сделанную из спагетти. Хотя, постойте... её уже нет.",
			"[ru_p_they(TRUE)] [ru_p_do()] что-то странное, словно замышляя ограбление века.",
			"[ru_p_them(TRUE)] напевание тихой мелодии, отдаётся пронзительным и звонким эхо в вашей голове.",
			"[ru_p_them(TRUE)] тёплая улыбка, которую вы только что лицезрели, вдруг разбилась на тысячу маленьких осколков.",
			"[ru_p_them(TRUE)] тело словно парит над поверхностью, едва ли касаясь пола.",
			"[ru_p_them(TRUE)] руки мерцают как голограмма, быстро жестикулируя ими, прежде чем вернуться к норме.",
			"[ru_p_they(TRUE)] окутывает слабый клубящийся туман, что тут же исчезает, лишь только вы попытались сфокусироваться на нём.",
			"Вы мельком глядите на [ru_p_theirs()], и на мгновение, [ru_p_them()] тень бросается столь далеко, будто пытается убежать от вашего взгляда. Вам показалось, или она смотрела на вас в ответ?",
			"Вы мельком глядите на [ru_p_theirs()], и на мгновение, [ru_p_them()] глаза вспыхивают странным металлическим блеском. Вы готовы поклясться что он был золотым... либо багровым?",
			"[ru_p_them(TRUE)] ход в вашем направлении вдруг пробирает до муражек, глядя на то как [ru_p_them(TRUE)] силуэт тянется слишком сильно. [ru_p_them(TRUE)] шаги затихают, или вам это просто чудится? В [ru_p_them()] движении определённо что-то не так?",
			"На мгновение, застывая в неестественной позе, пока [ru_p_them()] голова и ноги неподвижны и невозмутимы. [ru_p_them(TRUE)] руки вытягиваются в стороны, а на месте [ru_p_them()] глаз виднеется лишь чёрная пустота.",
			"[ru_p_they(TRUE)] не [ru_p_have()] лица. На его месте виднеется лишь невообразимо темный слой пустоты. [ru_p_them(TRUE)] склеры единственный ориентир того, что у [ru_p_theirs()] ещё есть глаза.",
			"Вы клянётесь, будто только что лицезрели [ru_p_them()] рыдание и отчаянные мольбы о помощи!",
			"У [ru_p_theirs()] обильное кровотечение! Впрочем, [ru_p_them()] пролитая кровь сама возвращается обратно!",
			"[ru_p_them(TRUE)] голова резко дергается, чтобы встретиться с вашим взглядом."
	)
		// Pick a random hallucination description
		var/random_text = pick(hallucination_texts)
		msg += "[SPAN_WARNING("[random_text]")]\n"

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/restraints/handcuffs/cable/zipties))
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] руки [bicon(handcuffed)] скручены стяжками!")]\n"
		else if(istype(handcuffed, /obj/item/restraints/handcuffs/twimsts))
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] руки [bicon(handcuffed)] скручены сладостными стяжками!")]\n"
		else if(istype(handcuffed, /obj/item/restraints/handcuffs/cable))
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] руки [bicon(handcuffed)] стянуты проводами!")]\n"
		else
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] руки [bicon(handcuffed)] закованы в наручники!")]\n"

	//legcuffed?
	if(legcuffed)
		if(istype(legcuffed, /obj/item/restraints/legcuffs/beartrap))
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] нога [bicon(legcuffed)] попала в капкан!")]\n"
		else
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] ноги [bicon(legcuffed)] скованы!")]\n"

	for(var/obj/item/abstract_item in abstract_items)
		var/text = abstract_item.customised_abstract_text(src)
		if(!text)
			continue
		msg += "[text]\n"

	for(var/obj/item/grab/grab in grab_items)
		switch(grab.state)
			if(GRAB_AGGRESSIVE)
				msg += "[SPAN_BOLDWARNING("[ru_p_they(TRUE)] [ru_p_hold()] [grab.affecting.declent_ru(ACCUSATIVE)] за руки!")]\n"
			if(GRAB_NECK)
				msg += "[SPAN_BOLDWARNING("[ru_p_they(TRUE)] [ru_p_hold()] шею [grab.affecting.declent_ru(GENITIVE)] в захвате!")]\n"
			if(GRAB_KILL)
				msg += "[SPAN_BOLDWARNING("[ru_p_they(TRUE)] [ru_p_hold()] [grab.affecting.declent_ru(ACCUSATIVE)], пытаясь задушить!")]\n"

	//Jitters
	switch(AmountJitter())
		if(600 SECONDS to INFINITY)
			msg += "[SPAN_WARNING("<b>У [ru_p_theirs()] сильные судороги!</b>")]\n"
		if(400 SECONDS to 600 SECONDS)
			msg += "[SPAN_WARNING("У [ru_p_theirs()] дрожь по всему телу.")]\n"
		if(200 SECONDS to 400 SECONDS)
			msg += "[SPAN_WARNING("[ru_p_them(TRUE)] тело слегка подрагивает.")]\n"


	var/appears_dead = FALSE
	var/just_sleeping = FALSE //We don't appear as dead upon casual examination, just sleeping

	if(stat == DEAD || HAS_TRAIT(src, TRAIT_FAKEDEATH))
		var/obj/item/clothing/glasses/E = get_item_by_slot(ITEM_SLOT_EYES)
		var/are_we_in_weekend_at_bernies = E?.tint && istype(buckled, /obj/structure/chair) //Are we in a chair with our eyes obscured?

		if(isliving(user) && are_we_in_weekend_at_bernies)
			just_sleeping = TRUE
		else
			appears_dead = TRUE

		if(suiciding)
			msg += "[SPAN_WARNING("Кажется это было самоубийством... надежды на восстановление нет.")]\n"
		if(!just_sleeping)
			msg += "<span class='deadsay'>[ru_p_them(TRUE)] тело обмякло и не двигается"
			if(get_int_organ(/obj/item/organ/internal/brain) && !client) // body has no online player inside - let's look for ghost
				if(!check_ghost_client()) // our ghost is offline or no ghost attached to body
					msg += ", не подаёт особых надежд на восстановление"
				if(!get_ghost() && !key) // no ghost attached to body
					msg += " и [ru_p_them()] дух покинул этот мир"
			msg += "...</span>\n"

	if(!get_int_organ(/obj/item/organ/internal/brain))
		msg += "[SPAN_DEADSAY("Выглядит так, будто у [ru_p_theirs()] отсутствует мозг...")]\n"

	msg += "<span class='warning'>"

	// Stuff at the start of the block
	msg += examine_start_damage_block(skipgloves, skipsuitstorage, skipjumpsuit, skipshoes, skipmask, skipears, skipeyes, skipface)

	// Show how badly they're damaged
	msg += examine_damage_flavor()

	if(fire_stacks > 0)
		msg += "[ru_p_them(TRUE)] тело покрыто чем-то горючим.\n"
	if(fire_stacks < 0)
		msg += "[ru_p_them(TRUE)] тело чем-то пропитано.\n"

	switch(wetlevel)
		if(1)
			msg += "[ru_p_them(TRUE)] тело едва ли промокло.\n"
		if(2)
			msg += "[ru_p_them(TRUE)] тело немного влажное.\n"
		if(3)
			msg += "[ru_p_them(TRUE)] тело заметно обмокло.\n"
		if(4)
			msg += "[ru_p_them(TRUE)] тело сильно обмокло.\n"
		if(5)
			msg += "[ru_p_them(TRUE)] тело серьёзно обмокло.\n"

	if(nutrition < NUTRITION_LEVEL_HYPOGLYCEMIA)
		if(ismachineperson(src))
			msg += "[ru_p_them(TRUE)] индикатор питания мигает красным.\n"
		else
			msg += "У [ru_p_theirs()] тяжелое недоедание.\n"

	if(HAS_TRAIT(src, TRAIT_FAT))
		msg += "[ru_p_them(TRUE)] организм страдает ожирением.\n"
		if(user.nutrition < NUTRITION_LEVEL_HYPOGLYCEMIA)
			msg += "[ru_p_them(TRUE)] тело кажется пухлым и аппетитным - прямо как маленький толстый поросёнок. Вкусный поросёнок...\n"  // guh

	else if(nutrition >= NUTRITION_LEVEL_FAT)
		msg += "[ru_p_them(TRUE)] тело заметно располнело.\n"

	if(blood_volume < BLOOD_VOLUME_SAFE)
		msg += "У [ru_p_theirs()] бледная кожа.\n"

	if(reagents.has_reagent("teslium"))
		msg += "От [ru_p_theirs()] исходит мягкое голубое свечение!\n"

	if(HAS_TRAIT(src, TRAIT_PLAGUE_ZOMBIE)) //to tell plague zombies easier through clothing
		msg += "От [ru_p_theirs()] воняет гнилью и смертью!\n"

	// add in anything else we want at the end of this block
	msg += examine_extra_damage_flavor()

	msg += "</span>"

	if(!appears_dead)
		if(stat == UNCONSCIOUS || just_sleeping)
			msg += "[ru_p_they(TRUE)] не реагирует на окружение и, кажется, крепко спит.\n"
		else if(getBrainLoss() >= 60)
			msg += "[ru_p_they(TRUE)] пялится куда-то вдаль с абсолютно пустой физиономией.\n"

		if(get_int_organ(/obj/item/organ/internal/brain))
			msg += examine_show_ssd()
	// add anything else in here before huds
	msg += examine_extra_general_flavor(user)

	if(print_flavor_text() && !skipface)
		if(get_organ("head"))
			var/obj/item/organ/external/head/H = get_organ("head")
			if(!(H.status & ORGAN_DISFIGURED))
				msg += "[print_flavor_text()]\n"

	msg += "</span>"
	if(pose)
		if(findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0)
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[p_they(TRUE)] [pose]"

	. = list(msg)

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M, hudtype)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/clothing/glasses/hud/hudglasses
		if(istype(H.glasses, /obj/item/clothing/glasses/hud))
			hudglasses = H.glasses
			if(hudglasses.hud_debug)
				return TRUE

		var/have_hudtypes = list()
		var/datum/atom_hud/data/human/medbasic = GLOB.huds[DATA_HUD_MEDICAL_BASIC]
		var/datum/atom_hud/data/human/medadv = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
		var/datum/atom_hud/data/human/secbasic = GLOB.huds[DATA_HUD_SECURITY_BASIC]
		var/datum/atom_hud/data/human/secadv = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
		var/datum/atom_hud/data/anomalous = GLOB.huds[DATA_HUD_ANOMALOUS]
		if((H in medbasic.hudusers) || (H in medadv.hudusers))
			have_hudtypes += EXAMINE_HUD_MEDICAL_READ
		if(H in secadv.hudusers)
			have_hudtypes += EXAMINE_HUD_SECURITY_READ
		if(H in secbasic.hudusers)
			have_hudtypes += EXAMINE_HUD_SKILLS
		if(H in anomalous.hudusers)
			have_hudtypes += ANOMALOUS_HUD

		var/user_accesses = M.get_access()
		var/secwrite = has_access(null, list(ACCESS_SECURITY, ACCESS_FORENSICS_LOCKERS), user_accesses) // same as obj/machinery/computer/secure_data/req_one_access
		var/medwrite = has_access(null, list(ACCESS_MEDICAL, ACCESS_FORENSICS_LOCKERS), user_accesses) // same access as obj/machinery/computer/med_data/req_one_access
		if(secwrite || hudglasses?.hud_access_override)
			have_hudtypes += EXAMINE_HUD_SECURITY_WRITE
		if(medwrite)
			have_hudtypes += EXAMINE_HUD_MEDICAL_WRITE

		return (hudtype in have_hudtypes)

	else if(isrobot(M) || is_ai(M)) //Stand-in/Stopgap to prevent pAIs from freely altering records, pending a more advanced Records system
		var/mob/living/silicon/ai/sillycon = M
		if(sillycon.laws.zeroth_law && is_ai(M))
			return (hudtype in list(EXAMINE_HUD_MALF_READ, EXAMINE_HUD_MALF_WRITE, EXAMINE_HUD_SECURITY_READ, EXAMINE_HUD_SECURITY_WRITE, EXAMINE_HUD_MEDICAL_READ, EXAMINE_HUD_MEDICAL_WRITE, EXAMINE_HUD_SKILLS))
		else if(sillycon.laws.zeroth_law && isrobot(M))
			return (hudtype in list(EXAMINE_HUD_MALF_READ, EXAMINE_HUD_SECURITY_READ, EXAMINE_HUD_SECURITY_WRITE, EXAMINE_HUD_MEDICAL_READ, EXAMINE_HUD_MEDICAL_WRITE, EXAMINE_HUD_SKILLS))
		else
			return (hudtype in list(EXAMINE_HUD_SECURITY_READ, EXAMINE_HUD_SECURITY_WRITE, EXAMINE_HUD_MEDICAL_READ, EXAMINE_HUD_MEDICAL_WRITE, EXAMINE_HUD_SKILLS))

	else if(isobserver(M))
		var/mob/dead/observer/O = M
		if(DATA_HUD_SECURITY_ADVANCED in O.data_hud_seen)
			return (hudtype in list(EXAMINE_HUD_SECURITY_READ, EXAMINE_HUD_MEDICAL_READ, EXAMINE_HUD_SKILLS))

	return FALSE

// Ignores robotic limb branding prefixes like "Morpheus Cybernetics"
/proc/ignore_limb_branding(limb_name)
	switch(limb_name)
		if("chest")
			. = "upper body"
		if("groin")
			. = "lower body"
		if("head")
			. = "head"
		if("l_arm")
			. = "left arm"
		if("r_arm")
			. = "right arm"
		if("l_leg")
			. = "left leg"
		if("r_leg")
			. = "right leg"
		if("l_foot")
			. = "left foot"
		if("r_foot")
			. = "right foot"
		if("l_hand")
			. = "left hand"
		if("r_hand")
			. = "right hand"
