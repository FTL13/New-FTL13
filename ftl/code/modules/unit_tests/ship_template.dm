
/datum/unit_test/ship_templates/run()
  var/failreason
  for(var/spawner_typless in subtypesof(/obj/effect/landmark/player_ship_spawn))
    var/obj/effect/landmark/player_ship_spawn/spawner = spawner_typless
    var/datum/parsed_map/P = new(initial(spawner.template_name)) //Parse the template
    P.build_cache() //Parse grid_models
    var/list/count = list()
    for(var/model in P.modelCache)
      for(var/T in P.modelCache[model][1])
        if((T.type == /turf/open/space || T.type == /turf/open/space/basic) //Replace only these space turfs)
          count[T] += 1
    if(count.len > 0)
      for(var/turf in count)
        failreason += "[count[turf]] [turf] exist within [initial(spawner.template_name)]. Replace with '/turf/open/space/transit/ftl' | "
  if(failreason)
    Fail(failreason)
