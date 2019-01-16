datum/shipweapon
	var/name = "ass destroyer"
	var/desc = "holy shit this gun destroys ass"

	var/hull_damage = 1 //How much integrity damage an attack does to the player's ship
	var/shield_damage = 1 //How much shield damage an attack does. Wont do anything if it penetrates shields.
	var/evasion_mod = 1 //Scalar of the player's evasion chance. 0.5 = 50% lower chance to dodge.
	var/fire_sound = 'ftl/sound/ship_combat/phasefire.ogg'
	var/shot_travel_time = 50 //5 seconds of FUCKING RUN time

	var/firetimerid

	var/traits = NONE //Does this attack cause any specific modifiers? unused atm

datum/shipweapon/proc/fire()
	//spawn the warning beacon here for shot_travel_time duration
	return

datum/shipweapon/proc/visual_effects(var/turf/T)
	return

datum/shipweapon/proc/damage_effects(var/turf/T)
	SSplayer_ship.hit(src)

datum/shipweapon/projectile
	name = "pewthing"
	desc = "does pew"
	var/shots_fired = 1
	var/fire_delay = 5

datum/shipweapon/projectile/fire()
	var/area/A = pick(GLOB.the_station_areas) //which area is going to get fucked
	for(var/i in 1 to shots_fired)
		var/turf/T = safepick(get_area_turfs(A)) //Pick a turf in our area
		addtimer(CALLBACK(src, .proc/visual_effects, T), fire_delay*i)


datum/shipweapon/projectile/visual_effects(var/turf/T)
	//make the projectile move in like old ftl here
	. = ..()
	damage_effects(T)

datum/shipweapon/projectile/damage_effects(var/turf/T)
	. = ..()
