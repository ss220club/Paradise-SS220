/*
=== Компонент запуска сердца ===
Отслеживает смерть носителя, и в случае чего - запускает сердце с неким шансом
*/
#define AUTO_DEFIBRILATION_THRESHOLD 100
/datum/component/defib_heart_chemical
	var/chemical_id = ""
	var/obj/item/organ/internal/organ

/datum/component/defib_heart_chemical/Initialize(income_chemical_id = "")
	chemical_id = income_chemical_id
	organ = parent
	START_PROCESSING(SSdcs, src)

/datum/component/defib_heart_chemical/Destroy(force, silent)
	STOP_PROCESSING(SSdcs, src)
	. = ..()

/datum/component/defib_heart_chemical/process()
	var/mob/living/carbon/human/owner = organ.owner
	if(!owner)
		var/obj/item/organ/internal/limb = parent
		owner = limb.owner
	if(!owner)
		qdel(src)
	if(owner?.get_chemical_value(chemical_id) < 0 || owner.stat != DEAD || owner.get_damage_amount() > AUTO_DEFIBRILATION_THRESHOLD)
		return
	var/defib_chance = owner?.get_chemical_value(chemical_id)
	var/datum/reagent/chem = owner?.get_chemical_path(chemical_id)
	if(chem)
		chem.holder.remove_reagent(chemical_id, owner?.get_chemical_value(chemical_id))
		if(prob(defib_chance))
			owner.setOxyLoss(0)
			owner.set_heartattack(FALSE)
			owner.update_revive()
			owner.KnockOut()
			owner.Paralyse(10 SECONDS)
			owner.emote("gasp")
			SEND_SIGNAL(owner, COMSIG_LIVING_MINOR_SHOCK, 100)
			owner.med_hud_set_health()
			owner.med_hud_set_status()
			add_attack_logs(owner, owner, "Revived by heart")
			SSblackbox.record_feedback("tally", "players_revived", 1, "self_revived")
