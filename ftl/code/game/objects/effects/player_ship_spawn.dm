/obj/effect/landmark/player_ship_spawn
  name = "Player ship spawn marker"
  var/template_name = '_maps/_FTL/map_files/testship/testship.dmm'

/obj/effect/landmark/player_ship_spawn/Initialize()
  . = ..()
  var/datum/map_template/ship = new(template_name) //If we do this here we bypass https://github.com/tgstation/tgstation/issues/40602
  ship.load(loc, TRUE) //~~fuck multiz~~



  /obj/effect/landmark/player_ship_spawn/testship
    name = "testship spawn marker"
