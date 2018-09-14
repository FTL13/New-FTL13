/obj/item/weapon_chip //Chips that players can use to fire at an enemy
	name = "basic phase cannon chip"
	desc = "I could use this to change the programming of the ship's attack matrix" //lol what does that even mean
	icon = 'ftl/icons/obj/items.dmi'
	icon_state = "permit"

	var/weapon_name = "Phaser Cannon"
	var/icon_name ="phase_cannon"

	var/attackname = "Ship Attack"

	var/obj/machinery/power/shipweapon/weapon

	var/hull_damage = 0 //How much integrity damage an attack does to an enemy ships hull
	var/shield_damage = 1000 //How much shield damage an attack does. Wont do anything if it penetrates shields.
	var/evasion_mod = 1 //Scalar of the enemy's evasion chance. 0.5 = 50% lower chance to dodge.

	var/traits = NONE //Does this attack cause any specific modifiers?

	var/shot_travel_time = 10 //Time it takes between firing, and shot reaching enemy ship.


	var/fire_sound = 'ftl/sound/effects/phasefire.ogg' //File to play when firing weapon


	var/charge_to_fire = 2000

/obj/item/weapon_chip/proc/Fire(var/turf/T)
	WeaponFire(T) //This is what the players see coming out of the weapon
	addtimer(CALLBACK(src, .proc/ShootShip, T), shot_travel_time) //After shot_travel_time, actually send the shot to the enemy ship.

/obj/item/weapon_chip/proc/WeaponVisuals(var/turf/T)
	if(prob(35)) //Random chance to spark
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(5, 1, weapon)
		s.start()

/obj/item/weapon_chip/proc/ShootShip(var/turf/T)
	return