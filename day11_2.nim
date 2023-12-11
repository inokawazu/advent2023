import system
import std/sequtils
import std/strutils
import std/deques
import std/sets
import std/tables

type
  Location = tuple[row:int, col:int]

const WARP_FACTOR = 1_000_000

#const input = slurp("test11.txt")
const input = slurp("input11.txt")
let lines = input.splitLines(false)[0..^2].mapit(it.toSeq)

func emptyrows(universe: seq[seq[char]]): seq[int] =
  for row in 0..<universe.len:
    var isempty = true
    for col in 0..<universe[row].len:
      if universe[row][col] != '.':
        isempty = false
        break
    if isempty: result.add(row)

func emptycols(universe: seq[seq[char]]): seq[int] =
  for col in 0..<universe[0].len:
    var isempty = true
    for row in 0..<universe.len:
      if universe[row][col] != '.':
        isempty = false
        break
    if isempty: result.add(col)

iterator galaxy_locations(universe: seq[seq[char]]): Location =
  for row in 0..<universe.len:
    for col in 0..<universe[row].len:
      if universe[row][col] == '#': yield (row: row, col: col)

iterator neighbors(loc: Location, universe: seq[seq[char]]): Location =
  let 
    row = loc.row
    col = loc.col
  if row > 0: yield (row: row - 1, col: col)
  if col > 0: yield (row: row, col: col - 1)
  if row < universe.len - 1: yield (row: row + 1, col: col)
  if col < universe[0].len - 1: yield (row: row, col: col + 1)

func `-`(l1, l2 : Location) : Location = (row: l1.row-l2.row, col: l1.col-l2.col)

proc sum_minium_distance_to_other(loc: Location, others: seq[Location], universe: seq[seq[char]]): int =
  var 
    visited = initHashSet[Location]() 
    tovisit = initDeque[(int, Location)]() 
    distance_table = initTable[Location, int]() 
    erows: seq[int] = universe.emptyrows() 
    ecols: seq[int] = universe.emptycols() 
  tovisit.addLast((0, loc)) 

  while tovisit.len > 0: 
    let (distance, cur_loc) = tovisit.popFirst() 

    if distance_table.hasKey(cur_loc): 
      distance_table[cur_loc] = min(distance_table[cur_loc], distance) 
    else: 
      distance_table[cur_loc] = distance
 
    if visited.contains(cur_loc): continue
    visited.incl(cur_loc)

    for next_loc in cur_loc.neighbors(universe):
      let diff = next_loc - cur_loc
      var new_distance: int = distance

      if diff.row != 0 and cur_loc.row in erows: 
        new_distance += WARP_FACTOR
      elif diff.col != 0 and cur_loc.col in ecols:
        new_distance += WARP_FACTOR
      else: 
        new_distance += 1

      tovisit.addLast((new_distance, next_loc))

  for other in others: result += distance_table[other]

let universe = lines
let gls = universe.galaxy_locations().toSeq()

#echo "Between ", ( gls[0], gls[6] )
#echo sum_minium_distance_to_other(gls[0], @[gls[6]], universe)

#echo "Between ", ( gls[2], gls[5] )
#echo sum_minium_distance_to_other(gls[2], @[gls[5]], universe)

#echo "Between ", ( gls[7], gls[8] )
#echo sum_minium_distance_to_other(gls[7], @[gls[8]], universe)

var answer = 0
for i in 0..<gls.len-1: 
  let 
    others = gls[(i+1)..^1]
    dis = sum_minium_distance_to_other(gls[i], others, universe)
  answer += dis

echo "The answer is ", answer
