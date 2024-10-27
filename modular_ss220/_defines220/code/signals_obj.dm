/// from base of [/obj/proc/atom_destruction]: (damage_flag)
#define COMSIG_OBJ_DESTRUCTION "atom_destruction"

#define COMSIG_LIMB_RECEIVE_DAMAGE "receive_damage"
#define COMSIG_LIMB_HEAL_DAMAGE "heal_damage"

#define COMSIG_DOUBLEIMP_SYNCHONIZE "synchonize_implants"
#define COMSIG_DOUBLEIMP_ACTION_REBUILD "action_rebuild"

#define COMSIG_ORGAN_GROUP_ACTION_CALL "open_actions"
#define COMSIG_ORGAN_GROUP_ACTION_RESORT "resort_buttons"

#define COMSIG_ORGAN_TOX_HANDLE "tox_handle_organ"

#define COMSIG_ORGAN_ON_LIFE "chems_process"
#define COMSIG_ORGAN_CHANGE_CHEM_CONSUPTION "chems_change_consuption"

//Расширение базового прока атаки для запуска сигнала атаки
/obj/item/attack(mob/living/M, mob/living/user, def_zone)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_MOB_ITEM_ATTACK, M, user, def_zone)

//Расширение проков урона и лечения для обращения к компоненту
/obj/item/organ/external/receive_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_LIMB_RECEIVE_DAMAGE, brute, burn, sharp, used_weapon, forbidden_limbs, ignore_resists, updating_health)

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0, updating_health = TRUE)
	. = ..()
	SEND_SIGNAL(src, COMSIG_LIMB_HEAL_DAMAGE, brute, burn, internal, robo_repair, updating_health)

/obj/item/organ/internal/cyberimp/arm/Retract()
	. = .. ()
	SEND_SIGNAL(src, COMSIG_DOUBLEIMP_SYNCHONIZE)

/obj/item/organ/internal/cyberimp/arm/Extend()
	. = .. ()
	SEND_SIGNAL(src, COMSIG_DOUBLEIMP_SYNCHONIZE)

/obj/item/organ/internal/insert(mob/living/carbon/M, special = 0, dont_remove_slot = 0)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_ORGAN_GROUP_ACTION_RESORT)
	SEND_SIGNAL(src, COMSIG_DOUBLEIMP_ACTION_REBUILD)

/obj/item/organ/internal/remove(mob/living/carbon/M, special = 0)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_ORGAN_GROUP_ACTION_RESORT)
	SEND_SIGNAL(src, COMSIG_DOUBLEIMP_ACTION_REBUILD)

/obj/item/organ/internal/ui_action_click()
	SEND_SIGNAL(src, COMSIG_ORGAN_GROUP_ACTION_CALL, user = owner)

/obj/item/organ/internal/process()
	SEND_SIGNAL(src, COMSIG_ORGAN_TOX_HANDLE)
	SEND_SIGNAL(src, COMSIG_ORGAN_ON_LIFE)
	. = .. ()
