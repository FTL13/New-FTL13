/obj/item/weapon_chip //Chips that players can use to fire at an enemy
	name = "basic phase cannon chip"
	desc = "I could use this to change the programming of the ship's attack matrix" //lol what does that even mean
	icon = 'ftl/icons/obj/items.dmi'
	icon_state = "chip"

	var/weapon_name = "pewpew machine"
	var/weapon_desc = "machine that does pew pew"
	var/icon_name ="phase_cannon"

	var/datum/player_attack/attack_info = new

	var/obj/machinery/power/shipweapon/weapon

	var/shot_travel_time = 20 //Time it takes between firing, and shot reaching enemy ship.
	var/charge_to_fire = 2000

/obj/item/weapon_chip/proc/Fire(var/turf/open/indestructible/ftlfloor/T)
	WeaponVisuals(T, attack_info) //This is what the players see coming out of the weapon
	addtimer(CALLBACK(src, .proc/ShootShip, T, attack_info), shot_travel_time) //After shot_travel_time, actually send the shot to the enemy ship.

/obj/item/weapon_chip/proc/WeaponVisuals(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info)
	if(prob(35)) //Random chance to spark
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, weapon)
		s.start()

/obj/item/weapon_chip/proc/ShootShip(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info)
	return