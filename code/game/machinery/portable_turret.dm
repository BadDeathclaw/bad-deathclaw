/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "grey_target_prism"
	anchored = 1
	layer = 3
	invisibility = INVISIBILITY_LEVEL_TWO	//the turret is invisible if it's inside its cover
	density = 1
	use_power = 1				//this turret uses and requires power
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	req_access = list()
	power_channel = EQUIP	//drains power from the EQUIPMENT channel

	var/turret_open = 'sound/f13machines/turret_open.ogg'
	var/turret_close = 'sound/f13machines/turret_close.ogg'
	var/base_icon_state = "grey"
	var/active_state = "Taser" // "Taser"/"Laser/"Bullet" ,blue/red/no glow on active turret
	var/off_state = "Off"

	var/emp_vunerable = 1 // Can be empd

	var/scan_range = 7
	var/atom/base = null //for turrets inside other objects

	var/lasercolor = ""		//Something to do with lasertag turrets, blame Sieve for not adding a comment.
	var/raised = 0			//if the turret cover is "open" and the turret is raised
	var/raising= 0			//if the turret is currently opening or closing its cover
	var/health = 120			//the turret's health
	var/locked = 0			//if the turret's behaviour control access is locked
	var/controllock = 0		//if the turret responds to control panels

	var/installation = /obj/item/weapon/gun/energy/gun/turret		//the type of weapon installed
	var/gun_charge = 0		//the charge of the gun inserted
	var/projectile = null	//holder for bullettype
	var/eprojectile = null	//holder for the shot when emagged
	var/reqpower = 500		//holder for power needed
	var/egun = null			//holder to handle certain guns switching bullettypes
	var/always_up = 0		//Will stay active
	var/has_cover = 0		//Hides the cover

	var/obj/machinery/porta_turret_cover/cover = null	//the cover that is covering this turret
	var/last_fired = 0		//1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/shot_delay = 15		//1.5 seconds between each shot

	var/check_records = 1	//checks if it can use the security records
	var/criminals = 1		//checks if it can shoot people on arrest
	var/auth_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/stun_all = 0		//if this is active, the turret shoots everything that isn't security or head of staff
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/ai		 = 0 		//if active, will shoot at anything not an AI or cyborg

	var/attacked = 0		//if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/on = 1				//determines if the turret is on
	var/disabled = 0

	var/shot_sound 			//what sound should play when the turret fires
	var/eshot_sound			//what sound should play when the emagged turret fires

	var/faction = "neutral"

	var/datum/effect_system/spark_spread/spark_system	//the spark system, used for generating... sparks?

/obj/machinery/porta_turret/New()
	..()
	if(!base)
		base = src
	icon_state = "[base_icon_state][off_state]"
	//Sets up a spark system
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	if(has_cover)
		cover = new /obj/machinery/porta_turret_cover(loc)
		cover.Parent_Turret = src
	setup()
	if(!has_cover)
		popUp()


/obj/machinery/porta_turret/proc/get_base_icon()
	if(installation)
		switch(installation)
			if(/obj/item/weapon/gun/energy/laser/bluetag)
				return "blue"
			if(/obj/item/weapon/gun/energy/laser/redtag)
				return "red"
	return "grey"


/obj/machinery/porta_turret/proc/setup()

	var/obj/item/weapon/gun/energy/E= new installation	//All energy-based weapons are applicable
	var/obj/item/ammo_casing/shottype = E.ammo_type[1]

	projectile = shottype.projectile_type
	eprojectile = projectile
	shot_sound = shottype.fire_sound
	eshot_sound = shot_sound

	switch(E.type)
		if(/obj/item/weapon/gun/energy/laser/bluetag)
			eprojectile = /obj/item/projectile/beam/lasertag/bluetag
			lasercolor = "b"
			req_access = list(access_maint_tunnels, access_theatre)
			check_records = 0
			criminals = 0
			auth_weapons = 1
			stun_all = 0
			check_anomalies = 0
			shot_delay = 30

		if(/obj/item/weapon/gun/energy/laser/redtag)
			eprojectile = /obj/item/projectile/beam/lasertag/redtag
			lasercolor = "r"
			req_access = list(access_maint_tunnels, access_theatre)
			check_records = 0
			criminals = 0
			auth_weapons = 1
			stun_all = 0
			check_anomalies = 0
			shot_delay = 30
			active_state = "Laser"

		if(/obj/item/weapon/gun/energy/laser/practice)
			active_state = "Laser"
			eprojectile = /obj/item/projectile/beam

		if(/obj/item/weapon/gun/energy/laser/retro)
			active_state = "Laser"

		if(/obj/item/weapon/gun/energy/laser/captain)
			active_state = "Laser"

		if(/obj/item/weapon/gun/energy/lasercannon)
			active_state = "Laser"

		if(/obj/item/weapon/gun/energy/gun/advtaser)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/weapon/gun/energy/gun)
			eprojectile = /obj/item/projectile/beam	//If it has, going to kill mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

		if(/obj/item/weapon/gun/energy/gun/nuclear)
			eprojectile = /obj/item/projectile/beam	//If it has, going to kill mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

		if(/obj/item/weapon/gun/energy/gun/turret)
			eprojectile = /obj/item/projectile/beam	//If it has, going to copypaste mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

	base_icon_state = get_base_icon()

/obj/machinery/porta_turret/Destroy()
	//deletes its own cover with it
	qdel(cover)
	cover = null
	return ..()


/obj/machinery/porta_turret/attack_ai(mob/user)
	return attack_hand(user)


/obj/machinery/porta_turret/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	var/dat

	//The browse() text, similar to ED-209s and beepskies.
	if(!lasercolor)	//Lasertag turrets have less options
		dat += text({"
					<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
					Status: []<BR>
					Behaviour controls are [locked ? "locked" : "unlocked"]"},

					"<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>" )

		if(!locked)
			dat += text({"<BR>
						Check for Weapon Authorization: []<BR>
						Check Security Records: []<BR>
						Neutralize Identified Criminals: []<BR>
						Neutralize All Non-Security and Non-Command Personnel: []<BR>
						Neutralize All Unidentified Life Signs: []<BR>"},

						"<A href='?src=\ref[src];operation=authweapon'>[auth_weapons ? "Yes" : "No"]</A>",
						"<A href='?src=\ref[src];operation=checkrecords'>[check_records ? "Yes" : "No"]</A>",
						"<A href='?src=\ref[src];operation=shootcrooks'>[criminals ? "Yes" : "No"]</A>",
						"<A href='?src=\ref[src];operation=shootall'>[stun_all ? "Yes" : "No"]</A>",
						"<A href='?src=\ref[src];operation=checkxenos'>[check_anomalies ? "Yes" : "No"]</A>" )
	else
		if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(lasercolor == "b" && istype(H.wear_suit, /obj/item/clothing/suit/redtag))
				return
			if(lasercolor == "r" && istype(H.wear_suit, /obj/item/clothing/suit/bluetag))
				return
		dat += text({"
					<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
					Status: []<BR>"},

					"<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>" )


	user << browse("<HEAD><TITLE>Automatic Portable Turret Installation</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/porta_turret/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["power"] && !locked)
		if(anchored)	//you can't turn a turret on/off if it's not anchored/secured
			on = !on	//toggle on/off
		else
			usr << "<span class='notice'>It has to be secured first!</span>"

		updateUsrDialog()
		return

	switch(href_list["operation"])	//toggles customizable behavioural protocols
		if("authweapon")
			auth_weapons = !auth_weapons
		if("checkrecords")
			check_records = !check_records
		if("shootcrooks")
			criminals = !criminals
		if("shootall")
			stun_all = !stun_all
	updateUsrDialog()


/obj/machinery/porta_turret/power_change()

	if(!anchored)
		icon_state = "turretCover"
		return
	if(stat & BROKEN)
		icon_state = "[base_icon_state]Broken"
	else
		if( powered() )
			if(on)
				icon_state = "[base_icon_state][active_state]"
			else
				icon_state = "[base_icon_state][off_state]"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				icon_state = "[base_icon_state][off_state]"
				stat |= NOPOWER



/obj/machinery/porta_turret/attackby(obj/item/I, mob/user, params)
	if(stat & BROKEN)
		if(istype(I, /obj/item/weapon/crowbar))
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			user << "<span class='notice'>You begin prying the metal coverings off...</span>"
			sleep(20)
			if(prob(70))
				user << "<span class='notice'>You remove the turret and salvage some components.</span>"
				if(installation)
					var/obj/item/weapon/gun/energy/Gun = new installation(loc)
					Gun.power_supply.charge = gun_charge
					Gun.update_icon()
					lasercolor = null
				if(prob(50))
					new /obj/item/stack/sheet/metal(loc, rand(1,4))
				if(prob(50))
					new /obj/item/device/assembly/prox_sensor(loc)
			else
				user << "<span class='notice'>You remove the turret but did not manage to salvage anything.</span>"
			qdel(src)
	else if(istype(I, /obj/item/weapon/weldingtool) && user.a_intent != "harm")
		user.changeNext_move(CLICK_CD_MELEE)
		var/obj/item/weapon/weldingtool/WT = I
		if(src.health<initial(src.health))
			if (WT.remove_fuel(0,user))
				user << "<span class='notice'>You repair the damaged gas tank.</span>"
				health = max(initial(health), health + 10)

	else if((istype(I, /obj/item/weapon/wrench)) && (!on))
		if(raised) return
		//This code handles moving the turret around. After all, it's a portable turret!
		if(!anchored && !isinspace())
			anchored = 1
			invisibility = INVISIBILITY_LEVEL_TWO
			icon_state = "[base_icon_state][off_state]"
			user << "<span class='notice'>You secure the exterior bolts on the turret.</span>"
			if(has_cover)
				cover = new /obj/machinery/porta_turret_cover(loc) //create a new turret. While this is handled in process(), this is to workaround a bug where the turret becomes invisible for a split second
				cover.Parent_Turret = src //make the cover's parent src
		else if(anchored)
			anchored = 0
			user << "<span class='notice'>You unsecure the exterior bolts on the turret.</span>"
			icon_state = "turretCover"
			invisibility = 0
			qdel(cover) //deletes the cover, and the turret instance itself becomes its own cover.

	else if(istype(I, /obj/item/weapon/card/id)||istype(I, /obj/item/clothing/gloves/pda))
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			user << "<span class='notice'>Controls are now [locked ? "locked" : "unlocked"].</span>"
		else
			user << "<span class='notice'>Access denied.</span>"
	else if(istype(I,/obj/item/device/multitool) && !locked)
		var/obj/item/device/multitool/M = I
		M.buffer = src
		user << "<span class='notice'>You add [src] to multitool buffer.</span>"
	else
		//if the turret was attacked with the intention of harming it:
		user.changeNext_move(CLICK_CD_MELEE)
		take_damage(I.force * 0.5)
		if(I.force * 0.5 > 1) //if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = 1
				spawn()
					sleep(60)
					attacked = 0
		..()

/obj/machinery/porta_turret/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(M.melee_damage_upper == 0 || (M.melee_damage_type != BRUTE && M.melee_damage_type != BURN))
		return
	if(!(stat & BROKEN))
		visible_message("<span class='danger'>[M] [M.attacktext] [src]!</span>")
		add_logs(M, src, "attacked")
		take_damage(M.melee_damage_upper)
	else
		M << "<span class='danger'>That object is useless to you.</span>"
	return

/obj/machinery/porta_turret/attack_alien(mob/living/carbon/alien/humanoid/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(!(stat & BROKEN))
		playsound(src.loc, 'sound/weapons/slash.ogg', 25, 1, -1)
		visible_message("<span class='danger'>[M] has slashed at [src]!</span>")
		add_logs(M, src, "attacked")
		take_damage(15)
	else
		M << "\green That object is useless to you."
	return


/obj/machinery/porta_turret/emag_act(mob/user)
	if(!emagged)
		user << "<span class='warning'>You short out [src]'s threat assessment circuits.</span>"
		visible_message("[src] hums oddly...")
		emagged = 1
		active_state = "Laser"
		controllock = 1
		on = 0 //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		on = 1 //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)
	if(on)
		if(!attacked && !emagged)
			attacked = 1
			spawn()
				sleep(60)
				attacked = 0

	var/damage_dealt = 0
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		damage_dealt = Proj.damage

	..()

	if(damage_dealt)
		if(prob(45))
			spark_system.start()
		take_damage(damage_dealt)

	if(lasercolor == "b" && disabled == 0)
		if(istype(Proj, /obj/item/projectile/beam/lasertag/redtag))
			disabled = 1
			qdel(Proj)
			sleep(100)
			disabled = 0
	if(lasercolor == "r" && disabled == 0)
		if(istype(Proj, /obj/item/projectile/beam/lasertag/bluetag))
			disabled = 1
			qdel(Proj)
			sleep(100)
			disabled = 0


/obj/machinery/porta_turret/emp_act(severity)
	if(on && emp_vunerable)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_records = pick(0, 1)
		criminals = pick(0, 1)
		auth_weapons = pick(0, 1)
		stun_all = pick(0, 0, 0, 0, 1)	//stun_all is a pretty big deal, so it's least likely to get turned on
		if(prob(5))
			emagged = 1

		on=0
		spawn(rand(60,600))
			if(!on)
				on=1

	..()

/obj/machinery/porta_turret/ex_act(severity, target)
	if(severity >= 3)	//turret dies if an explosion touches it!
		die()
	else
		qdel(src)


/obj/machinery/porta_turret/proc/take_damage(damage)
	health -= damage
	if(health <= 0)
		die()

/obj/machinery/porta_turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	density = 0
	stat |= BROKEN	//enables the BROKEN bit
	icon_state = "[base_icon_state]Broken"
	invisibility = 0
	spark_system.start()	//creates some sparks because they look cool
	density = 1
	qdel(cover)	//deletes the cover - no need on keeping it there!



/obj/machinery/porta_turret/process()
	//the main machinery process

	set background = BACKGROUND_ENABLED

	if(cover == null && anchored)	//if it has no cover and is anchored
		if(stat & BROKEN)	//if the turret is borked
			qdel(cover)	//delete its cover, assuming it has one. Workaround for a pesky little bug
		else
			if(has_cover)
				cover = new /obj/machinery/porta_turret_cover(loc)	//if the turret has no cover and is anchored, give it a cover
				cover.Parent_Turret = src	//assign the cover its Parent_Turret, which would be this (src)

	if(stat & (NOPOWER|BROKEN))
		if(!always_up)
			//if the turret has no power or is broken, make the turret pop down if it hasn't already
			popDown()
		return

	if(!on)
		if(!always_up)
			//if the turret is off, make it pop down
			popDown()
		return

	var/list/targets = list()			//list of primary targets
	var/turretview = view(scan_range, base)

	if(check_anomalies)	//if it's set to check for xenos/simpleanimals
		for(var/mob/living/simple_animal/SA in turretview)
			if(SA.stat || faction in SA.faction || SA.has_unlimited_silicon_privilege) //don't target dead animals or NT maint drones.
				continue
			targets += SA

	for(var/mob/living/carbon/C in turretview)	//loops through all carbon-based lifeforms in view(7)
		if(emagged && C.stat != DEAD)	//if emagged, every living carbon is a target.
			targets += C
			continue

		if(C.stat || C.handcuffed || C.lying)	//if the perp is handcuffed or lying or dead/dying, no need to bother really
			continue

		if(ai)	//If it's set to attack all nonsilicons, target them!
			targets += C
			continue

		if(istype(C, /mob/living/carbon/human))	//if the target is a human, analyze threat level
			if(assess_perp(C) >= 4)
				targets += C

		else if(check_anomalies)
			if(!(faction in C.faction))
				for(var/F in C.faction) //We target carbons without the portaturret's faction and who also have alien or slime faction.
					if(F == "alien" || F == "slime")
						targets += C
						break

	for(var/obj/mecha/M in turretview)
		if(M.occupant)
			if(ai || emagged || assess_perp(M.occupant) >= 4) // we target all occupied mechs if we're emagged or set to attack all non silicons.
				targets += M

	if(!tryToShootAt(targets))
		if(!always_up)
			spawn()
				popDown() // no valid targets, close the cover


/obj/machinery/porta_turret/proc/tryToShootAt(list/atom/movable/targets)
	while(targets.len > 0)
		var/atom/movable/M = pick(targets)
		targets -= M
		if(target(M))
			return 1


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	if(disabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	invisibility = 0
	raising = 1
	if(cover)
		playsound(src.loc, turret_open, 50, 0, 0)
		flick("popup", cover)
	sleep(10)
	raising = 0
	if(cover)
		cover.icon_state = "openTurretCover"
	raised = 1
	layer = 4

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	if(disabled)
		return
	if(raising || !raised)
		return
	if(stat & BROKEN)
		return
	layer = 3
	raising = 1
	if(cover)
		playsound(src.loc, turret_close, 50, 0, 0)
		flick("popdown", cover)
	sleep(10)
	raising = 0
	if(cover)
		cover.icon_state = "turretCover"
	raised = 0
	invisibility = 2
	icon_state = "[base_icon_state][off_state]"


/obj/machinery/porta_turret/proc/assess_perp(mob/living/carbon/human/perp)
	var/threatcount = 0	//the integer returned

	if(emagged)
		return 10	//if emagged, always return 10.

	if((stun_all || attacked) && !allowed(perp))
		//if the turret has been attacked or is angry, target all non-sec people
		if(!allowed(perp))
			return 10

	if(auth_weapons)	//check for weapon authorization
		if(isnull(perp.wear_id) || istype(perp.wear_id.GetID(), /obj/item/weapon/card/id/syndicate))

			if(allowed(perp) && !lasercolor) //if the perp has security access, return 0
				return 0

			if((istype(perp.l_hand, /obj/item/weapon/gun) && !istype(perp.l_hand, /obj/item/weapon/gun/projectile/revolver/doublebarrel)) || istype(perp.l_hand, /obj/item/weapon/melee/baton))
				threatcount += 4

			if((istype(perp.r_hand, /obj/item/weapon/gun) && !istype(perp.r_hand, /obj/item/weapon/gun/projectile/revolver/doublebarrel)) || istype(perp.r_hand, /obj/item/weapon/melee/baton))
				threatcount += 4

			if(istype(perp.belt, /obj/item/weapon/gun) || istype(perp.belt, /obj/item/weapon/melee/baton))
				threatcount += 2

	if(lasercolor == "b")	//Lasertag turrets target the opposing team, how great is that? -Sieve
		threatcount = 0		//But does not target anyone else
		if(istype(perp.wear_suit, /obj/item/clothing/suit/redtag))
			threatcount += 4
		if(istype(perp.r_hand,/obj/item/weapon/gun/energy/laser/redtag) || istype(perp.l_hand,/obj/item/weapon/gun/energy/laser/redtag))
			threatcount += 4
		if(istype(perp.belt, /obj/item/weapon/gun/energy/laser/redtag))
			threatcount += 2

	if(lasercolor == "r")
		threatcount = 0
		if(istype(perp.wear_suit, /obj/item/clothing/suit/bluetag))
			threatcount += 4
		if((istype(perp.r_hand,/obj/item/weapon/gun/energy/laser/bluetag)) || (istype(perp.l_hand,/obj/item/weapon/gun/energy/laser/bluetag)))
			threatcount += 4
		if(istype(perp.belt, /obj/item/weapon/gun/energy/laser/bluetag))
			threatcount += 2

	if(check_records)	//if the turret can check the records, check if they are set to *Arrest* on records
		var/perpname = perp.get_face_name(perp.get_id_name())
		var/datum/data/record/R = find_record("name", perpname, data_core.security)
		if(!R || (R.fields["criminal"] == "*Arrest*"))
			threatcount += 4

	return threatcount


/obj/machinery/porta_turret/proc/target(atom/movable/target)
	if(disabled)
		return
	if(target)
		spawn()
			popUp()				//pop the turret up if it's not already up.
		dir = get_dir(base, target)	//even if you can't shoot, follow the target
		spawn()
			shootAt(target)
		return 1
	return

/obj/machinery/porta_turret/proc/shootAt(atom/movable/target)
	if(!emagged)	//if it hasn't been emagged, it has to obey a cooldown rate
		if(last_fired || !raised)	//prevents rapid-fire shooting, unless it's been emagged
			return
		last_fired = 1
		spawn()
			sleep(shot_delay)
			last_fired = 0

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	//any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	icon_state = "[base_icon_state][active_state]"
	var/obj/item/projectile/A
	if(emagged)
		A = new eprojectile(T)
		playsound(loc, eshot_sound, 75, 1)
	else
		A = new projectile(T)
		playsound(loc, shot_sound, 75, 1)
	A.original = target
	if(!emagged)
		use_power(reqpower)
	else
		use_power(reqpower * 2)
	//Shooting Code:
	A.current = T
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	A.fire()
	return A


/obj/machinery/porta_turret/proc/setState(on, emagged)
	if(controllock)
		return
	src.on = on
	src.emagged = emagged
	if(emagged)
		src.active_state = "Laser"
	src.power_change()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density=1
	var/build_step = 0			//the current step in the building process
	var/finish_name="turret"	//the name applied to the product turret
	var/installation = null		//the gun type installed
	var/gun_charge = 0			//the gun charge of the gun type installed


/obj/machinery/porta_turret_construct/attackby(obj/item/I, mob/user, params)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(istype(I, /obj/item/weapon/wrench) && !anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>You secure the external bolts.</span>"
				anchored = 1
				build_step = 1
				return

			else if(istype(I, /obj/item/weapon/crowbar) && !anchored)
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				user << "<span class='notice'>You dismantle the turret construction.</span>"
				new /obj/item/stack/sheet/metal( loc, 5)
				qdel(src)
				return

		if(1)
			if(istype(I, /obj/item/stack/sheet/metal))
				var/obj/item/stack/sheet/metal/M = I
				if(M.use(2))
					user << "<span class='notice'>You add some metal armor to the interior frame.</span>"
					build_step = 2
					icon_state = "turret_frame2"
				else
					user << "<span class='warning'>You need two sheets of metal to continue construction!</span>"
				return

			else if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				user << "<span class='notice'>You unfasten the external bolts.</span>"
				anchored = 0
				build_step = 0
				return


		if(2)
			if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>You bolt the metal armor into place.</span>"
				build_step = 3
				return

			else if(istype(I, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = I
				if(!WT.isOn())
					return
				if(WT.get_fuel() < 5) //uses up 5 fuel.
					user << "<span class='warning'>You need more fuel to complete this task!</span>"
					return

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				user << "<span class='notice'>You start to remove the turret's interior metal armor...</span>"
				if(do_after(user, 20/I.toolspeed, target = src))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					user << "<span class='notice'>You remove the turret's interior metal armor.</span>"
					new /obj/item/stack/sheet/metal( loc, 2)
					return


		if(3)
			if(istype(I, /obj/item/weapon/gun/energy)) //the gun installation part

				if(isrobot(user))
					return
				var/obj/item/weapon/gun/energy/E = I //typecasts the item to an energy gun
				if(!user.unEquip(I))
					user << "<span class='warning'>\the [I] is stuck to your hand, you cannot put it in \the [src]!</span>"
					return
				installation = I.type //installation becomes I.type
				gun_charge = E.power_supply.charge //the gun's charge is stored in gun_charge
				user << "<span class='notice'>You add [I] to the turret.</span>"
				build_step = 4
				qdel(I) //delete the gun :(
				return

			else if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>You remove the turret's metal armor bolts.</span>"
				build_step = 2
				return

		if(4)
			if(isprox(I))
				build_step = 5
				if(!user.unEquip(I))
					user << "<span class='warning'>\the [I] is stuck to your hand, you cannot put it in \the [src]!</span>"
					return
				user << "<span class='notice'>You add the proximity sensor to the turret.</span>"
				qdel(I)
				return

			//attack_hand() removes the gun

		if(5)
			if(istype(I, /obj/item/weapon/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 6
				user << "<span class='notice'>You close the internal access hatch.</span>"
				return

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(I, /obj/item/stack/sheet/metal))
				var/obj/item/stack/sheet/metal/M = I
				if(M.use(2))
					user << "<span class='notice'>You add some metal armor to the exterior frame.</span>"
					build_step = 7
				else
					user << "<span class='warning'>You need two sheets of metal to continue construction!</span>"
				return

			else if(istype(I, /obj/item/weapon/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 5
				user << "<span class='notice'>You open the internal access hatch.</span>"
				return

		if(7)
			if(istype(I, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = I
				if(!WT.isOn()) return
				if(WT.get_fuel() < 5)
					user << "<span class='warning'>You need more fuel to complete this task!</span>"

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				user << "<span class='notice'>You begin to weld the turret's armor down...</span>"
				if(do_after(user, 30/I.toolspeed, target = src))
					if(!src || !WT.remove_fuel(5, user))
						return
					build_step = 8
					user << "<span class='notice'>You weld the turret's armor down.</span>"

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new/obj/machinery/porta_turret(loc)
					Turret.name = finish_name
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.setup()

//					Turret.cover=new/obj/machinery/porta_turret_cover(loc)
//					Turret.cover.Parent_Turret=Turret
//					Turret.cover.name = finish_name
					qdel(src)

			else if(istype(I, /obj/item/weapon/crowbar))
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				user << "<span class='notice'>You pry off the turret's exterior armor.</span>"
				new /obj/item/stack/sheet/metal(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/weapon/pen))	//you can rename turrets like bots!
		var/t = stripped_input(user, "Enter new turret name", name, finish_name)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		finish_name = t
		return
	..()


/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3

			var/obj/item/weapon/gun/energy/Gun = new installation(loc)
			Gun.power_supply.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			user << "<span class='notice'>You remove [Gun] from the turret frame.</span>"

		if(5)
			user << "<span class='notice'>You remove the prox sensor from the turret frame.</span>"
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return


/************************
* PORTABLE TURRET COVER *
************************/

/obj/machinery/porta_turret_cover
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = 3.5
	density = 0
	var/obj/machinery/porta_turret/Parent_Turret = null


//The below code is pretty much just recoded from the initial turret object. It's necessary but uncommented because it's exactly the same!
//>necessary
//I'm not fixing it because i'm fucking bored of this code already, but someone should just reroute these to the parent turret's procs.

/obj/machinery/porta_turret_cover/attack_ai(mob/user)
	. = ..()
	if(.)
		return

	return Parent_Turret.attack_ai(user)


/obj/machinery/porta_turret_cover/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	return Parent_Turret.attack_hand(user)


/obj/machinery/porta_turret_cover/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/wrench) && !Parent_Turret.on)
		if(Parent_Turret.raised) return

		if(!Parent_Turret.anchored)
			Parent_Turret.anchored = 1
			Parent_Turret.invisibility = INVISIBILITY_LEVEL_TWO
			Parent_Turret.icon_state = "grey_target_prism"
			user << "<span class='notice'>You secure the exterior bolts on the turret.</span>"
		else
			Parent_Turret.anchored = 0
			user << "<span class='notice'>You unsecure the exterior bolts on the turret.</span>"
			Parent_Turret.icon_state = "turretCover"
			Parent_Turret.invisibility = 0
			qdel(src)

	else if(istype(I, /obj/item/weapon/card/id)||istype(I, /obj/item/clothing/gloves/pda))
		if(Parent_Turret.allowed(user))
			Parent_Turret.locked = !Parent_Turret.locked
			user << "<span class='notice'>Controls are now [Parent_Turret.locked ? "locked" : "unlocked"].</span>"
			updateUsrDialog()
		else
			user << "<span class='notice'>Access denied.</span>"
	else if(istype(I,/obj/item/device/multitool) && !Parent_Turret.locked)
		var/obj/item/device/multitool/M = I
		M.buffer = Parent_Turret
		user << "<span class='notice'>You add [Parent_Turret] to multitool buffer.</span>"
	else
		user.changeNext_move(CLICK_CD_MELEE)
		Parent_Turret.health -= I.force * 0.5
		if(Parent_Turret.health <= 0)
			Parent_Turret.die()
		if(I.force * 0.5 > 2)
			if(!Parent_Turret.attacked && !Parent_Turret.emagged)
				Parent_Turret.attacked = 1
				spawn()
					sleep(30)
					Parent_Turret.attacked = 0
		..()

/obj/machinery/porta_turret_cover/emag_act(mob/user)
	if(!Parent_Turret.emagged)
		user << "<span class='notice'>You short out [Parent_Turret]'s threat assessment circuits.</span>"
		visible_message("[Parent_Turret] hums oddly...")
		Parent_Turret.emagged = 1
		Parent_Turret.on = 0
		sleep(40)
		Parent_Turret.on = 1

/obj/machinery/porta_turret/stationary
	emagged = 0

/obj/machinery/porta_turret/stationary/New()
		installation = new/obj/item/weapon/gun/energy/laser(loc)
		..()


/obj/machinery/porta_turret/syndicate
	installation = null
	always_up = 1
	use_power = 0
	has_cover = 0
	scan_range = 9
	projectile = /obj/item/projectile/bullet
	eprojectile = /obj/item/projectile/bullet
	shot_sound = 'sound/weapons/Gunshot.ogg'
	eshot_sound = 'sound/weapons/Gunshot.ogg'
	base_icon_state = "syndie"
	active_state = "Bullet"
	faction = "syndicate"
	emp_vunerable = 0

/obj/machinery/porta_turret/syndicate/setup()
	return

/obj/machinery/porta_turret/syndicate/assess_perp(mob/living/carbon/human/perp)
	if(faction in perp.faction) //Shoot all non syndies
		return 0
	return 10

/obj/machinery/porta_turret/syndicate/pod
	health = 60
	projectile = /obj/item/projectile/bullet/deagleAE
	eprojectile = /obj/item/projectile/bullet/deagleAE

////////////////////////
//Turret Control Panel//
////////////////////////

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = 1
	density = 0
	var/enabled = 1
	var/lethal = 0
	var/locked = 1
	var/control_area = null //can be area name, path or nothing.
	var/ailock = 0 // AI cannot use this
	req_access = list(access_ai_upload)
	var/list/obj/machinery/porta_turret/turrets = list()

/obj/machinery/turretid/New(loc, ndir = 0, built = 0)
	..()
	if(built)
		dir = ndir
		locked = 0
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
	power_change() //Checks power and initial settings
	return

/obj/machinery/turretid/initialize() //map-placed turrets autolink turrets
	if(control_area && istext(control_area))
		for(var/area/A in world)
			if(A.name == control_area)
				control_area = A
				break

	if(!control_area)
		var/area/CA = get_area(src)
		if(CA.master && CA.master != CA)
			control_area = CA.master
		else
			control_area = CA

	for(var/obj/machinery/porta_turret/T in get_area_all_atoms(control_area))
		turrets |= T

/obj/machinery/turretid/attackby(obj/item/I, mob/user, params)
	if(stat & BROKEN) return

	if (istype(I,/obj/item/device/multitool))
		var/obj/item/device/multitool/M = I
		if(M.buffer && istype(M.buffer,/obj/machinery/porta_turret))
			turrets |= M.buffer
			user << "You link \the [M.buffer] with \the [src]"
			return

	if (istype(user, /mob/living/silicon))
		return src.attack_hand(user)

	if( get_dist(src, user) == 0 )		// trying to unlock the interface
		if (src.allowed(usr))
			if(emagged)
				user << "<span class='notice'>The turret control is unresponsive.</span>"
				return

			locked = !locked
			user << "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>"
			if (locked)
				if (user.machine==src)
					user.unset_machine()
					user << browse(null, "window=turretid")
			else
				if (user.machine==src)
					src.attack_hand(user)
		else
			user << "<span class='warning'>Access denied.</span>"

/obj/machinery/turretid/emag_act(mob/user)
	if(!emagged)
		user << "<span class='danger'>You short out the turret controls' access analysis module.</span>"
		emagged = 1
		locked = 0
		if(user && user.machine==src)
			src.attack_hand(user)

/obj/machinery/turretid/attack_ai(mob/user)
	if(!ailock || IsAdminGhost(user))
		return attack_hand(user)
	else
		user << "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>"

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if ( get_dist(src, user) > 0 )
		if ( !(issilicon(user) || IsAdminGhost(user)) )
			user << "<span class='notice'>You are too far away.</span>"
			user.unset_machine()
			user << browse(null, "window=turretid")
			return

	user.set_machine(src)
	var/loc = src.loc
	if (istype(loc, /turf))
		loc = loc:loc
	if (!istype(loc, /area))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = ""

	if(src.locked && (!(istype(user, /mob/living/silicon) || IsAdminGhost(user))))
		t += "<div class='notice icon'>Swipe ID card to unlock interface</div>"
	else
		if (!istype(user, /mob/living/silicon) && !IsAdminGhost(user))
			t += "<div class='notice icon'>Swipe ID card to lock interface</div>"
		t += text("Turrets [] - <A href='?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	//user << browse(t, "window=turretid")
	//onclose(user, "turretid")
	var/datum/browser/popup = new(user, "turretid", "Turret Control Panel ([area.name])")
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return
	if (src.locked)
		if (!(istype(usr, /mob/living/silicon) || IsAdminGhost(usr)))
			usr << "Control panel is locked!"
			return
	if (href_list["toggleOn"])
		toggle_on()
	else if (href_list["toggleLethal"])
		toggle_lethal()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/toggle_lethal()
	lethal = !lethal
	updateTurrets()

/obj/machinery/turretid/proc/toggle_on()
	enabled = !enabled
	updateTurrets()

/obj/machinery/turretid/proc/updateTurrets()
	for (var/obj/machinery/porta_turret/aTurret in turrets)
		aTurret.setState(enabled, lethal)
	src.update_icon()

/obj/machinery/turretid/power_change()
	..()
	update_icon()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
		else
			icon_state = "control_stun"
	else
		icon_state = "control_standby"

/obj/item/wallframe/turret_control
	name = "turret control frame"
	desc = "Used for building turret control panels"
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	result_path = /obj/machinery/turretid
	materials = list(MAT_METAL=MINERAL_MATERIAL_AMOUNT)
