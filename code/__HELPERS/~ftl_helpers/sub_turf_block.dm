/datum/sub_turf_block
  var/x1
  var/y1
  var/z1
  var/x2
  var/y2
  var/z2

/datum/sub_turf_block/New(x1, y1, z1, x2, y2, z2)
  src.x1 = x1
  src.y1 = y1
  src.z1 = z1
  src.x2 = x2
  src.y2 = y2
  src.z2 = z2

/datum/sub_turf_block/proc/return_list()
  return block(locate(x1, y1, z1), locate(x2, y2, z2))

proc/split_block(turf/T1, turf/T2)
  var/x1 = min(T1.x, T2.x)
  var/y1 = min(T1.y, T2.y)
  var/z1 = min(T1.z, T2.z)
  var/x2 = max(T1.x, T2.x)
  var/y2 = max(T1.y, T2.y)
  var/z2 = max(T1.z, T2.z)
  var/list/sub_blocks = list()
  for(var/z in z1 to z2)
    for(var/b_y1 = y1, b_y1 <= y2, b_y1 += 32)
      for(var/b_x1 = x1, b_x1 <= x2, b_x1 += 32)
        var/b_x2 = min(b_x1 + 31, x2)
        var/b_y2 = min(b_y1 + 31, y2)
        sub_blocks += new /datum/sub_turf_block(b_x1, b_y1, z, b_x2, b_y2, z)
  return sub_blocks
