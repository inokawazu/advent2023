import system
import std/sequtils
import std/strutils
import std/algorithm
import std/deques
import std/sets

type
  Location = tuple[row:int, col:int]

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

proc expand_universe(lines: seq[seq[char]]): seq[seq[char]] =
  var expanded = newSeq[seq[char]]()
  let 
    ecols = lines.emptycols()
    erows = lines.emptyrows()
  
  for line in lines: expanded.add(line)

  for line in expanded.mitems:
    for col in ecols.reversed:
      line.insert('.', col)

  let necols = expanded[0].len
  for row in erows.reversed:
    var newrow = newSeq[char]()
    for col in 0..<necols: newrow.add('.')
    expanded.insert(newrow, row)

  return expanded

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

func minium_distance_to_other(loc: Location, other: Location, universe: seq[seq[char]]): int =
  var
    visited = initHashSet[Location]()
    tovisit = initDeque[(int, Location)]()
  tovisit.addLast((0, loc))
  while tovisit.len > 0:
    let (distance, cur_loc) = tovisit.popFirst
    if visited.contains(cur_loc): continue
    visited.incl(cur_loc)
    
    if cur_loc == other: return distance

    for next_loc in cur_loc.neighbors(universe):
      tovisit.addLast((distance + 1, next_loc))

# echo lines
# echo expand_universe(lines)

let expanded_universe = lines.expand_universe
let gls = expanded_universe.galaxy_locations().toSeq()

var answer = 0
for i in 0..<gls.len: 
  for j in ( i+1 )..<gls.len: 
    let dis = minium_distance_to_other(gls[i], gls[j], expanded_universe)
    answer += dis

echo "The answer is ", answer
