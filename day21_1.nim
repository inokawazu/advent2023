import system
import strutils
import sets
import deques

type
  Location = tuple
    row: int
    col: int
  GardenSteps = tuple
    rock_locations: HashSet[Location]
    start: Location
    garden_dims: (int, int)

func parse_input(input: string): GardenSteps =
  let 
    lines = input.strip.splitLines
  result[2][0] = lines.len
  result[2][1] = lines[0].len
  for (row, line) in lines.pairs():
    for col, elem in line.pairs():
      case elem:
        of '#': result[0].incl((row, col))
        else: discard
      case elem:
        of 'S': result[1] = (row, col)
        else: discard

proc garden_steps(gs: GardenSteps, steps_target: int): int =
  let 
    rock_locations = gs.rock_locations
    (nrows, ncols) = gs.garden_dims
  var 
    tovisit = initDeque[(int, Location)]()
    reached = initHashSet[Location]()
  tovisit.addLast((0, gs.start))
  while tovisit.len > 0:
    let (steps_taken, location) = tovisit.popFirst()
    if steps_taken == steps_target:
      reached.incl(location)
      continue
    for (drow, dcol) in @[(1, 0), (-1, 0), (0, 1), (0, -1)]:
      let 
        next_location: Location = (location.row + drow, location.col + dcol)
        next_steps_taken = steps_taken + 1
      if next_location.col < 0 or next_location.row < 0:
        echo "HIT BOUND"
        continue
      if next_location.col >= ncols or next_location.row >= nrows:
        echo "HIT BOUND"
        continue
      if next_location in rock_locations: continue
      if (next_steps_taken, next_location) in tovisit: continue
      tovisit.addLast((next_steps_taken, next_location))
  return reached.len

let test_input = """...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
..........."""

# echo test_input.parse_input[0]
# echo test_input.parse_input[1]
# echo test_input.parse_input[2]

assert test_input.parse_input.garden_steps(0) == 1
assert test_input.parse_input.garden_steps(1) == 2
assert test_input.parse_input.garden_steps(2) == 4
assert test_input.parse_input.garden_steps(3) == 6
assert test_input.parse_input.garden_steps(6) == 16

echo "The answer is ", readFile("input21.txt").parse_input.garden_steps(64)
