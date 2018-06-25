// Enclave

/datum/job/remnantmedic
	title = "US Medic"
	flag = USMEDIC
	department_head = list("Commander")
	department_flag = REMNANTS
	faction = "Remnants"
	status = "US Medic"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Commander"
	selection_color = "#f41414"
	minimal_player_age = 7
	outfit = /datum/outfit/remnants/medic

	access = list(73)
	minimal_access = list(73)

/datum/job/remnantsprivate
	title = "US Private"
	flag = USPRIVATE
	department_head = list("Commander")
	department_flag = REMNANTS
	faction = "Remnants"
	status = "US Private"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Commander"
	selection_color = "#f41414"
	minimal_player_age = 7
	outfit = /datum/outfit/remnants/private

	access = list(73)
	minimal_access = list(73)

/datum/job/remnantscientist
	title = "US Scientist"
	flag = USSCIENTIST
	department_head = list("Commander")
	department_flag = REMNANTS
	faction = "Remnants"
	status = "US Scientist"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Commander"
	selection_color = "#f41414"
	minimal_player_age = 7
	outfit = /datum/outfit/remnants/scientist

	access = list(73)
	minimal_access = list(73)

/datum/job/remnantsengineer
	title = "US Engineer"
	flag = USENGINEER
	department_head = list("Commander")
	department_flag = REMNANTS
	faction = "Remnants"
	status = "US Engineer"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Commander"
	selection_color = "#f41414"
	minimal_player_age = 7
	outfit = /datum/outfit/remnants/engineer

	access = list(73)
	minimal_access = list(73)

/datum/job/remnantscommander
	title = "US Commander"
	flag = USCOMMANDER
	department_head = list("Commander")
	department_flag = REMNANTS
	faction = "Remnants"
	status = "US Commander"
	total_positions = 1
	spawn_positions = 1
	supervisors = "President"
	selection_color = "#f41414"
	minimal_player_age = 7
	outfit = /datum/outfit/remnants/commander

	access = list(73)
	minimal_access = list(73)

//datum/job/enclavecolonist
//	title = "US Colonist"
//	flag = USCOLONIST
//	department_head = list("US Commander")
//	department_flag = ENCLAVE
//	faction = "Enclave"
//	status = "Colonist"
//	total_positions = -1
//	spawn_positions = -1
//	supervisors = "Commander"
//	selection_color = "#ffddf0"
//	minimal_player_age = 7
//	donaters = 1
//	donatorrank = 5
//	outfit = /datum/outfit/space

//	access = list(73)
//	minimal_access = list(73)



/datum/outfit/remnants/medic
	name = "US Medic"
	uniform = /obj/item/clothing/under/f13/bdu
	id = /obj/item/weapon/card/id/remnants
	suit = /obj/item/clothing/suit/toggle/labcoat
	glasses = /obj/item/clothing/glasses/hud/health
	back = /obj/item/weapon/storage/backpack/medic
	belt = /obj/item/weapon/storage/belt/medical
	r_hand = /obj/item/weapon/storage/firstaid/regular
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer=1,\
		/obj/item/weapon/reagent_containers/hypospray/combat=1,\
		/obj/item/weapon/gun/medbeam=1)

/datum/outfit/remnants/scientist
	name = "US Scientist"
	uniform = /obj/item/clothing/under/f13/bdu
	id = /obj/item/weapon/card/id/remnants
	suit = /obj/item/clothing/suit/toggle/labcoat
	glasses = /obj/item/clothing/glasses/science
	back = /obj/item/weapon/storage/backpack/science
	r_hand = /obj/item/weapon/storage/firstaid/regular
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer=1,\
		/obj/item/weapon/stock_parts/cell/ammo/ec)

/datum/outfit/remnants/engineer
	name = "US Engineer"
	uniform = /obj/item/clothing/under/f13/bdu
	id = /obj/item/weapon/card/id/remnants
	suit = /obj/item/clothing/suit/hazardvest
	glasses =  /obj/item/clothing/glasses/meson/engine
	back = /obj/item/weapon/storage/backpack/industrial
	belt = /obj/item/weapon/storage/belt/utility/full
	l_pocket = /obj/item/weapon/rcd_ammo/large
	r_hand = /obj/item/weapon/storage/firstaid/regular
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/melee/baton/loaded=1,\
		/obj/item/clothing/mask/gas/sechailer=1,\
		/obj/item/weapon/rcd/loaded=1)

/datum/outfit/remnants/private
	name = "US Private"
	uniform = /obj/item/clothing/under/f13/dbdu
	id = /obj/item/weapon/card/id/remnants
	glasses = /obj/item/clothing/glasses/night
	back = /obj/item/weapon/storage/backpack/combat_ruck
	r_hand = /obj/item/weapon/gun/energy/laser/plasma
	head = /obj/item/clothing/head/f13/utilityp
	backpack_contents = list(/obj/item/weapon/stock_parts/cell/ammo/mfc=2)

/datum/outfit/remnants/commander
	name = "US Commander"
	uniform = /obj/item/clothing/under/f13/obdu
	id = /obj/item/weapon/card/id/remnants
	r_hand = /obj/item/weapon/gun/energy/laser/plasma
	head = /obj/item/clothing/head/f13/utilityo
	l_pocket = /obj/item/weapon/stock_parts/cell/ammo/ec
	r_pocket = /obj/item/weapon/lighter/gold
	mask = /obj/item/clothing/mask/cigarette/cigar


/datum/outfit/remnants
	name = "Enclave - Basic"
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	back = /obj/item/weapon/storage/backpack
	ears = /obj/item/device/radio/headset/headset_enclave
	id = /obj/item/weapon/card/id/remnants
	belt = /obj/item/weapon/gun/energy/laser/plasma/pistol
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1)

/datum/outfit/remnants/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	H.faction = ("Remnants")
	var/datum/martial_art/patraining/F = new/datum/martial_art/patraining(null)
	F.teach(H)
	if(visualsOnly)
		return



/datum/outfit/remnants/full
	name = "Enclave - Full Kit"
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/syndicate
	suit = /obj/item/clothing/suit/space/hardsuit/syndi
	l_pocket = /obj/item/weapon/tank/internals/emergency_oxygen/engi
	r_pocket = /obj/item/weapon/gun/projectile/automatic/pistol
	belt = /obj/item/weapon/storage/belt/military
	r_hand = /obj/item/weapon/gun/projectile/automatic/shotgun/bulldog
	backpack_contents = list(/obj/item/weapon/storage/box/engineer=1,\
		/obj/item/weapon/tank/jetpack/oxygen/harness=1,\
		/obj/item/weapon/pinpointer/nukeop=1)


/datum/outfit/remnants/full/post_equip(mob/living/carbon/human/H)
	..()


	var/obj/item/clothing/suit/space/hardsuit/syndi/suit = H.wear_suit
	suit.ToggleHelmet()
	var/obj/item/clothing/head/helmet/space/hardsuit/syndi/helmet = H.head
	helmet.attack_self(H)
