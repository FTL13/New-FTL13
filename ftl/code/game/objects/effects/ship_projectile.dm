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



////BELOW IS PURELY TO LOOK FANCY

/obj/effect/playership_projectile //even more visual
	name = "Phase Cannon shot"
	desc = "HOLY FUCK GET TO COVER"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "emitter"
	luminosity = 5

/obj/effect/ship_projectile/Initialize(var/turf/T, var/matrix/M, pix_x, pix_y, var/duration = 20)
	. = ..()
	pixel_x = pix_x
	pixel_y = pix_y
	transform = M //rotates projectile in direction
	message_admins("projectile is flying in now")
	animate(src, pixel_x = 0, pixel_y = 0, time = duration)
	addtimer(CALLBACK(src, .proc/hit, loc), duration)

/obj/effect/ship_projectile/proc/hit()
	layer = 0.1 //to prevent it from being seen while we wait for it to be deleted
	message_admins("projectile is kill")
	qdel(src)

/obj/effect/ship_projectile/player

/obj/effect/ship_projectile/enemy


/obj/effect/temp_visual/ship_target
	icon = 'ftl/icons/effects/target.dmi'
	icon_state = "target"
	layer = BELOW_MOB_LAYER
	duration = 5

/obj/effect/temp_visual/ship_target/Initialize(var/turf/T, var/duration)
	playsound(T, 'ftl/sound/effects/hit_warning.ogg', 50,0)
	set_light(5, 15, "#ff0000")
	addtimer(CALLBACK(src, .proc/SelfDestruct), duration)

/obj/effect/temp_visual/ship_target/proc/SelfDestruct()
	layer = 0.1 //to prevent it from being seen while we wait for it to be deleted
	qdel(src)

/obj/effect/ship_target/ex_act()
	return
