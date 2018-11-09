/obj/item/weapon/lock
	name = "lock"
	desc = "A heavy-duty lock for doors."
	icon = 'icons/obj/lock.dmi'
	w_class = 2
	var/uid
	var/global/gl_uid = 1
	/obj/item/weapon/lock/proc/assign_uid()
	uid = gl_uid
	gl_uid++