#define MODPACK_CHAT_BADGES

#ifdef SEC_LEVEL_GREEN
#undef SEC_LEVEL_GREEN
#endif
#ifdef SEC_LEVEL_BLUE
#undef SEC_LEVEL_BLUE
#endif
#ifdef SEC_LEVEL_VIOLET
#undef SEC_LEVEL_VIOLET
#endif
#ifdef SEC_LEVEL_ORANGE
#undef SEC_LEVEL_ORANGE
#endif
#ifdef SEC_LEVEL_RED
#undef SEC_LEVEL_RED
#endif
#ifdef SEC_LEVEL_GAMMA
#undef SEC_LEVEL_GAMMA
#endif
#ifdef SEC_LEVEL_EPSILON
#undef SEC_LEVEL_EPSILON
#endif
#ifdef SEC_LEVEL_DELTA
#undef SEC_LEVEL_DELTA
#endif

#define SEC_LEVEL_GREEN		0
#define SEC_LEVEL_BLUE		1
#define SEC_LEVEL_VIOLET	2
#define SEC_LEVEL_ORANGE	3
#define SEC_LEVEL_RED		4
#define SEC_LEVEL_GAMMA		5
#define SEC_LEVEL_EPSILON	6
#define SEC_LEVEL_DELTA		7

// TODO: someday preferences will use TGUI and you will probably be able to move it to modular_ss220\_defines220\code\preferences_defines.dm
/// Interacts with the toggles220 bitflag
#define PREFTOGGLE_TOGGLE220 220
