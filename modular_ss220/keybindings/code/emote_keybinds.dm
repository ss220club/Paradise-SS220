/datum/keybinding/emote/New()
	name = initial(linked_emote.name)

/datum/keybinding/emote/exercise
	linked_emote = /datum/emote/exercise

/datum/keybinding/emote/exercise/squat
	linked_emote = /datum/emote/exercise/squat

/datum/keybinding/emote/exercise/pushup
	linked_emote = /datum/emote/exercise/pushup

/datum/keybinding/emote/carbon/human/drask_talk/New()
	..()
	name += " (драск)"

/datum/keybinding/emote/carbon/human/hiss/New()
	..()
	name += " (унатх)"

/datum/keybinding/emote/carbon/human/hiss/tajaran/New()
	..()
	name = replacetext(name, regex(@"\(.*\)"), "(таяр)")

/datum/keybinding/emote/carbon/human/monkey/New()
	..()
	name += " (мартышка)"

/datum/keybinding/emote/simple_animal/diona_chirp/New()
	..()
	name += " (нимфа)"

/datum/keybinding/emote/simple_animal/gorilla_ooga/New()
	..()
	name += " (горилла)"

/datum/keybinding/emote/simple_animal/pet/dog/New()
	..()
	name += " (пёс)"

/datum/keybinding/emote/simple_animal/mouse/New()
	..()
	name += " (мышь)"

/datum/keybinding/emote/simple_animal/pet/cat/New()
	..()
	name += " (кот)"

/datum/keybinding/custom
	default_emote_text = "Введите текст вашей эмоции"

/datum/keybinding/custom/one
	name = "Своя эмоция 1"

/datum/keybinding/custom/two
	name = "Своя эмоция 2"

/datum/keybinding/custom/three
	name = "Своя эмоция 3"

/datum/keybinding/custom/four
	name = "Своя эмоция 4"

/datum/keybinding/custom/five
	name = "Своя эмоцияe 5"

/datum/keybinding/custom/six
	name = "Своя эмоция 6"

/datum/keybinding/custom/seven
	name = "Своя эмоция 7"

/datum/keybinding/custom/eight
	name = "Своя эмоция 8"

/datum/keybinding/custom/nine
	name = "Своя эмоция 9"

/datum/keybinding/custom/ten
	name = "Своя эмоция 10"
