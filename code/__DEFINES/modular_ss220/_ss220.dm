#define MODPACK_CHAT_BADGES

// TODO: someday preferences will use TGUI and you will probably be able to move it to modular_ss220\_defines220\code\preferences_defines.dm
/// Interacts with the toggles220 bitflag
#define PREFTOGGLE_TOGGLE220 220

/// called by /datum/component/mob_overlay_shift/proc/get_list(mob/component_holder, overlay, list/info_data) : (/datum/component/mob_overlay_shift)
#define COMSIG_MOB_GET_OVERLAY_SHIFTS_LIST "mob_get_overlay_shifts_list"

/// called by /datum/component/mob_overlay_shift/proc/get_list(mob/component_holder, overlay, list/info_data) : (/datum/component/mob_overlay_shift)
#define COMSIG_CMA_TRANSFORM "cma_transform"

/// Autolathe custom design categories
#define DESIGN_COOKWARE "Cookware"
#define DESIGN_GLASSWARE "Glassware"
#define DESIGN_CONTAINERS "Containers"
#define DESIGN_SURGICAL "Surgical Tools"
#define DESIGN_HYDROPONICAL "Hydroponical"
#define DESIGN_JANITORIAL "Janitorial"
#define DESIGN_AMMUNITION "Ammunition"
#define DESIGN_MATERIALS "Materials"
#define DESIGN_MEDICALMISC "Medical Misc."
#define DESIGN_SERVICEMISC "Service Misc."
#define DESIGN_SECURITYMISC "Security Misc."
