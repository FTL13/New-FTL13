/datum/shipweapon
	var/name = "ass destroyer"
	var/desc = "holy shit this gun destroys ass"

	var/datum/starship/our_ship

	var/hull_damage = 1 //How much integrity damage an attack does to the player's ship
	var/shield_damage = 1 //How much shield damage an attack does. Wont do anything if it penetrates shields.
	var/evasion_mod = 1 //Scalar of the player's evasion chance. 0.5 = 50% lower chance to dodge.
	var/fire_sound = 'ftl/sound/ship_combat/phasefire.ogg'
	var/shot_travel_time = 50 //5 seconds of FUCKING RUN time
	var/fire_delay = 70 //Time between volleys.

	var/firetimerid

	var/traits = NONE //Does this attack cause any specific modifiers? unused atm

/datum/shipweapon/Destroy()
	stop_firing()

/datum/shipweapon/proc/start_firing()
	firetimerid = addtimer(CALLBACK(src, .proc/fire), fire_delay * our_ship.firerate_modifier, TIMER_STOPPABLE)
	//Spawn the warning beacon here

/datum/shipweapon/proc/stop_firing()
	if(firetimerid)
		deltimer(firetimerid)

/datum/shipweapon/proc/fire()
	firetimerid = addtimer(CALLBACK(src, .proc/fire), fire_delay * our_ship.firerate_modifier, TIMER_STOPPABLE) //Prepare next shot instantly

/datum/shipweapon/proc/get_affected_turfs()
	return

/datum/shipweapon/proc/damage_effects(var/turf/T)
	SSplayer_ship.hit(src)