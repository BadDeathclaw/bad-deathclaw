/datum/job/captain
	title = "Overseer"
	flag = OVERSEER
	department_head = list("Centcom")
	department_flag = VAULT
	faction = "Vault"
	status = "Overseer"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Vault-tec"
	selection_color = "#005A20"
	req_admin_notify = 1
	minimal_player_age = 14
//	donaters = 1
//	donatorrank = 3
	outfit = /datum/outfit/job/captain

	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()

/datum/job/captain/get_access()
	return get_all_accesses()


/datum/outfit/job/captain
	name = "Overseer"

	id = /obj/item/weapon/card/id/gold
	gloves = /obj/item/clothing/gloves/pda/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	ears = /obj/item/device/radio/headset/headset_vlt
	shoes = /obj/item/clothing/shoes/jackboots
	//gloves = /obj/item/clothing/gloves/color/captain
	uniform = /obj/item/clothing/under/f13/vault/v13
	//suit = /obj/item/clothing/suit/armor/vest/capcarapace
	shoes = /obj/item/clothing/shoes/sneakers/brown
	//head = /obj/item/clothing/head/caphat
	backpack_contents = list(/obj/item/weapon/storage/box/ids=1,\
		/obj/item/weapon/melee/classic_baton/telescopic=1)

	//backpack = /obj/item/weapon/storage/backpack/captain
	//satchel = /obj/item/weapon/storage/backpack/satchel_cap

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	//var/obj/item/clothing/under/U = H.w_uniform
	//U.attachTie(new /obj/item/clothing/tie/medal/gold/captain())

	if(visualsOnly)
		return

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1
	H.sec_hud_set_implants()
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

/datum/job/engineer
	title = "Engineer"
	flag = ENGINEER
	department_head = list("Chief Engineer")
	department_flag = VAULT
	faction = "Vault"
	status = "Dweller"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Overseer"
	selection_color = "#005A20"

	outfit = /datum/outfit/job/engineer

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_atmospherics, access_tcomsat)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
									access_external_airlocks, access_construction, access_tcomsat)

/datum/outfit/job/engineer
	name = "Engineer"

	gloves = /obj/item/clothing/gloves/pda/engineering
	ears = /obj/item/device/radio/headset/headset_vlt
	uniform = /obj/item/clothing/under/f13/vault/v13
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/hardhat
	r_pocket = /obj/item/device/t_scanner

	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel = /obj/item/weapon/storage/backpack/satchel_eng
	box = /obj/item/weapon/storage/box/engineer
	pda_slot = slot_l_store

/datum/outfit/job/engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

/datum/job/doctor
	title = "Doctor"
	flag = DOCTOR
	department_head = list("Chief Medical Officer")
	department_flag = VAULT
	faction = "Vault"
	status = "Dweller"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Overseer"
	selection_color = "#005A20"

	outfit = /datum/outfit/job/doctor

	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_mineral_storeroom)
	minimal_access = list(access_medical, access_morgue, access_surgery)

/datum/outfit/job/doctor
	name = "Doctor"

	gloves = /obj/item/clothing/gloves/pda/medical
	ears = /obj/item/device/radio/headset/headset_vlt
	uniform = /obj/item/clothing/under/f13/vault/v13
	shoes = /obj/item/clothing/shoes/jackboots
	suit =  /obj/item/clothing/suit/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	suit_store = /obj/item/device/flashlight/pen

	backpack = /obj/item/weapon/storage/backpack/medic
	satchel = /obj/item/weapon/storage/backpack/satchel_med

/datum/outfit/job/doctor/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department_head = list("Research Director")
	department_flag = VAULT
	faction = "Vault"
	status = "Dweller"
	total_positions = 2
	spawn_positions = 2
	supervisors = "Overseer"
	selection_color = "#005A20"

	outfit = /datum/outfit/job/scientist

	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_mineral_storeroom, access_tech_storage, access_genetics)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_mineral_storeroom)

/datum/outfit/job/scientist
	name = "Scientist"

	gloves = /obj/item/clothing/gloves/pda/toxins
	ears = /obj/item/device/radio/headset/headset_vlt
	uniform = /obj/item/clothing/under/f13/vault/v13
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/toggle/labcoat/science

/datum/outfit/job/scientist/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

/datum/job/officer
	title = "Officer"
	flag = OFFICER
	department_head = list("Overseer")
	department_flag = VAULT
	faction = "Vault"
	status = "Dweller"
	total_positions = 4 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	spawn_positions = 4 //Handled in /datum/controller/occupations/proc/setup_officer_positions()
	supervisors = "the head of security, and the head of your assigned department (if applicable)"
	selection_color = "#005A20"
	minimal_player_age = 7

	outfit = /datum/outfit/job/security

	access = list(access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue, access_weapons, access_forensics_lockers)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_court, access_weapons) //But see /datum/job/warden/get_access()

/datum/job/officer/get_access()
	var/list/L = list()
	L |= ..() | check_config_for_sec_maint()
	return L

/datum/outfit/job/officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

var/list/sec_departments = list("engineering", "supply", "medical", "science")

/datum/outfit/job/security
	name = "Officer"

	gloves = /obj/item/clothing/gloves/pda/security
	ears = /obj/item/device/radio/headset/headset_vlt
	uniform = /obj/item/clothing/under/f13/vault/v13
	//gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/helmet/riot/vaultsec
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/jackboots
	l_pocket = /obj/item/device/assembly/flash/handheld
	backpack_contents = list(/obj/item/weapon/melee/classic_baton/telescopic=1,\
		/obj/item/weapon/restraints/handcuffs=1)

	backpack = /obj/item/weapon/storage/backpack/security
	satchel = /obj/item/weapon/storage/backpack/satchel_sec

	var/department = null
	var/tie = null
	var/list/dep_access = null
	var/destination = null
	var/spawn_point = null

/datum/outfit/job/security/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(sec_departments.len)
		department = pick(sec_departments)
		if(!visualsOnly)
			sec_departments -= department
		switch(department)
			if("supply")
				//ears = /obj/item/device/radio/headset/headset_sec/alt/department/supply
				dep_access = list(access_mailsorting, access_mining)
				destination = /area/security/checkpoint/supply
				spawn_point = locate(/obj/effect/landmark/start/depsec/supply) in department_security_spawns
				tie = /obj/item/clothing/tie/armband/cargo
			if("engineering")
				//ears = /obj/item/device/radio/headset/headset_sec/alt/department/engi
				dep_access = list(access_construction, access_engine)
				destination = /area/security/checkpoint/engineering
				spawn_point = locate(/obj/effect/landmark/start/depsec/engineering) in department_security_spawns
				tie = /obj/item/clothing/tie/armband/engine
			if("medical")
				//ears = /obj/item/device/radio/headset/headset_sec/alt/department/med
				dep_access = list(access_medical)
				destination = /area/security/checkpoint/medical
				spawn_point = locate(/obj/effect/landmark/start/depsec/medical) in department_security_spawns
				tie =  /obj/item/clothing/tie/armband/medblue
			if("science")
				//ears = /obj/item/device/radio/headset/headset_sec/alt/department/sci
				dep_access = list(access_research)
				destination = /area/security/checkpoint/science
				spawn_point = locate(/obj/effect/landmark/start/depsec/science) in department_security_spawns
				tie = /obj/item/clothing/tie/armband/science

/datum/outfit/job/security/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	var/obj/item/clothing/under/U = H.w_uniform
	if(tie)
		U.attachTie(new tie)

	if(visualsOnly)
		return

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1
	H.sec_hud_set_implants()

	var/obj/item/weapon/card/id/W = H.wear_id
	W.access |= dep_access

	var/teleport = 0
	if(!config.sec_start_brig)
		if(destination || spawn_point)
			teleport = 1
	if(teleport)
		var/turf/T
		if(spawn_point)
			T = get_turf(spawn_point)
			H.Move(T)
		else
			var/safety = 0
			while(safety < 25)
				T = safepick(get_area_turfs(destination))
				if(T && !H.Move(T))
					safety += 1
					continue
				else
					break
	H << "<b>You have been assigned to [department]!</b>"
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

/obj/item/device/radio/headset/headset_sec/department/New()
	wires = new(src)
	secure_radio_connections = new

	initialize()
	recalculateChannels()

/obj/item/device/radio/headset/headset_sec/alt/department/engi
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_eng

/obj/item/device/radio/headset/headset_sec/alt/department/supply
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_cargo

/obj/item/device/radio/headset/headset_sec/alt/department/med
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_med

/obj/item/device/radio/headset/headset_sec/alt/department/sci
	keyslot = new /obj/item/device/encryptionkey/headset_sec
	keyslot2 = new /obj/item/device/encryptionkey/headset_sci

/datum/job/assistant
	title = "Dweller"
	flag = DWELLER
	department_flag = VAULT
	faction = "Vault"
	status = "Dweller"
	total_positions = 8
	spawn_positions = -1
	supervisors = "Overseer"
	selection_color = "#005A20"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	late_join = 1

/datum/job/assistant/get_access()
	if((config.jobs_have_maint_access & ASSISTANTS_HAVE_MAINT_ACCESS) || !config.jobs_have_minimal_access) //Config has assistant maint access set
		. = ..()
		. |= list(access_maint_tunnels)
	else
		return ..()

/datum/job/assistant/config_check()
	if(config && !(config.assistant_cap == 0))
		total_positions = config.assistant_cap
		spawn_positions = config.assistant_cap
		return 1
	return 0


/datum/outfit/job/assistant/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	H << "Being a vault employee, you have certain rules to abide by, please take the time to read the following. \
	I. The Vault Rules \
	0. The vault has no knowledge of the outside world, including if it is safe or not to open their doors which must stay closed. \
	1. The way they act, depends on the Overseer and his directives. \
	2. The Wasteland is a big scary place for the Vault Dwellers, so expect to roleplay as a character completely scared of the Wasteland and biased to the Vault as years of /Vault propaganda/ and listen to the Overseer. \
	Dwellers shouldnt rebel, unless if something/certain someone (i.e Overseer and his decisions) threatens their precious lives. \
	3. Officers are supposed to keep the Dwellers safe, and only neutralize those that pose an actual threat. Those who don’t and are convicted of minor crimes, are to head to the Brig to serve time. \
	4. Leaving the Vault is not allowed unless you have absolutely no other option. \
	J. Lowpop, Continuity and Cloning.\
	4. When cloned, the time you were scanned is the point you remember from. You will not recall who killed you, or even current information. \
	When cloned via pod-people means, you are functionally a new person, having only the personality and traits of the person recreated, \
	without their memory. Roleplay Appropriately!"

/datum/outfit/job/assistant
	name = "Dweller"

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = /obj/item/clothing/under/f13/vault/v13
	gloves = /obj/item/clothing/gloves/pda
	ears = /obj/item/device/radio/headset/headset_vlt
	shoes = /obj/item/clothing/shoes/jackboots
/datum/job/proc/check_config_for_sec_maint()
	if(config.jobs_have_maint_access & SECURITY_HAS_MAINT_ACCESS)
		return list(access_maint_tunnels)
	return list()
