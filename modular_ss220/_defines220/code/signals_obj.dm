/// from base of [/obj/proc/atom_destruction]: (damage_flag)
#define COMSIG_OBJ_DESTRUCTION "atom_destruction"
/// called by datum/component/carapace/proc/receive_damage() : (/datum/component/carapace)
#define COMSIG_LIMB_RECEIVE_DAMAGE "receive_damage"
/// called by datum/component/carapace/proc/heal_damage() : (/datum/component/carapace)
#define COMSIG_LIMB_HEAL_DAMAGE "heal_damage"
/// called by datum/element/paired_implants/proc/synchonize_implants() : (/datum/element/paired_implants)
#define COMSIG_DOUBLEIMP_SYNCHONIZE "synchonize_implants"
/// called by datum/element/paired_implants/proc/action_rebuild() : (/datum/element/paired_implants)
#define COMSIG_DOUBLEIMP_ACTION_REBUILD "action_rebuild"
/// called by datum/component/organ_action/proc/call_actions() : (/datum/component/organ_action)
#define COMSIG_ORGAN_GROUP_ACTION_CALL "open_actions"
/// called by datum/component/organ_action/proc/resort_buttons() : (/datum/component/organ_action)
#define COMSIG_ORGAN_GROUP_ACTION_RESORT "resort_buttons"
/// called by datum/component/organ_toxin_damage/proc/tox_handle_organ() : (/datum/component/organ_toxin_damage)
#define COMSIG_ORGAN_TOX_HANDLE "tox_handle_organ"
/// called by datum/component/chemistry_organ/proc/chems_process() : (/datum/component/chemistry_organ)
#define COMSIG_ORGAN_ON_LIFE "chems_process"
/// called by datum/component/chemistry_organ/proc/chems_change_consuption() : (/datum/component/chemistry_organ)
#define COMSIG_ORGAN_CHANGE_CHEM_CONSUPTION "chems_change_consuption"
