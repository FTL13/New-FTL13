/obj/machinery/shipweapon/energy //PHYSICAL WEAPON
	name = "phase cannon"
	icon = 'ftl/icons/obj/96x96.dmi'
	icon_state = "phase_cannon"

	var/charge_rate = 400 //5 second fire rate with phase cannons
	var/current_charge = 5000

	var/obj/item/weapon_chip/chip = new /obj/item/weapon_chip/projectile/phase //This defines our behavior when we fire.

/obj/machinery/shipweapon/energy/Initialize()
	. = ..()
	if(chip)
		update_chip()
	current_charge = 5000 //remove this after debugging is done

/obj/machinery/shipweapon/energy/process()
	. = ..()
	if(!chip)
		current_charge = 0
		return

/obj/machinery/shipweapon/energy/can_fire()
	if(chip && (current_charge >= chip.charge_to_fire))
		return TRUE
	else
		return FALSE

/obj/machinery/shipweapon/energy/after_fire()
	//current_charge = 0
	return

/obj/machinery/shipweapon/energy/get_shot_travel_time()
	return (chip?.shot_travel_time)

/obj/machinery/shipweapon/energy/weapon_visuals(T) //Visuals of the weapon itself.
	chip.weapon_visuals(T)

/obj/machinery/shipweapon/energy/hit_ship(T) //The actual attack on the NPC ship
	chip.hit_ship(T)
	return

/obj/machinery/shipweapon/energy/attackby(obj/item/W, mob/user, params) //we need better steps again later
	. = ..()
	if(istype(W, /obj/item/weapon_chip) && !chip)
		if(!user.transferItemToLoc(W, src)) return
		chip = W
		update_chip()
		W.loc = src
		W.add_fingerprint(user)
		to_chat(user, "<span class='notice'>You install \the [W] into \the [src].</span>")

	else if(istype(W, /obj/item/crowbar) && chip) //tear it out
		chip.loc = src.loc
		name = initial(name)
		desc = initial(desc)
		chip.weapon = null
		to_chat(user, "<span class='notice'>You remove \the [chip] out of \the [src].</span>")
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)
		chip = null

	else if(istype(W, /obj/item/weaponlinker)) //tear it out
		var/obj/item/weaponlinker/linker = W
		to_chat(user, "<span class='notice'>You tune \the [linker] to the \the [src].</span>")
		linker.weapon = src
		

/obj/machinery/shipweapon/energy/update_icon()
	. = ..()
	if(!chip)
		return
	if(can_fire())
		icon_state = "[chip.icon_name]_fire"
	else
		icon_state = "[chip.icon_name]"

/obj/machinery/shipweapon/energy/proc/update_chip()
	name = chip.weapon_name
	desc = chip.weapon_desc
	chip.weapon = src
	current_charge = 0
