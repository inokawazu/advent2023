import system
import std/strutils
import std/sequtils
import std/tables
import std/deques

#const input = slurp("test10_1.txt")
#const input = slurp("test10_2.txt")
const input = slurp("input10.txt")

type
  Location = tuple[row: int, col: int]

let lines = input.splitLines(false)[0..^2] 

func find_start(lines: seq[string]): Location =
  for row in 0..<lines.len:
    for col, c in lines[row].pairs:
      if c == 'S': return (row, col)

iterator next_locations(loc: Location, lines: seq[string]): Location =
  if loc.col > 0 and lines[loc.row + 0][loc.col - 1] in "-LF": # left
    yield (row: loc.row, col: loc.col - 1)
  if loc.col + 1 < lines[0].len and lines[loc.row + 0][loc.col + 1] in "-J7": # right
    yield (row: loc.row, col: loc.col + 1)
  if loc.row > 0 and lines[loc.row - 1][loc.col + 0] in "|7F": # up
    yield (row: loc.row - 1, col: loc.col + 0)
  if loc.row + 1 < lines.len and lines[loc.row + 1][loc.col + 0] in "|LJ": # down
    yield (row: loc.row + 1, col: loc.col + 0)

var loc_queue = newSeq[(int, Location)]().toDeque
loc_queue.addLast((0, lines.find_start))

var visited = initTable[Location, int]()

while loc_queue.len > 0:

  let (current_dis, current_loc) = loc_queue.popFirst
  if not visited.hasKey(current_loc):# or visited[current_loc] > current_dis:
    visited[current_loc] = current_dis

  for next_loc in current_loc.next_locations(lines):
    let next_dis = current_dis + 1
    if not visited.hasKey(next_loc):# or visited[next_loc] > next_dis:
      loc_queue.addLast((next_dis, next_loc))

let answer = visited.values.toSeq.foldl(max(a, b))

echo "The answer is ", answer
