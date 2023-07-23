// Signals for /mob/living
/// from living/Life(). (deltatime, times_fired)
#define COMSIG_LIVING_LIFE "living_life"

/// from living/handle_critical_condition.
#define COMSIG_LIVING_HANDLE_CRITICAL_CONDITION "living_handle_critical_condition"

/// from living/handle_message_mode. (message_mode, message_pieces, verb, used_radios)
#define COMSIG_LIVING_HANDLE_MESSAGE_MODE "living_handle_message_mode"
	#define COMPONENT_FORCE_WHISPER (1<<0)

#define COMSIG_MOB_PIXEL_SHIFT_KEYBIND "mob_pixel_shift_keybind"
#define COMSIG_MOB_PIXEL_SHIFT "mob_pixel_shift"
#define COMSIG_MOB_UNPIXEL_SHIFT "mob_unpixel_shift"
#define COMSIG_MOB_PIXEL_SHIFT_PASSABLE "mob_pixel_shift_passable"
#define COMSIG_MOB_PIXEL_SHIFTING "mob_pixel_shifting"

#define COMPONENT_LIVING_PASSABLE (1<<0)
#define COMPONENT_LIVING_PIXEL_SHIFTING (1<<0)
