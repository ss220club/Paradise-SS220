#define isnucleation(A) (is_species(A, /datum/species/nucleation))

//MATERIAL CLASS FOR RACE EAT
#define MATERIAL_CLASS_NONE     0
#define MATERIAL_CLASS_CLOTH    1
#define MATERIAL_CLASS_TECH		2
#define MATERIAL_CLASS_SOAP		3
#define MATERIAL_CLASS_RAD		4
#define MATERIAL_CLASS_PLASMA	5

#define GADOM_BASIC_LOAD_TIMER 2 SECONDS

//Расширение прока на отстегивание ящика
/datum/species/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if((SEND_SIGNAL(H, COMSIG_GADOM_CAN_GRAB)  & GADOM_CAN_GRAB) && H.loaded)
		SEND_SIGNAL(H, COMSIG_GADOM_UNLOAD)
	. = .. ()
