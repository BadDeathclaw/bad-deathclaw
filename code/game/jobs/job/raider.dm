/*
Raider
*/
/datum/job/raider
	title = "Raider"
	flag = RAIDER
	department_flag = WASTELAND
	faction = "Wasteland" //desert faction shall disable appearing as scavenger after readying
	status = "Raider"
	total_positions = 3
//	donaters = 1
//	donatorrank = 1
	spawn_positions = -1 //does not matter for late join
	supervisors = "nobody"
	selection_color = "#dddddd"
	access = list()
	minimal_access = list()
	outfit = /datum/outfit/job/raider

/datum/outfit/job/raider
	name = "Raider"
	id = null
	ears = null
	belt = null
	backpack = null
	satchel = null

/datum/outfit/job/raider/pre_equip(mob/living/carbon/human/H)
	..()

	suit_store = pick(/obj/item/weapon/gun/projectile/revolver/single_shotgun,\
		/obj/item/weapon/gun/projectile/revolver/caravan_shotgun)
	uniform = pick(/obj/item/clothing/under/f13/mercadv,\
		/obj/item/clothing/under/fluff/villain,\
		/obj/item/clothing/under/female/blacktango,\
		/obj/item/clothing/under/f13/cowboyb,\
		/obj/item/clothing/under/female/wedding/bride_red,\
		/obj/item/clothing/under/f13/doctor,\
		/obj/item/clothing/under/f13/cowboyg,\
		/obj/item/clothing/under/f13/caravaneer,\
		/obj/item/clothing/under/f13/machinist,\
		/obj/item/clothing/under/f13/lumberjack,\
		/obj/item/clothing/under/f13/female/flapper,\
		/obj/item/clothing/under/f13/combat,\
		/obj/item/clothing/under/f13/greatkhan,\
		/obj/item/clothing/under/f13/ranger,\
		/obj/item/clothing/under/f13/tribalwearf,\
		/obj/item/clothing/under/f13/tribalwear,\
		/obj/item/clothing/under/f13/enclaveo,\
		/obj/item/clothing/under/f13/settler,\
		/obj/item/clothing/under/f13/roving,\
		/obj/item/clothing/under/roman,\
		/obj/item/clothing/under/f13/merccharm)
	shoes = /obj/item/clothing/shoes/jackboots
	suit = pick(/obj/item/clothing/head/helmet/f13/raider,\
		/obj/item/clothing/suit/fluff/cowboybvest,\
		/obj/item/clothing/suit/fluff/cowboygvest,\
		/obj/item/clothing/suit/fluff/battlecruiser,\
		/obj/item/clothing/suit/fluff/vest,\
		/obj/item/clothing/suit/armor/fluff/chestplate,\
		/obj/item/clothing/suit/f13/veteran,\
		/obj/item/clothing/suit/f13/duster,\
		/obj/item/clothing/suit/f13/autumn,\
		/obj/item/clothing/suit/poncho,\
		/obj/item/clothing/suit/poncho/green,\
		/obj/item/clothing/suit/poncho/ponchoshame,\
		/obj/item/clothing/suit/poncho/red,\
		/obj/item/clothing/suit/det_suit/grey,\
		/obj/item/clothing/suit/det_suit,\
		/obj/item/clothing/suit/chickensuit,\
		/obj/item/clothing/suit/bomb_suit,\
		/obj/item/clothing/suit/bomb_suit/security,\
		/obj/item/clothing/suit/bio_suit/security,\
		/obj/item/clothing/suit/apron/chef,\
		/obj/item/clothing/suit/apron/overalls,\
		/obj/item/clothing/suit/straight_jacket,\
		/obj/item/clothing/suit/toggle/labcoat/mad,\
		/obj/item/clothing/suit/pirate,\
		/obj/item/clothing/suit/cardborg,\
		/obj/item/clothing/suit/armor/f13/bmetalarmor,\
		/obj/item/clothing/suit/armor/f13/raider/yankee, \
		/obj/item/clothing/suit/armor/f13/raider/sadist, \
		/obj/item/clothing/suit/armor/f13/raider/blastmaster)
	head = pick(/obj/item/clothing/head/helmet/f13/raider,\
		/obj/item/clothing/head/helmet/f13/eyebot,\
		/obj/item/clothing/head/helmet/f13/brokenpa/t45d,\
		/obj/item/clothing/head/chicken,\
		/obj/item/clothing/head/hardhat,\
		/obj/item/clothing/head/santa,\
		/obj/item/clothing/head/helmet/roman,\
		/obj/item/clothing/head/helmet/gladiator,\
		/obj/item/clothing/head/helmet/bluetaghelm,\
		/obj/item/clothing/head/helmet/redtaghelm,\
		/obj/item/clothing/head/festive,\
		/obj/item/clothing/head/canada,\
		/obj/item/clothing/head/cardborg,\
		/obj/item/clothing/head/bio_hood/security,\
		/obj/item/clothing/head/bandana,\
		/obj/item/clothing/head/welding,\
		/obj/item/clothing/head/sombrero,\
		/obj/item/clothing/head/sombrero/green,\
		/obj/item/clothing/head/sombrero/shamebrero,\
		/obj/item/clothing/head/welding/fluff/japan,\
		/obj/item/clothing/head/welding/fluff/fire,\
		/obj/item/clothing/head/pirate,\
		/obj/item/clothing/head/rice_hat,\
		/obj/item/clothing/head/jester,\
		/obj/item/clothing/head/cone,\
		/obj/item/clothing/head/helmet/f13/raider/arclight,\
		/obj/item/clothing/head/helmet/f13/raider/blastmaster,\
		/obj/item/clothing/head/helmet/f13/raider/yankee)
	r_pocket = pick(/obj/item/device/flashlight/flare/torch, /obj/item/device/flashlight/flare)
	back = /obj/item/weapon/storage/backpack
	backpack = /obj/item/weapon/storage/backpack
	satchel = /obj/item/weapon/storage/backpack/satchel_norm
	backpack_contents = list(/obj/item/weapon/restraints/handcuffs=1,\
	/obj/item/weapon/pipe=1, \
	/obj/item/weapon/storage/wallet/random=1)
	if (prob(50))
		glasses = /obj/item/clothing/glasses/sunglasses
	if (prob(80))
		l_hand = pick(/obj/item/weapon/hatchet)

/datum/outfit/job/raider/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
