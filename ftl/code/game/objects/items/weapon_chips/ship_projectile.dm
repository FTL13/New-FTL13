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
	legacy = 1
	animate_movement = SLIDE_STEPS //copies all the shit from the emitter beam



////BELOW IS PURELY VISUAL FOR UI PURPOSES

/obj/effect/overlay/temp/shipprojectile //even more visual
	name = "Phase Cannon shot"
	desc = "HOLY FUCK GET TO COVER"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "emitter"
	luminosity = 5
	unacidable = 1
	duration = 5

/obj/effect/overlay/temp/ship_target/ex_act()
	return

/obj/effect/overlay/temp/ship_projectile/New(var/turf/open/indestructible/ftlfloor/T, var/datum/player_attack/attack_info, var/duration = 20)
	var/angle = 0
	var/rand_coord = rand(-1000,1000)
	var/list/rand_edge = list(1,-1)
	icon_state = A.projectile_effect
 	if(prob(50)) // gets random location at the edge of a box
		pixel_x = rand_coord
		pixel_y = pick(rand_edge) * 1000
	else
		pixel_x = pick(rand_edge) * 1000
		pixel_y = rand_coord
 	angle = Atan2(0-pixel_y, 0-pixel_x)
 	var/matrix/M = new
	M.Turn(angle + 180)
	transform = M //rotates projectile in direction
 	animate(src, pixel_x = 0, pixel_y = 0, time = duration)
	addtimer(CALLBACK(src, .proc/spawn_projectile), duration)


/obj/effect/overlay/temp/ship_projectile/proc/hit(var/turf/open/indestructible/ftlfloor/T, var/datum/attack_info)
	T.damage_effects(attack_info)
	layer = 0.1 //to prevent it from being seen while we wait for it to be deleted
	qdel(src)