// Signals for /mob

/// from mob/living/Process_Spacemove(): (movement_dir)
#define COMSIG_LIVING_PROCESS_SPACEMOVE "mob_client_pre_living_move"
	#define COMPONENT_BLOCK_SPACEMOVE (1<<0)

//Вызов сигнала при экипировке любой вещи
/mob/equip_to_slot(obj/item/W, slot, initial = FALSE)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_MOB_ON_EQUIP)

//Вызов сигнала при повоторе через ctrl+wasd
/mob/facedir(ndir)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE)

//Вызов сигнала при повороте через ЛКМы
/mob/ClickOn(atom/A, params)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_MOB_ON_CLICK)
