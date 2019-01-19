/turf/ftl_contents_explosion(severity, target)
	var/affecting_level
	if(severity == 1)
		affecting_level = 1
	else if(is_shielded())
		affecting_level = 3
	else if(intact)
		affecting_level = 2
	else
		affecting_level = 1

	for(var/V in contents)
		var/atom/A = V
		if(!QDELETED(A) && A.level >= affecting_level)
			if(ismovableatom(A))
				var/atom/movable/AM = A
				if(!AM.ex_check(explosion_id))
					continue
			if(ismob(A))
				A.ex_act(severity, target)//Fuck you, you dont get special treatment.
			A.ftl_ex_act(severity, target)
			CHECK_TICK

/turf/open/floor
	var/explosion_damage_level = 0

/turf/open/floor/ftl_ex_act(severity, target)
	. = ..()
	switch(severity)
		if(1)
			if(prob(40))
				adjust_ftl_damage(3)
			else if(prob(30))
				adjust_ftl_damage(2)
			else
				adjust_ftl_damage(1)
		if(2)
			if(prob(40))
				adjust_ftl_damage(2)
			else if(prob(20))
				adjust_ftl_damage(1)
		if(3)
			if(prob(50))
				adjust_ftl_damage(1)

/turf/open/floor/welder_act(mob/living/user, obj/item/I)
	. = ..()
	if(explosion_damage_level)
		to_chat(user, "<span class='notice'>You start welding \the [src].</span>")
		if(do_after(user, 30, target = src))
			to_chat(user, "<span class='notice'>You repair some of the damage to \the [src].</span>")
			adjust_ftl_damage(-1)

/turf/open/floor/proc/adjust_ftl_damage(change)
	explosion_damage_level = CLAMP(explosion_damage_level += change, 0, 3)
	cut_overlays()
	if(explosion_damage_level)
		var/mutable_appearance/hit_overlay = mutable_appearance('ftl/icons/effects/turf_breach.dmi', "damage-[explosion_damage_level]")
		add_overlay(hit_overlay)
		AddComponent(/datum/component/airsiphon, 3 * explosion_damage_level)
