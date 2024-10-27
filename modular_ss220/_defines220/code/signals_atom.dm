/// called by /obj/structure/table/do_climb() : (/datum/component/clumsy_climb)
#define COMSIG_CLIMBED_ON 	"climb_on"
/// called by /datum/emote/living/dance/run_emote() : (/datum/component/clumsy_climb)
#define COMSIG_DANCED_ON 	"dance_on"

#define COMSIG_GADOM_UNLOAD "try_unload"

#define COMSIG_SURGERY_REPAIR "surgery_carapace_shell_repair"
#define COMSIG_SURGERY_STOP "check_surgery_perform"
	#define SURGERY_STOP (1<<0)


/atom/movable/screen/alert/Click()
	if(isliving(usr) && ..())
		SEND_SIGNAL(usr, COMSIG_GADOM_UNLOAD)
