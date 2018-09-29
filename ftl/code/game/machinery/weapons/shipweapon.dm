/obj/machinery/shipweapon //PHYSICAL WEAPON
	name = "phase cannon"
	desc = "yell at someone to fix this."
	icon = 'ftl/icons/obj/96x96.dmi'
	icon_state = "phase_cannon"
	dir = EAST
	pixel_x = -32
	pixel_y = -23
	anchored = TRUE
	density = TRUE

	var/shot_travel_time = 0 //Time it takes between firing, and shot reaching enemy ship.

/obj/machinery/shipweapon/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/shipweapon/Destroy(force)
	if(force) //Is an admin actually trying to delete it?
		..()
		. = QDEL_HINT_HARDDEL_NOW
	return QDEL_HINT_LETMELIVE

/obj/machinery/shipweapon/process()
	. = ..()
	if(stat & (BROKEN|MAINT))
		return
	if(!chip)
		current_charge = 0
		return
	if(can_fire()) //Load goes down if we can fire
		update_icon()

/obj/machinery/shipweapon/proc/can_fire()
		return FALSE

/obj/machinery/shipweapon/proc/attempt_fire(mob/user, var/turf/open/indestructible/ftlfloor/T)
	if(!istype(T))
		return
	if(!can_fire())
		to_chat(user, "<span class='notice'>\the [src] is not ready to fire.</span>")
		return FALSE
	//current_charge = 0
	to_chat(user, "<span class='notice'>You fire \the [src]!</span>")
	weapon_visuals(T, attack_info)
	addtimer(CALLBACK(src, .proc/hit_ship, T), shot_travel_time) //After shot_travel_time, actually send the shot to the enemy ship.
	after_fire() //Extra options such as resetting charge after firing
	update_icon()

	return TRUE

/obj/machinery/shipweapon/proc/after_fire()
	return

/obj/machinery/shipweapon/proc/weapon_visuals(T) //Visuals of the weapon itself.
	if(prob(35)) //Random chance to spark
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, weapon)
		s.start()
	return

/obj/machinery/shipweapon/proc/hit_ship(T) //The actual attack on the NPC ship
	return

/obj/item/weaponlinker
	name = "weapon linker"
	desc = "Used to link a weapon to a console. Use this on a weapons console, and then use it on any weapon to link the two together."
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"

	var/obj/machinery/shipweapon/weapon