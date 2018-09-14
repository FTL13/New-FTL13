/obj/machinery/power/shipweapon //PHYSICAL WEAPON
	name = "phase cannon"
	desc = "yell at someone to fix this."
	icon = 'ftl/icons/obj/96x96.dmi'
	icon_state = "phase_cannon"
	dir = EAST
	pixel_x = -32
	pixel_y = -23
	anchored = TRUE
	density = TRUE

	var/charge_rate = 400 //5 second fire rate with phase cannons
	var/current_charge = 0

	use_power = ACTIVE_POWER_USE
	idle_power_usage = 1000
	active_power_usage = 20000

	var/obj/item/weapon_chip/chip = new /obj/item/weapon_chip

/obj/machinery/power/shipweapon/Initialize()
	. = ..()
	connect_to_network()
	if(chip)
		name = chip.weapon_name
		desc = chip.weapon_desc

/obj/machinery/power/shipweapon/Destroy(force)
	if(force) //Is an admin actually trying to delete it?
		..()
		. = QDEL_HINT_HARDDEL_NOW
	return QDEL_HINT_LETMELIVE

/obj/machinery/power/shipweapon/process()
	. = ..()
	if(stat & (BROKEN|MAINT))
		return
	if(!chip)
		current_charge = 0
		return
	if(!active_power_usage || avail(active_power_usage)) //Is there enough power available
		var/load = min((chip.charge_to_fire - current_charge), charge_rate)		// charge at set rate, limited to spare capacity
		add_load(load) // add the load to the terminal side network
		current_charge = min(current_charge + load, chip.charge_to_fire)

	if(can_fire()) //Load goes down if we can fire
		use_power = IDLE_POWER_USE
		update_icon()
	else
		use_power = ACTIVE_POWER_USE

/obj/machinery/power/shipweapon/proc/can_fire()
	return chip && current_charge >= chip.charge_to_fire

/obj/machinery/power/shipweapon/proc/attempt_fire(mob/user, var/turf/open/indestructible/ftlfloor/T)
	. = ..()
	if(!istype(T))
		return
	if(!can_fire())
		to_chat(user, "<span class='notice'>\the [src] is not ready to fire.</span>")
		return FALSE
	current_charge = 0
	to_chat(user, "<span class='notice'>You fire \the [src]!</span>")
	chip.Fire(T)
	update_icon()

	return TRUE

/obj/machinery/power/shipweapon/attackby(obj/item/W, mob/user, params) //we need better steps again later
	. = ..()
	if(istype(W, /obj/item/weapon_chip) && !chip)
		if(!user.transferItemToLoc(W, src)) return
		name = chip.weapon_name
		desc = chip.weapon_desc
		chip = W
		current_charge = 0
		W.loc = src
		W.add_fingerprint(user)
		to_chat(user, "<span class='notice'>You install \the [W] into \the [src].</span>")

	else if(istype(W, /obj/item/crowbar)) //tear it out
		chip.loc = src.loc
		name = initial(name)
		desc = initial(desc)
		to_chat(user, "<span class='notice'>You remove \the [chip] out of \the [src].</span>")
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
		chip = null

	else if(istype(W, /obj/item/weaponlinker)) //tear it out
		to_chat(user, "<span class='notice'>You tune \the [linker] to the \the [src].</span>")
		var/obj/item/weaponlinker/linker = W
		linker.weapon = src
		

/obj/machinery/power/shipweapon/update_icon()
	. = ..()
	if(can_fire())
		icon_state = "[chip.icon_name]_fire"
	else
		icon_state = "[chip.icon_name]"

/obj/item/weaponlinker
	name = "weapon linker"
	desc = "Used to link a weapon to a console. Use this on a weapons console, and then use it on any weapon to link the two together."

	var/obj/machinery/power/shipweapon/weapon