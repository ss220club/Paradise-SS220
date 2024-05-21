## Title: Thirst meter

### Description:

Add the thirst for mobs and requirements to drink water. Stay hydrated!

### Modified files:

code/**DEFINES/genetics.dm - added defines for thirst
code/**DEFINES/mobs.dm - added define for default thirst factor
code/modules/mob/living/carbon/human/examine.dm - added additional examine text for dehydrated mob
code/modules/mob/living/carbon/human/species/\_species.dm - added slowdown modifier while dehydrated

No Thirst species:
code/modules/mob/living/carbon/human/species/abductor.dm
code/modules/mob/living/carbon/human/species/golem.dm
code/modules/mob/living/carbon/human/species/machine.dm
code/modules/mob/living/carbon/human/species/plasmaman.dm
code/modules/mob/living/carbon/human/species/shadowling.dm
code/modules/mob/living/carbon/human/species/skeleton.dm
code/modules/mob/living/carbon/human/species/grey.dm
code/modules/mob/living/carbon/human/species/vox.dm

### Credits:

Larentoun - Owner
