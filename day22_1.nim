import system
import strutils
import sequtils
import tables
import sets
import heapqueue
import algorithm

type 
  Location = tuple[ x: int, y: int, z: int ]
  Brick = tuple[l: Location, r: Location]

iterator locations(b: Brick): Location =
  let (l, r) = b
  for x in l.x..r.x:
    for y in l.y..r.y:
      for z in l.z..r.z:
        yield (x, y, z)

func bcmp(a, b: Brick): int = cmp(a.l.z, b.l.z)

func lower(b: Brick): Brick =
  result = b
  result.l.z -= 1
  result.r.z -= 1

func putup(b: Brick): Brick =
  result = b
  result.l.z += 1
  result.r.z += 1

func process_input(input: string): seq[Brick] =
  for line in input.strip.splitLines:
    let 
      leftright = line.split('~').mapIt(it.split(',').map(parseInt))
      left: Location = (leftright[0][0], leftright[0][1], leftright[0][2])
      right: Location = (leftright[1][1], leftright[1][1], leftright[1][2])
    result.add((left, right))

proc solve(input: seq[Brick]): int =
  let bricks = input.sorted(bcmp)
  var 
    fixed_locations = initTable[Location, int]()
  for ( id, brick ) in zip((1..bricks.len).toSeq, bricks):
    var falling_brick = brick
    while not falling_brick.locations.toSeq.allIt(fixed_locations.hasKey(it)) and falling_brick.l.z > 0:
      falling_brick = falling_brick.lower

    for location in falling_brick.putup.locations:
      fixed_locations[location] = id

  for remove_id in 1..bricks.len:
    var can_remove = true

    for ( id, other_brick ) in zip((1..bricks.len).toSeq, bricks):
      let lowered_other = other_brick.lower

      if id == remove_id: continue
      if lowered_other.l.z <= 0:
        can_remove = true
        continue

      var has_support = false
      for check_loc in lowered_other.locations:
        has_support = has_support or (fixed_locations.hasKey(check_loc) and fixed_locations[check_loc] != remove_id)
      can_remove = can_remove or has_support
    if can_remove: result += 1

let test_input = """
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
""".process_input

echo test_input
echo test_input.solve
