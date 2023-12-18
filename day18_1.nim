# Broken 
import system
import std/strutils
import std/sequtils
import std/tables
import std/sets

type
  Instruction = tuple
    direction: char
    steps: int
    color: string
  Location = tuple
    row: int
    col: int

func parse_input(s: string): seq[Instruction] =
  for line in s.strip.splitLines:
    let entries = line.splitWhitespace()
    assert entries.len == 3
    let
      dir = entries[0][0]
      steps = entries[1].parseInt
      color = entries[2]
    result.add((dir, steps, color))

let test_input = """
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)""".parse_input()

func make_map(insts: seq[Instruction], start: Location): OrderedSet[Location] =
  var 
    locations = initOrderedSet[Location]()
    current_location = start
  for inst in insts:
    let dir = inst.direction
    var steps = inst.steps
    while steps > 0:
      case dir:
        of 'R':
          current_location.col += 1
        of 'L':
          current_location.col -= 1
        of 'U':
          current_location.row -= 1
        of 'D':
          current_location.row += 1
        else: 
          assert(false,("Invalid direction " & $dir))
      locations.incl(current_location)
      steps -= 1
  return locations

func find_area(map: OrderedSet[Location]): int =
  let 
    min_row = map.mapIt(it[0]).min
    min_col = map.mapIt(it[1]).min
    max_row = map.mapIt(it[0]).max
    max_col = map.mapIt(it[1]).max

  var 
    outside_locs = OrderedSet[Location]()
    tovisit = newSeq[Location]()

  tovisit.add((min_col+1, min_col-1))
  while tovisit.len > 0:
    let 
      loc = tovisit.pop()
      (row, col) = loc
    if outside_locs.containsOrIncl(loc): continue

    for (drow, dcol) in @[(1, 0), (-1, 0), (0, 1), (0, -1)]:
      let
        new_row = drow + row 
        new_col = dcol + col
      if new_row < min_row - 1: continue
      if new_col < min_col - 1: continue
      if new_row > max_row + 1: continue
      if new_col > max_col + 1: continue
      if map.contains((new_row, new_col)): continue

      tovisit.add((new_row, new_col))

  #for row in min_row..max_row:
  #  for col in min_col..max_col:
  #    if map.contains((row, col)):
  #      stdout.write '#'
  #    else:
  #      stdout.write '.'
  #  echo ""
  #echo ""
  for row in min_row..max_row:
    for col in min_col..max_col:
      if not ((row, col) in outside_locs): result += 1

# for r in test_input: echo r

# for loc in test_input.make_map((0, 0)): echo loc
assert test_input.make_map((0, 0)).find_area == 62

echo readFile("input18.txt").parse_input.make_map((0, 0)).find_area
