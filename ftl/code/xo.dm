/datum/job/hop
	title = "Executive Officer"

/datum/outfit/job/hop
	name = "Executive Officer"

/obj/item/pda/heads/hop
	name = "executive officer PDA"

/obj/item/radio/headset/heads/hop
	name = "\proper the executive officer's headset"

/obj/item/encryptionkey/heads/hop
	name = "\proper the executive officer's encryption key"

/obj/item/stamp/hop
	name = "executive officer's rubber stamp"

/obj/structure/closet/secure_closet/hop
	name = "\proper executive officer's locker"

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Executive Officer\"."
	name = "executive officer's jumpsuit"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "executive officer's suit"

/obj/item/clothing/head/hopcap
	name = "executive officer's cap"

/obj/item/clothing/head/collectable/HoP
	name = "collectable XO hat"

/obj/item/clothing/neck/cloak/hop
	name = "executive officer's cloak"
	desc = "Worn by the Executive Officer. It smells faintly of bureaucracy."

//GLOB.command_positions += "Executive Officer"
//GLOB.supply_positions += "Executive Officer"
// rip Floyd's dream of not modifying /tg/ code when adding XO 2k18

// also modified code/game/objects/items/cardboard_cutouts.dm
// and code/modules/jobs/access.dm
// and code/_globalvars/lists/flavor_misc.dm
// and code/modules/paperwork/contract.dm
// and code/game/objects/items/stacks/sheets/mineral.dm
// and code/game/gamemodes/revolution/revolution.dm

/********************************/
/*override all the HoP things!!!*/
/********************************/

// the overrides below here can be changed or removed entirely, i just put them here so the transformation would be COMPLETE
// note: missing transformations in the following files:
// paper_premade.dm: /obj/item/paper/fluff/jobs/jobs info - would be too damn long
// the computer stuff, which has the HoP hardcoded, probably shouldn't override that one
// also valentine's day holiday

/obj/item/storage/photo_album/HoP
	persistence_id = "XO"

/obj/item/toy/figure/hop
	name = "Executive Officer action figure"

/obj/item/bedsheet/hop
	name = "executive officer's bedsheet"
	dream_messages = list("authority", "a silvery ID", "obligation", "a computer", "an ID", "a corgi", "the executive officer")

/obj/item/reagent_containers/food/snacks/burger/plain/Initialize()
	. = ..()
	if(prob(1))
		new/obj/effect/particle_effect/smoke(get_turf(src))
		playsound(src, 'sound/effects/smoke.ogg', 50, TRUE)
		visible_message("<span class='warning'>Oh, ye gods! [src] is ruined! But what if...?</span>")
		name = "steamed ham"
		desc = pick("Ahh, Executive Officer, welcome. I hope you're prepared for an unforgettable luncheon!",
		"And you call these steamed hams despite the fact that they are obviously microwaved?",
		"Aurora Station 13? At this time of shift, in this time of year, in this sector of space, localized entirely within your freezer?",
		"You know, these hamburgers taste quite similar to the ones they have at the Maltese Falcon.")
		tastes = list("fast food hamburger" = 1)

/obj/item/banner/command
	job_loyalties = list("Captain", "Executive Officer", "Chief Engineer", "Head of Security", "Research Director", "Chief Medical Officer")

/area/crew_quarters/heads/hop
	name = "Executive Officer's Office"

/obj/effect/landmark/start/head_of_personnel
	name = "Executive Officer"
	icon_state = "Executive Officer" // there was a warning in the file I took this from, it was Head of Personnel before, incase something breaks

/obj/structure/noticeboard/hop
	name = "Executive Officer's Notice Board"
	desc = "Important notices from the Executive Officer."

/obj/structure/statue/gold/hop
	name = "statue of the executive officer"

/datum/game_mode/cult
	restricted_jobs = list("Chaplain", "AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain", "Executive Officer")

/obj/machinery/vending/games
	desc = "Vends things that the Captain and Executive Officer are probably not going to appreciate you fiddling with instead of your job..."

/obj/machinery/vending/toyliberationstation
	product_slogans = "Get your cool toys today!;Trigger a valid hunter today!;Quality toy weapons for cheap prices!;Give them to XOs for all access!;Give them to HoS to get permabrigged!"

/mob/living/simple_animal/pet/dog/corgi/Ian
	desc = "It's the XO's beloved corgi."

/mob/living/simple_animal/pet/dog/corgi/Ian/Initialize()
	. = ..()
	//parent call must happen first to ensure IAN
	//is not in nullspace when child puppies spawn
	Read_Memory()
	if(age == 0)
		var/turf/target = get_turf(loc)
		if(target)
			var/mob/living/simple_animal/pet/dog/corgi/puppy/P = new /mob/living/simple_animal/pet/dog/corgi/puppy(target)
			P.name = "Ian"
			P.real_name = "Ian"
			P.gender = MALE
			P.desc = "It's the XO's beloved corgi puppy."
			Write_Memory(FALSE)
			return INITIALIZE_HINT_QDEL
	else if(age == record_age)
		icon_state = "old_corgi"
		icon_living = "old_corgi"
		icon_dead = "old_corgi_dead"
		desc = "At a ripe old age of [record_age] Ian's not as spry as he used to be, but he'll always be the XO's beloved corgi." //RIP
		turns_per_move = 20

/**********************/
/*fix department heads*/
/**********************/

/datum/job/clown
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/mime
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/curator
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/lawyer
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/chaplain
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/qm
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/cargo_tech
	department_head = list("Executive Officer")
	supervisors = "the quartermaster and the executive officer"

/datum/job/mining
	department_head = list("Executive Officer")
	supervisors = "the quartermaster and the executive officer"

/datum/job/bartender
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/cook
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/hydro
	department_head = list("Executive Officer")
	supervisors = "the executive officer"

/datum/job/janitor
	department_head = list("Executive Officer")
	supervisors = "the executive officer"











































































