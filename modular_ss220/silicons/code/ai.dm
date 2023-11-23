// malf radio fix
/mob/living/silicon/ai/set_syndie_radio()
	if(aiRadio)
		aiRadio.ks1type = new /obj/item/encryptionkey/syndicate
		aiRadio.recalculateChannels()
