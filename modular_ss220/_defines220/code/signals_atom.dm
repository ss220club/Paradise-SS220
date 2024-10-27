/// called by /obj/structure/table/do_climb() : (/datum/component/clumsy_climb)
#define COMSIG_CLIMBED_ON 	"climb_on"
/// called by /datum/emote/living/dance/run_emote() : (/datum/component/clumsy_climb)
#define COMSIG_DANCED_ON 	"dance_on"
/// called by /datum/emote/living/dance/run_emote() : (/datum/component/gadom_cargo) (/datum/component/gadom_living)
#define COMSIG_GADOM_UNLOAD "try_unload"
/// called by /datum/component/carapace_shell/proc/surgery_carapace_shell_repair() : (/datum/component/carapace_shell)
#define COMSIG_SURGERY_REPAIR "surgery_carapace_shell_repair"
/// called by /datum/component/carapace_shell/proc/check_surgery_perform() : (/datum/component/carapace_shell)
#define COMSIG_SURGERY_STOP "check_surgery_perform"
	#define SURGERY_STOP (1<<0)


/atom/movable/screen/alert/Click()
	if(isliving(usr) && ..())
		SEND_SIGNAL(usr, COMSIG_GADOM_UNLOAD)
