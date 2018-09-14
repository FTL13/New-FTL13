obj/item/projectile/ship_projectile //Is purely visual, unless you stand infront of it.

	name = "ship projectile"
	range = 20

	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 100
	luminosity = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	animate_movement = SLIDE_STEPS //copies all the shit from the emitter beam



////BELOW IS PURELY VISUAL FOR UI PURPOSES

/obj/effect/temp_visual/shipprojectile //even more visual
	name = "Phase Cannon shot"
	desc = "HOLY FUCK GET TO COVER"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "emitter"
	luminosity = 5

	duration = 5

/obj/effect/temp_visual/ship_target/ex_act()
	return

/obj/effect/temp_visual/ship_projectile/Initialize(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info, var/duration = 20)
	. = ..()
	var/angle = 0
	var/rand_coord = rand(-1000,1000)
	var/list/rand_edge = list(1,-1)
	if(prob(50)) // gets random location at the edge of a box
		pixel_x = rand_coord
		pixel_y = pick(rand_edge) * 1000
	else
		pixel_x = pick(rand_edge) * 1000
		pixel_y = rand_coord
	angle = ATAN2(0-pixel_y, 0-pixel_x)
	var/matrix/M = new
	M.Turn(angle + 180)
	transform = M //rotates projectile in direction
	animate(src, pixel_x = 0, pixel_y = 0, time = duration)
	addtimer(CALLBACK(src, .proc/hit, T, attack_info), duration)


/obj/effect/temp_visual/ship_projectile/proc/hit(var/turf/open/indestructible/ftlfloor/T, var/datum/attack_info)
	T.HitByShipProjectile(attack_info)
	layer = 0.1 //to prevent it from being seen while we wait for it to be deleted
	qdel(src)