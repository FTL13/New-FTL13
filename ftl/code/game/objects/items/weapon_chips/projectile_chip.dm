/obj/item/weapon_chip/projectile
	var/fire_delay = 5 //Time between shots
	var/shots_fired = 1
	var/projectile_icon = "laser"

/obj/item/weapon_chip/projectile/WeaponVisuals(var/turf/open/indestructible/ftlfloor/T)
	.=..()
	for(var/i in 1 to chip.attack_data.shots_fired) //Fire for the amount of time
		addtimer(CALLBACK(src, .proc/spawn_projectile), fire_delay*i)


/obj/item/weapon_chip/projectile/SpawnProjectile()
	var/obj/item/projectile/ship_projectile/A = new(src.loc)
	A.icon_state =  projectile_icon
	A.setDir(EAST)
	A.pixel_x = 32
	A.pixel_y = 12
	A.yo = 0
	A.xo = 20
	A.starting = loc
	A.fire()

	playsound(loc, attack_info.fire_sound, 50, 1)

/obj/item/weapon_chip/projectile/ShootShip(var/turf/open/indestructible/ftlfloor/T)
	var/datum/starship/S = T.GetOurShip()
	if(S.shield_integrity) //shot blocked by shields TODO: Make this visibly hit the shields and add actual visual shields.
		S.ShieldHit(attack_info)
		return
	var/obj/item/projectile/ship_projectile/A = new(T, attack_info)
	A.icon_state =  projectile_icon
	return

/obj/item/weapon_chip/projectile/phase
	fire_delay = 5 //Time between shots
	shots_fired = 3