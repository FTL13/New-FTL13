/obj/item/weapon_chip //Chips used by energy weapons
	name = "basic phase cannon chip"
	desc = "I could use this to change the programming of the ship's attack matrix" //lol what does that even mean
	icon = 'ftl/icons/obj/items.dmi'
	icon_state = "chip"

	var/weapon_name = "pewpew machine"
	var/weapon_desc = "machine that does pew pew"
	var/icon_name ="phase_cannon"

	var/datum/player_attack/attack_info = new

	var/obj/machinery/shipweapon/energy/weapon
	var/charge_to_fire = 2000
	var/shot_travel_time = 50

/obj/item/weapon_chip/proc/weapon_visuals(var/turf/open/indestructible/ftlfloor/T)
	return

/obj/item/weapon_chip/proc/hit_ship(var/turf/open/indestructible/ftlfloor/T)
	return