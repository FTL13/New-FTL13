/datum/shipweapon/projectile
	name = "pewthing"
	desc = "does pew"
	var/shots_fired = 1
	var/shot_delay = 5
	var/fly_in_time = 20 //Time it takes for a projectile to actually fly to the turf in the players view
	var/projectile_icon = "emitter"

/datum/shipweapon/projectile/fire()
	. = ..()

	var/pix_x
	var/pix_y
	var/angle = 0
	var/rand_coord = rand(-1000,1000)
	var/list/rand_edge = list(1,-1)
	if(prob(50)) // gets random location at the edge of a box
		pix_x = rand_coord
		pix_y = pick(rand_edge) * 1000
	else
		pix_x = pick(rand_edge) * 1000
		pix_y = rand_coord
	angle = ATAN2(0-pix_y, 0-pix_x)
	var/matrix/M = new
	M.Turn(angle + 180)

	var/area/A = pick(GLOB.the_station_areas) //which area is going to get fucked

	for(var/i in 1 to shots_fired)
		var/turf/T = safepick(get_area_turfs(A)) //Pick a turf in our area
		var/fucked_time = shot_travel_time + shot_delay*i //This is when we're going to get fucked

		new /obj/effect/temp_visual/ship_target(T, fucked_time + fly_in_time) //A warning beacon that'll stay at this location until the target is hit
		addtimer(CALLBACK(src, .proc/SpawnShipProjectile, T, M, pix_x, pix_y, fly_in_time), fucked_time)

/datum/shipweapon/projectile/damage_effects(var/turf/T)
	. = ..()

/datum/shipweapon/projectile/proc/SpawnShipProjectile(var/turf/T, var/matrix/M, var/pix_x, var/pix_y) //projectile that actually hits the ship
	var/obj/effect/ship_projectile/enemy/A = new(T, M, pix_x, pix_y, fly_in_time)
	A.icon_state = projectile_icon
