//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
CONTAINS:
RCD
*/
/obj/item/weapon/rcd
	name = "rapid-construction-device (RCD)"
	desc = "A device used to rapidly build and deconstruct walls and floors."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0
	flags = CONDUCT
	force = 10
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	w_class = 3
	materials = list(MAT_METAL=100000)
	origin_tech = "engineering=4;materials=2"
	req_access_txt = "11"
	var/datum/effect_system/spark_spread/spark_system
	var/matter = 0
	var/max_matter = 160
	var/working = 0
	var/mode = 1
	var/canRturf = 0
	var/airlock_type = /obj/machinery/door/airlock
	var/advanced_airlock_setting = 1 //Set to 1 if you want more paintjobs available
	var/sheetmultiplier	= 4			 //Controls the amount of matter added for each glass/metal sheet, triple for plasteel
	var/plasteelmultiplier = 12 //Plasteel is worth 3 times more than glass or metal

	var/list/conf_access = null
	var/use_one_access = 0 //If the airlock should require ALL or only ONE of the listed accesses.

	/* Construction costs */

	var/wallcost = 16
	var/floorcost = 2
	var/grillecost = 4
	var/windowcost = 8
	var/airlockcost = 16
	var/windoorcost = 16
	var/deconwallcost = 26
	var/deconfloorcost = 33
	var/decongrillecost = 4
	var/deconwindowcost = 8
	var/deconairlockcost = 32

	/* Build delays (deciseconds) */

	var/walldelay = 20
	var/floordelay = null //space wind's a bitch
	var/grilledelay = 40
	var/windowdelay = 40
	var/airlockdelay = 50
	var/windoordelay = 50
	var/deconwalldelay = 40
	var/deconfloordelay = 50
	var/decongrilledelay = null //as rapid as wirecutters
	var/deconwindowdelay = 50
	var/deconairlockdelay = 50

/obj/item/weapon/rcd/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] sets the RCD to 'Wall' and points it down \his throat! It looks like \he's trying to commit suicide..</span>")
	return (BRUTELOSS)

/obj/item/weapon/rcd/verb/change_airlock_access()
	set name = "Change Airlock Access"
	set category = "Object"
	set src in usr

	if (!ishuman(usr) && !usr.has_unlimited_silicon_privilege)
		return ..(usr)

	var/mob/living/carbon/human/H = usr
	if(H.getBrainLoss() >= 60)
		return

	var/t1 = text("")



	if(use_one_access)
		t1 += "Restriction Type: <a href='?src=\ref[src];access=one'>At least one access required</a><br>"
	else
		t1 += "Restriction Type: <a href='?src=\ref[src];access=one'>All accesses required</a><br>"

	t1 += "<a href='?src=\ref[src];access=all'>Remove All</a><br>"

	var/accesses = ""
	accesses += "<div align='center'><b>Access</b></div>"
	accesses += "<table style='width:100%'>"
	accesses += "<tr>"
	for(var/i = 1; i <= 7; i++)
		accesses += "<td style='width:14%'><b>[get_region_accesses_name(i)]:</b></td>"
	accesses += "</tr><tr>"
	for(var/i = 1; i <= 7; i++)
		accesses += "<td style='width:14%' valign='top'>"
		for(var/A in get_region_accesses(i))
			if(A in conf_access)
				accesses += "<a href='?src=\ref[src];access=[A]'><font color=\"red\">[replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
			else
				accesses += "<a href='?src=\ref[src];access=[A]'>[replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
			accesses += "<br>"
		accesses += "</td>"
	accesses += "</tr></table>"
	t1 += "<tt>[accesses]</tt>"

	t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)

	var/datum/browser/popup = new(usr, "airlock_electronics", "Access Control", 900, 500)
	popup.set_content(t1)
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	onclose(usr, "airlock")

/obj/item/weapon/rcd/Topic(href, href_list)
	..()
	if (usr.stat || usr.restrained())
		return
	if (href_list["close"])
		usr << browse(null, "window=airlock")
		return

	if (href_list["access"])
		toggle_access(href_list["access"])

	change_airlock_access()

/obj/item/weapon/rcd/proc/toggle_access(acc)
	if (acc == "all")
		conf_access = null
	else if(acc == "one")
		use_one_access = !use_one_access
	else
		var/req = text2num(acc)

		if (conf_access == null)
			conf_access = list()

		if (!(req in conf_access))
			conf_access += req
		else
			conf_access -= req
			if (!conf_access.len)
				conf_access = null

/obj/item/weapon/rcd/verb/change_airlock_setting()
	set name = "Change Airlock Setting"
	set category = "Object"
	set src in usr

	var airlockcat = input(usr, "Select whether the airlock is solid or glass.") in list("Solid", "Glass")
	switch(airlockcat)
		if("Solid")
			if(advanced_airlock_setting == 1)
				var airlockpaint = input(usr, "Select the paintjob of the airlock.") in list("Default", "Engineering", "Atmospherics", "Security", "Command", "Medical", "Research", "Mining", "Maintenance", "External", "High Security")
				switch(airlockpaint)
					if("Default")
						airlock_type = /obj/machinery/door/airlock
					if("Engineering")
						airlock_type = /obj/machinery/door/airlock/engineering
					if("Atmospherics")
						airlock_type = /obj/machinery/door/airlock/atmos
					if("Security")
						airlock_type = /obj/machinery/door/airlock/security
					if("Command")
						airlock_type = /obj/machinery/door/airlock/command
					if("Medical")
						airlock_type = /obj/machinery/door/airlock/medical
					if("Research")
						airlock_type = /obj/machinery/door/airlock/research
					if("Mining")
						airlock_type = /obj/machinery/door/airlock/mining
					if("Maintenance")
						airlock_type = /obj/machinery/door/airlock/maintenance
					if("External")
						airlock_type = /obj/machinery/door/airlock/external
					if("High Security")
						airlock_type = /obj/machinery/door/airlock/highsecurity
			else
				airlock_type = /obj/machinery/door/airlock

		if("Glass")
			if(advanced_airlock_setting == 1)
				var airlockpaint = input(usr, "Select the paintjob of the airlock.") in list("Default", "Engineering", "Atmospherics", "Security", "Command", "Medical", "Research", "Mining")
				switch(airlockpaint)
					if("Default")
						airlock_type = /obj/machinery/door/airlock/glass
					if("Engineering")
						airlock_type = /obj/machinery/door/airlock/glass_engineering
					if("Atmospherics")
						airlock_type = /obj/machinery/door/airlock/glass_atmos
					if("Security")
						airlock_type = /obj/machinery/door/airlock/glass_security
					if("Command")
						airlock_type = /obj/machinery/door/airlock/glass_command
					if("Medical")
						airlock_type = /obj/machinery/door/airlock/glass_medical
					if("Research")
						airlock_type = /obj/machinery/door/airlock/glass_research
					if("Mining")
						airlock_type = /obj/machinery/door/airlock/glass_mining
			else
				airlock_type = /obj/machinery/door/airlock/glass
		else
			airlock_type = /obj/machinery/door/airlock


/obj/item/weapon/rcd/New()
	..()
	desc = "An RCD. It currently holds [matter]/[max_matter] matter-units."
	src.spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	rcd_list += src
	return


/obj/item/weapon/rcd/Destroy()
	qdel(spark_system)
	spark_system = null
	rcd_list -= src
	return ..()

/obj/item/weapon/rcd/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(isrobot(user))	//Make sure cyborgs can't load their RCDs
		return
	var/loaded = 0
	if(istype(W, /obj/item/weapon/rcd_ammo))
		var/obj/item/weapon/rcd_ammo/R = W
		if((matter + R.ammoamt) > max_matter)
			user << "<span class='warning'>The RCD can't hold any more matter-units!</span>"
			return
		if(!user.unEquip(W))
			return
		qdel(W)
		matter += R.ammoamt
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		loaded = 1
	else if(istype(W, /obj/item/stack/sheet/metal) || istype(W, /obj/item/stack/sheet/glass))
		loaded = loadwithsheets(W, sheetmultiplier, user)
	else if(istype(W, /obj/item/stack/sheet/plasteel))
		loaded = loadwithsheets(W, plasteelmultiplier*sheetmultiplier, user) //Plasteel is worth 3 times more than glass or metal
	if(loaded)
		user << "<span class='notice'>The RCD now holds [matter]/[max_matter] matter-units.</span>"
		desc = "A RCD. It currently holds [matter]/[max_matter] matter-units."
	return

/obj/item/weapon/rcd/proc/loadwithsheets(obj/item/stack/sheet/S, value, mob/user)
    var/maxsheets = round((max_matter-matter)/value)    //calculate the max number of sheets that will fit in RCD
    if(maxsheets > 0)
        if(S.amount > maxsheets)
            //S.amount -= maxsheets
            S.use(maxsheets)
            matter += value*maxsheets
            playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
            user << "<span class='notice'>You insert [maxsheets] [S.name] sheets into the RCD. </span>"
        else
            matter += value*(S.amount)
            user.unEquip()
            S.use(S.amount)
            playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
            user << "<span class='notice'>You insert [S.amount] [S.name] sheets into the RCD. </span>"

        return 1
    user << "<span class='warning'>You can't insert any more [S.name] sheets into the RCD!"
    return 0

/obj/item/weapon/rcd/attack_self(mob/user)
	//Change the mode
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	switch(mode)
		if(1)
			mode = 2
			user << "<span class='notice'>You change RCD's mode to 'Airlock'.</span>"
		if(2)
			mode = 3
			user << "<span class='notice'>You change RCD's mode to 'Deconstruct'.</span>"
		if(3)
			mode = 4
			user << "<span class='notice'>You change RCD's mode to 'Grilles & Windows'.</span>"
		if(4)
			mode = 5
			user << "<span class='notice'>You change RCD's mode to 'Windoors'.</span>"
		if(5)
			mode = 6
			user << "<span class='notice'>You change RCD's mode to 'Tables'.</span>"
		if(6)
			mode = 1
			user << "<span class='notice'>You change RCD's mode to 'Walls and floors.</span>"

	if(prob(20))
		src.spark_system.start()
	return

/obj/item/weapon/rcd/proc/activate()
	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)


/obj/item/weapon/rcd/afterattack(atom/A, mob/user, proximity)
	user.changeNext_move(0)
	if(!proximity) return 0
	if(istype(A,/area/shuttle)||istype(A,/turf/space/transit))
		return 0
	if(!(istype(A, /turf) || istype(A, /obj/machinery/door/airlock) || istype(A, /obj/structure/grille) || istype(A, /obj/structure/window)))
		return 0

	switch(mode)
		if(1)
			if(istype(A, /turf/space))
				var/turf/space/S = A
				if(useResource(floorcost, user))
					user << "<span class='notice'>You start building floor...</span>"
					activate()
					S.ChangeTurf(/turf/simulated/floor/plating)
					return 1
				return 0
			if(istype(A, /turf/simulated/wall))
				var/turf/simulated/wall/Wa = A
				if(checkResource(wallcost,user) && canRturf)
					user << "<span class='notice'>You start reinforcing the wall...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, walldelay, target = A))
						if(!useResource(wallcost, user)) return 0
						activate()
						Wa.ChangeTurf(/turf/simulated/wall/r_wall)
						return 1
				return 0
			if(istype(A, /turf/simulated/floor))
				var/turf/simulated/floor/F = A
				if(checkResource(wallcost, user))
					user << "<span class='notice'>You start building wall...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, walldelay, target = A))
						if(!useResource(wallcost, user)) return 0
						activate()
						F.ChangeTurf(/turf/simulated/wall)
						return 1
				return 0
		if(2)
			if(istype(A, /turf/simulated/floor))
				if(checkResource(airlockcost, user))
					var/door_check = 1
					for(var/obj/machinery/door/D in A)
						if(!D.sub_door)
							door_check = 0
							break

					if(door_check)
						user << "<span class='notice'>You start building airlock...</span>"
						playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
						if(do_after(user, airlockdelay, target = A))
							if(!useResource(airlockcost, user)) return 0
							activate()
							var/obj/machinery/door/airlock/T = new airlock_type( A )

							T.electronics = new/obj/item/weapon/electronics/airlock( src.loc )

							if(conf_access)
								T.electronics.accesses = conf_access.Copy()
							T.electronics.one_access = use_one_access

							if(T.electronics.one_access)
								T.req_one_access = T.electronics.accesses
							else
								T.req_access = T.electronics.accesses

							if(!T.checkForMultipleDoors())
								qdel(T)
								useResource(-airlockcost, user)
								return 0
							T.autoclose = 1
							return 1
						return 0
					else
						user << "<span class='warning'>There is another door here!</span>"
						return 0
				return 0

		if(3)
			if(istype(A, /turf/simulated/wall))
				var/turf/simulated/wall/W = A
				if(istype(W, /turf/simulated/wall/r_wall) && !canRturf)
					return 0
				if(checkResource(deconwallcost, user))
					user << "<span class='notice'>You start deconstructing wall...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, deconwalldelay, target = A))
						if(!useResource(deconwallcost, user)) return 0
						activate()
						W.ChangeTurf(/turf/simulated/floor/plating)
						return 1
				return 0

			if(istype(A, /turf/simulated/floor))
				var/turf/simulated/floor/F = A
				if(istype(F, /turf/simulated/floor/engine) && !canRturf)
					return 0
				if(istype(F, F.baseturf))
					user << "<span class='notice'>You can't dig any deeper!</span>"
					return 0
				else if(checkResource(deconfloorcost, user))
					user << "<span class='notice'>You start deconstructing floor...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, deconfloordelay, target = A))
						if(!useResource(deconfloorcost, user)) return 0
						activate()
						F.ChangeTurf(F.baseturf)
						return 1
				return 0

			if(istype(A, /obj/machinery/door/airlock))
				if(checkResource(deconairlockcost, user))
					user << "<span class='notice'>You start deconstructing airlock...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, deconairlockdelay, target = A))
						if(!useResource(deconairlockcost, user)) return 0
						activate()
						qdel(A)
						return 1
				return	0

			if(istype(A, /obj/structure/window))
				if(checkResource(deconwindowcost, user))
					user << "<span class='notice'>You start deconstructing the window...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, deconwindowdelay, target = A))
						if(!useResource(deconwindowcost, user)) return 0
						activate()
						qdel(A)
						return 1
				return	0

			if(istype(A, /obj/structure/grille))
				var/obj/structure/grille/G = A
				if(!G.shock(user, 90)) //if it's shocked, try to shock them
					if(useResource(decongrillecost, user))
						user << "<span class='notice'>You start deconstructing the grille...</span>"
						activate()
						playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
						qdel(A)
						return 1
					return 0
			if(istype(A, /obj/machinery/door/window))
				var/obj/machinery/door/window/WD = A
				if(useResource(deconairlockcost, user))
					user << "<span class='notice'>You start deconstructing the windoor...</span>"
					activate()
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					qdel(WD)
					return 1
			if(istype(A, /obj/structure/table))
				var/obj/structure/table/table = A
				if(useResource(deconwindowcost, user))
					user << "<span class='notice'>You start deconstructing the table...</span>"
					activate()
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					qdel(table)
					return 1
				return 0

		if (4)
			if(istype(A, /turf/simulated/floor))
				if(checkResource(grillecost, user))
					for(var/obj/structure/grille/GRILLE in A)
						user << "<span class='warning'>There is already a grille there!</span>"
						return 0
					user << "<span class='notice'>You start building a grille...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, grilledelay, target = A))
						if(!useResource(grillecost, user)) return 0
						activate()
						var/obj/structure/grille/G = new/obj/structure/grille(A)
						G.anchored = 1
						return 1
					return 0
				return 0
			if(istype(A, /obj/structure/grille))
				if(checkResource(windowcost, user))
					user << "<span class='notice'>You start building a window...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, windowdelay, target = A))
						if(locate(/obj/structure/window) in A.loc) return 0
						if(!useResource(windowcost, user)) return 0
						activate()
						var/obj/structure/window/WD = new/obj/structure/window/fulltile(A.loc)
						WD.anchored = 1
						return 1
					return 0
				return 0
		if (5)
			if(istype(A, /turf/simulated/floor))
				if(checkResource(windoorcost, user))
					user << "<span class='notice'>You start building a windoor...</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
					if(do_after(user, airlockdelay, target = A))
						var/counter = 0
						for(var/obj/machinery/door/window/WD in A)
							counter += 1
							if(counter > 2) //So you can have two windoors in one location
								return 0
						if(!useResource(windoorcost, user)) return 0
						activate()
						var/obj/machinery/door/window/brigdoor/Wa = new/obj/machinery/door/window/brigdoor(A)
						Wa.icon_state = "leftsecureopen"
						Wa.base_state = "leftsecure"
						switch(user.dir)
							if(SOUTH)
								Wa.dir = NORTH
							if(EAST)
								Wa.dir = WEST
							if(WEST)
								Wa.dir = EAST
							else //If the user is facing northeast. northwest, southeast, southwest or north, default to north
								Wa.dir = SOUTH
						if(conf_access)
							Wa.electronics.accesses = conf_access.Copy()
		if (6)
			if(istype(A, /turf/simulated/floor))
				if(checkResource(windoorcost, user))
					user << "<span class='notice'>You start building a table...</span>"
					if(do_after(user, windowdelay, target = A))
						if(locate(/obj/structure/table) in A.loc) return 0
						if(!useResource(windowcost, user)) return 0
						var/obj/structure/table/table2 = new/obj/structure/table(A.loc)
						table2.anchored = 1
						return 1
		else
			user << "ERROR: RCD in MODE: [mode] attempted use by [user]. Send this text #coderbus or an admin."
			return 0

/obj/item/weapon/rcd/proc/useResource(amount, mob/user)
	if(matter < amount)
		return 0
	matter -= amount
	desc = "An RCD. It currently holds [matter]/[max_matter] matter-units."
	return 1

/obj/item/weapon/rcd/proc/checkResource(amount, mob/user)
	return matter >= amount
/obj/item/weapon/rcd/borg/useResource(amount, mob/user)
	if(!isrobot(user))
		return 0
	return user:cell:use(amount * 72) //borgs get 1.3x the use of their RCDs

/obj/item/weapon/rcd/borg/checkResource(amount, mob/user)
	if(!isrobot(user))
		return 0
	return user:cell:charge >= (amount * 72)

/obj/item/weapon/rcd/borg/New()
	..()
	desc = "A device used to rapidly build walls and floors."
	canRturf = 1

/obj/item/weapon/rcd/loaded
	matter = 160

/obj/item/weapon/rcd/combat
	name = "industrial RCD"
	max_matter = 500
	matter = 500
	canRturf = 1

/obj/item/weapon/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	origin_tech = "materials=3"
	materials = list(MAT_METAL=3000, MAT_GLASS=2000)
	var/ammoamt = 40

/obj/item/weapon/rcd_ammo/large
	origin_tech = "materials=4"
	materials = list(MAT_METAL=12000, MAT_GLASS=8000)
	ammoamt = 160

/obj/item/weapon/circuitboardthing
	name = "Advanced Machine Builder"
	desc = "Takes circuit boards and makes machines out of them quickly."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	var/circuit = 0

/obj/item/weapon/circuitboardthing/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/circuitboard))
		if(!circuit)
			user << "You insert the [W.name] into the [src]."
			circuit = new W.type(loc)
			qdel(W)

/obj/item/weapon/circuitboardthing/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return 0
	if(circuit)
		var/obj/item/weapon/circuitboard/circuitthing = src.circuit
		var/obj/item/weapon/circuitboard/thingtospawn = circuitthing.build_path
		new thingtospawn(A)
		qdel(circuit)
		circuit = 0

/obj/item/weapon/portaturretconstruct
	name = "Advanced Turret Constructor"
	desc = "Takes energy weapons and quickly constructs portable turrets out of them. Use a screwdriver to take the gun out."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	var/obj/item/weapon/gun/energy/gun = null

/obj/item/weapon/portaturretconstruct/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/weapon/gun/energy))
		if(!gun)
			user << "You insert the [W.name] into the [src]."
			src.gun = new W.type(src)
			qdel(W)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(gun)
			user << "You remove the [gun.name] from the [src]."
			var/obj/item/weapon/gun/energy/tempgun = new gun.type(src)
			user.put_in_hands(tempgun)
			gun = null

/obj/item/weapon/portaturretconstruct/afterattack(atom/A, mob/user, proximity)
	if(gun)
		var/obj/machinery/porta_turret/Turret = new/obj/machinery/porta_turret(A)
		Turret.installation = gun.type
		Turret.gun_charge = gun.power_supply.charge
		Turret.setup()
		gun = null
