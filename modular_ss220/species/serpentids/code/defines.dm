#define SERPENTID_CHEM_REAGENT_ID "msg"

#define SERPENTID_CARAPACE_NOARMOR_STATE 60
#define SERPENTID_CARAPACE_NOCHAMELION_STATE 30
#define SERPENTID_CARAPACE_NOPRESSURE_STATE 90

#define SERPENTID_GENE_DEGRADATION_DAMAGE 0.5
#define SERPENTID_GENE_DEGRADATION_CD 60

#define SERPENTID_HEAT_THRESHOLD_LEVEL_BASE 350
#define SERPENTID_HEAT_THRESHOLD_LEVEL_UP 50
#define SERPENTID_ARMORED_HEAT_THRESHOLD 380

#define SERPENTID_COLD_THRESHOLD_LEVEL_BASE 250
#define SERPENTID_COLD_THRESHOLD_LEVEL_DOWN 80
#define SERPENTID_ARMORED_COLD_THRESHOLD 0

#define GAS_ORGAN_CHEMISTRY_LUNGS 1
#define GAS_ORGAN_CHEMISTRY_KIDNEYS 0.5
#define GAS_ORGAN_CHEMISTRY_EYES 0.01
#define GAS_ORGAN_CHEMISTRY_EARS 0.01

#define SERPENTID_CHEM_MULT_CONSUPTION 0.75
#define SERPENTID_CHEM_MULT_PRODUCTION 0.6

#define SERPENTID_EYES_LOW_VISIBLE_VALUE 0.7
#define SERPENTID_EYES_MAX_VISIBLE_VALUE 1

#define GAS_ORGAN_CHEMISTRY_MAX 100

#define SPIECES_BAN_HEADS_JOB (1<<12)

/datum/species
	var/can_buckle = FALSE
	var/buckle_lying = TRUE
	var/eyes_icon = 'icons/mob/human_face.dmi'
	var/face_icon = 'icons/mob/human_face.dmi'
	var/face_icon_state = "bald_s"
	var/action_mult = 1
	var/equipment_black_list = list()
	var/butt_sprite_icon = 'icons/obj/butts.dmi'

//Добавление новых алертов
/atom/movable/screen/alert/carapace_break_armor
	name = "Слабые повреждения панциря."
	desc = "Ваш панцирь поврежден. Нарушение целостности снизило сопротивление урону."
	icon_state = "carapace_break_armor"
	icon = 'modular_ss220/species/serpentids/icons/screen_alert.dmi'

/atom/movable/screen/alert/carapace_break_cloak
	name = "Средние повреждения панциря"
	desc = "Ваш панцирь поврежден. Нарушения целостности лишило вас возможность скрывать себя."
	icon_state = "carapace_break_cloak"
	icon = 'modular_ss220/species/serpentids/icons/screen_alert.dmi'

/atom/movable/screen/alert/carapace_break_rig
	name = "Сильные повреждения панциря"
	desc = "Ваш панцирь поврежден. Нарушения целостности лишило вас сопротивлению окружающей среде."
	icon_state = "carapace_break_rig"
	icon = 'modular_ss220/species/serpentids/icons/screen_alert.dmi'

//Обновление иконок для кастомных рас
/datum/character_save/update_preview_icon(for_observer=0)
	. = .. ()
	var/datum/species/selected_specie = GLOB.all_species[species]

	//Это ужасно,но так можно кастомным расам выдавать кастомные глаза (я хз, почему сработало так, нужны разьяснения)
	var/icon/face_s = new/icon("icon" = selected_specie.eyes_icon, "icon_state" = selected_specie.eyes)
	if(!(selected_specie.bodyflags & NO_EYES))
		var/icon/eyes_s = new/icon("icon" = selected_specie.eyes_icon, "icon_state" = selected_specie ? selected_specie.eyes : "eyes_s")
		eyes_s.Blend(e_colour, ICON_ADD)
		face_s.Blend(eyes_s, ICON_OVERLAY)

	preview_icon.Blend(face_s, ICON_OVERLAY)
	preview_icon_front = new(preview_icon, dir = SOUTH)
	preview_icon_side = new(preview_icon, dir = WEST)

//Прок на получение иконки глаз кастомных рас (перезапись, возможно стоит расширить?)
/mob/living/carbon/human/get_eyecon()
	var/obj/item/organ/internal/eyes/eyes = get_int_organ(/obj/item/organ/internal/eyes)
	if(istype(dna.species) && dna.species.eyes)
		var/icon/eyes_icon
		if(eyes)
			eyes_icon = eyes.generate_icon()
		else //Error 404: Eyes not found!
			eyes_icon = new(dna.species.eyes_icon, dna.species.eyes)//eyes_icon = new('modular_ss220/species/serpentids/icons/mob/r_serpentid_eyes.dmi', "serp_eyes_s")//
			eyes_icon.Blend("#800000", ICON_ADD)

		return eyes_icon

/mob/living/carbon/human/proc/emote_gbsroar()
	set name = "< " + EMOTE_HUMAN_ROAR + " >"
	set category = "Эмоции"
	emote("gbsroar", intentional = TRUE)

/mob/living/carbon/human/proc/emote_gbshiss()
	set name = "< " + EMOTE_HUMAN_HISS + " >"
	set category = "Эмоции"
	emote("gbshiss", intentional = TRUE)

/mob/living/carbon/human/proc/emote_gbswhip()
	set name = "< " + EMOTE_HUMAN_WHIP + " >"
	set category = "Эмоции"
	emote("gbswhip", intentional = TRUE)

/mob/living/carbon/human/proc/emote_gbswhips()
	set name = "< " + EMOTE_HUMAN_WHIPS + " >"
	set category = "Эмоции"
	emote("gbswhips", intentional = TRUE)

/mob/living/carbon/human/proc/emote_gbswiggles()
	set name = "< " + EMOTE_HUMAN_WIGGLES + " >"
	set category = "Эмоции"
	emote("gbswiggles", intentional = TRUE)

/datum/emote/living/carbon/human/roar/gbs
	key = "gbsroar"
	key_third_person = "roar"
	message = "утробно рычит."
	message_mime = "бесшумно рычит."
	message_param = "утробно рычит на %t."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	volume = 50
	muzzled_noises = list("раздражённый")
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH | EMOTE_AUDIBLE
	age_based = TRUE

/datum/emote/living/carbon/human/roar/gbs/get_sound(mob/living/user)
	return pick(
		'modular_ss220/species/serpentids/sounds/serpentid_roar.ogg')

/datum/emote/living/carbon/human/hiss/gbs/
	key = "gbshiss"
	key_third_person = "hisses"
	message = "шипит."
	message_param = "шипит на %t."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH
	age_based = TRUE
	// Credit to Jamius (freesound.org) for the sound.
	sound = "modular_ss220/species/serpentids/sounds/serpentid_hiss.ogg"
	muzzled_noises = list("weak hissing")

/datum/emote/living/carbon/human/whip/gbs
	key = "gbswhip"
	key_third_person = "whip"
	message = "гремит хвостом."
	message_mime = "взмахивает хвостом и трясет кончиком в воздухе."
	message_postfix = ", грозно смотря на %t."
	message_param = EMOTE_PARAM_USE_POSTFIX
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	volume = 75
	audio_cooldown = 3 SECONDS
	sound = 'modular_ss220/emotes/audio/unathi/whip_short_unathi.ogg'

/datum/emote/living/carbon/human/whip/whip_l/gbs
	key = "gbswhips"
	key_third_person = "whips"
	message = "хлестает хвостом."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	audio_cooldown = 6 SECONDS
	sound = 'modular_ss220/emotes/audio/unathi/whip_unathi.ogg'

/datum/emote/living/carbon/human/wiggles/gbs
	key = "wiggles"
	key_third_person = "wiggles"
	message = "шевелит усиками."
	message_param = "шевелит усиками в сторону %t."
	cooldown = 5 SECONDS
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE | EMOTE_MOUTH
	age_based = TRUE
	volume = 80
	muzzled_noises = list("слабо")
	sound = 'modular_ss220/species/serpentids/sounds/serpentid_wiggle.ogg'

//не-не, я понмаю, что это не сюда, но!
/obj/machinery/photocopier/copyass(scanning = FALSE)
	if(!scanning) //If we're just storing this as a file inside the copier then we don't expend toner
		if(toner < 5)
			visible_message("<span class='notice'>A yellow light on [src] flashes, indicating there's not enough toner to finish the operation.</span>")
			return null
		total_copies++

	var/icon/temp_img

	if(emagged)
		if(ishuman(copymob))
			var/mob/living/carbon/human/H = copymob
			var/obj/item/organ/external/G = H.get_organ("groin")
			G.receive_damage(0, 30)
			H.emote("scream")
		else
			copymob.apply_damage(30, BURN)
		to_chat(copymob, "<span class='notice'>Something smells toasty...</span>")
	if(ishuman(copymob)) //Suit checks are in check_mob
		var/mob/living/carbon/human/H = copymob
		temp_img = icon(H.dna.species.butt_sprite_icon, H.dna.species.butt_sprite)
	else if(isdrone(copymob))
		temp_img = icon('icons/obj/butts.dmi', "drone")
	else if(isnymph(copymob))
		temp_img = icon('icons/obj/butts.dmi', "nymph")
	else if(isalien(copymob) || istype(copymob,/mob/living/simple_animal/hostile/alien)) //Xenos have their own asses, thanks to Pybro.
		temp_img = icon('icons/obj/butts.dmi', "xeno")
	else
		return
	var/obj/item/photo/p = new /obj/item/photo (loc)
	if(scanning)
		p.forceMove(src)
	else if(folder)
		p.forceMove(folder)
	p.desc = "You see [copymob]'s ass on the photo."
	p.pixel_x = rand(-10, 10)
	p.pixel_y = rand(-10, 10)
	p.img = temp_img
	var/icon/small_img = icon(temp_img) //Icon() is needed or else temp_img will be rescaled too >.>
	var/icon/ic = icon('icons/obj/items.dmi',"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	p.icon = ic
	return p
