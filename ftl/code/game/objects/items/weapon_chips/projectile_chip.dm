/obj/item/weapon_chip/projectile
	var/fire_delay = 5 //Time between shots
	var/shots_fired = 1
	var/projectile_icon = "laser"

/obj/item/weapon_chip/projectile/weapon_visuals(var/turf/open/indestructible/ftlfloor/T)
	.=..()
	for(var/i in 1 to shots_fired) //Fire for the amount of time
		addtimer(CALLBACK(src, .proc/SpawnProjectile, T), fire_delay*i)

/obj/item/weapon_chip/projectile/proc/SpawnProjectile() //Projectile that flies out of the gun and dissapears, exists for visual aesthetic
	var/obj/item/projectile/ship_projectile/A = new(weapon.loc)
	A.icon_state =  projectile_icon
	A.setDir(EAST)
	A.pixel_x = 32
	A.pixel_y = 12
	A.yo = 0
	A.xo = 20
	A.starting = weapon
	A.fire()
	message_admins("pew")

	playsound(weapon, attack_info.fire_sound, 50, 1)

/obj/item/weapon_chip/projectile/hit_ship(var/turf/open/indestructible/ftlfloor/T) //Real attack
	
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

	var/datum/starship/S = T.GetOurShip()

	message_admins("fire real projectile")
	for(var/i in 1 to shots_fired)
		if(prob(S.get_dodge_chance()))
			message_admins("shot missed")
			continue
		if(S.shield_integrity) //shot blocked by shields TODO: Make this visibly hit the shields and add actual visual shields.
			S.ShieldHit(attack_info)
			message_admins("shield")
			continue
		addtimer(CALLBACK(src, .proc/SpawnShipProjectile, T, attack_info, M, pix_x, pix_y), fire_delay*i)

/obj/item/weapon_chip/projectile/proc/SpawnShipProjectile(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info, var/matrix/M, var/pix_x, var/pix_y) //projectile that actually hits the ship
	var/obj/effect/ship_projectile/A = new(T, attack_info, M, pix_x, pix_y)
	A.icon_state = projectile_icon

/obj/item/weapon_chip/projectile/phase
	fire_delay = 5 //Time between shots
	shots_fired = 3