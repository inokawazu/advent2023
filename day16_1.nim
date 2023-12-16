import system
import std/strutils
import std/sets
import std/deques
#import std/math
#import std/sequtils
#import std/enumerate

type
  Location = tuple[row: int, col: int]
  Direction = tuple[row: int, col: int]

func `[]`(input: seq[string], loc: Location): char = input[loc.row][loc.col]

func `+`(location: Location, direction: Direction): Location = (row: location.row + direction.row, col: location.col + direction.col)

func contains(input: seq[string], loc: Location): bool =
  return loc.row >= 0 and loc.col >= 0 and loc.row < input.len and loc.col < input[loc.row].len

proc print_progress(input: seq[string], ets: HashSet[Location]): void =
  for row in 0..<input.len:
    for col in 0..<input[row].len:
      let loc: Location = (row, col)
      if loc in ets:
        stdout.write '#'
      else:
        stdout.write input[loc]
    stdout.write '\n'

func energized_tiles(input: seq[string]): HashSet[Location] = 
  var 
    still_traveling = initDeque[tuple[location: Location, direction: Direction]]()
    visitied_with_dir = HashSet[tuple[location: Location, direction: Direction]]()
  still_traveling.addLast((location: (0, 0), direction: (0, 1)))

  while still_traveling.len != 0:
    let (cur_location, cur_direction) = still_traveling.popFirst()

    assert cur_direction.col.abs + cur_direction.row.abs == 1

    if (cur_location, cur_direction) in visitied_with_dir: continue

    # add to visited
    result.incl(cur_location)
    visitied_with_dir.incl(( cur_location, cur_direction ))
    #print_progress input, result
    #echo ""

    let current_tile = input[cur_location]

    var next_directions = newSeq[Direction]()

    if current_tile == '.':
      next_directions.add(cur_direction)
    elif current_tile == '|':
      if cur_direction.col != 0:
        next_directions.add((1, 0))
        next_directions.add((-1, 0))
      else: next_directions.add(cur_direction)
    elif current_tile == '-':
      if cur_direction.row != 0:
        next_directions.add((0, 1))
        next_directions.add((0, -1))
      else: next_directions.add(cur_direction)
    elif current_tile == '\\':
      next_directions.add((cur_direction.col, cur_direction.row))
    elif current_tile == '/':
      next_directions.add((-cur_direction.col, -cur_direction.row))
    else:
      assert false
    for next_direction in next_directions:
      let next_location = cur_location + next_direction
      if next_location in input: still_traveling.addLast((location: next_location, direction: next_direction))

#for r in input: echo  r
#echo ""
#
## for et in input.energized_tiles: echo et
#let ets = input.energized_tiles()
#
#for row in 0..<input.len:
#  for col in 0..<input[row].len:
#    let loc: Location = (row, col)
#    if loc in ets:
#      stdout.write '#'
#    else:
#      stdout.write input[loc]
#  stdout.write '\n'
#
#echo ""
#echo """######....
#.#...#....
#.#...#####
#.#...##...
#.#...##...
#.#...##...
#.#..####..
#########..
#.#######..
#.#...#.#.."""

let input = readFile("input16.txt").strip.split('\n')
#let input = readFile("test16.txt").strip.split('\n')

echo input.energized_tiles.len
