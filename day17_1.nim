# Broken 
import system
import std/strutils
import std/sequtils
import std/deques
import std/tables
import std/sets
import std/math

type
  Location = tuple
    row: int
    col: int
  Direction = tuple
    row: int
    col: int

func `[]`[T](input: seq[seq[T]], loc: Location): T = input[loc.row][loc.col]

func `+`(location: Location, direction: tuple[row: int, col: int]): Location = 
  return (row: location.row + direction.row, col: location.col + direction.col)

func contains[T](input: seq[seq[T]], loc: Location): bool =
  return loc.row >= 0 and loc.col >= 0 and loc.row < input.len and loc.col < input[loc.row].len

func parse_input(input: string): seq[seq[int]] =
  let lines = input.strip.splitLines
  for line in lines:
    var digits = newSeq[int]()
    for digit_char in line: digits.add(parseInt($digit_char))
    result.add(digits)

iterator cardinal_dirs: Direction =
  yield (1, 0)
  yield (-1, 0)
  yield (0, 1)
  yield (0, -1)

func minimum_heat_loss_simple(grid: seq[seq[int]]): int =
  var 
    heats = initTable[Location, int]()
    tovisit = initDeque[tuple[location: Location, heat: int]]()
  tovisit.addLast(((0,0), 0))
  while tovisit.len > 0:
    let (current_location, current_heat) = tovisit.popFirst()
    if heats.hasKeyOrPut(current_location, current_heat):
      heats[current_location] = min(heats[current_location], current_heat)
      continue

    for dir in cardinal_dirs():
      let next_location = current_location + dir
      if not (next_location in grid): continue
      let next_heat  = current_heat + grid[next_location]
      tovisit.addLast((location: next_location, heat: next_heat))

  return heats[(row: grid.len - 1, col: grid[0].len - 1)]

proc print_progress[T](input: seq[seq[T]], ets: Table[Location, int]): void =
  for row in 0..<input.len:
    for col in 0..<input[row].len:
      let loc: Location = (row, col)
      if ets.haskey(loc):
        stdout.write '#'
      else:
        stdout.write input[loc]
    stdout.write '\n'

const MAX_CONT = 3
proc minimum_heat_loss(grid: seq[seq[int]]): int =
  var 
    heats = initTable[Location, int]()
    visited = initHashSet[tuple[location: Location, tendency: Direction]]()
    tovisit = initDeque[tuple[location: Location, tendency: Direction, heat: int]]()
  tovisit.addLast(((0, 1), (0, 1), grid[(0, 1)]))

  while tovisit.len > 0:
    let (current_location, current_tendency, current_heat) = tovisit.popFirst()

    # echo (current_location, current_tendency)
    assert current_tendency.row * current_tendency.col == 0
    #print_progress(grid, heats)
    #echo ""

    if heats.hasKeyOrPut(current_location, current_heat):
      heats[current_location] = min(heats[current_location], current_heat)

    let current_loc_ten = (location: current_location, tendency: current_tendency)
    if visited.containsOrIncl(current_loc_ten): continue

    for dir in cardinal_dirs():
      let next_location = current_location + dir
      if not (next_location in grid): continue

      # cannot go backwards
      if dir.row * current_tendency.row < 0 or dir.col * current_tendency.col < 0:
        #echo (dir: dir, tend: current_tendency)
        continue

      var next_tendency: Direction
      # can only turn left or right 90 or continue straight
      if dir.row * current_tendency.row == 0 and dir.col * current_tendency.col == 0:
        #echo (dir: dir, tend: current_tendency)
        next_tendency = dir
      else:
        #echo (dir: dir, tend: current_tendency)
        next_tendency = current_tendency + dir

      # can only travel up to 3 in one direction
      if next_tendency.row.abs > MAX_CONT or next_tendency.col.abs > MAX_CONT: 
        #echo "hit max"
        continue
      let next_heat = current_heat + grid[next_location]
      #echo "For dir = ", dir, " and ", (location: current_location, tendency: current_tendency), " to ", (location: next_location, tendency: next_tendency)
      tovisit.addLast((location: next_location, tendency: next_tendency, heat: next_heat))

  for row in 0..<grid.len:
    for col in 0..<grid[row].len:
      let loc: Location = (row, col)
      if heats.haskey(loc):
        stdout.write(heats[loc], "\t")
      else:
        stdout.write grid[loc]
    stdout.write '\n'
  return heats[(row: grid.len - 1, col: grid[0].len - 1)]

let test_input = """
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
""".parse_input #.strip.splitLines.mapIt(it.toSeq.map(parseInt))

#for r in test_input: echo r.join

echo test_input.minimum_heat_loss_simple
echo test_input.minimum_heat_loss

#echo readFile("input17.txt").parse_input.minimum_heat_loss
