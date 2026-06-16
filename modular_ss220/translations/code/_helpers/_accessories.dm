/proc/russian_accessory_list(obj/item/clothing/under/U)
	if(!istype(U) || !length(U.accessories))
		return

	var/list/A = U.accessories
	var/total = length(A)

	if(total == 1)
		var/obj/item/clothing/accessory/acc1 = A[1]
		return acc1.declent_ru(ACCUSATIVE)

	else if(total == 2)
		var/obj/item/clothing/accessory/acc1 = A[1]
		var/obj/item/clothing/accessory/acc2 = A[2]
		return "[acc1.declent_ru(ACCUSATIVE)] и [acc2.declent_ru(ACCUSATIVE)]"

	else
		var/output = ""
		var/index = 1

		while(index < total)
			var/obj/item/clothing/accessory/acc = A[index]
			output += "[acc.declent_ru(ACCUSATIVE)], "
			index++

		var/obj/item/clothing/accessory/last_acc = A[index]
		return "[output][last_acc.declent_ru(ACCUSATIVE)]"
