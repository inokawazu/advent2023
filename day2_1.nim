import system
import std/strutils
import std/sequtils
import std/sugar
import std/math

const input = slurp("input2.txt")
#const input = slurp("test2.txt")
let ilines = split(input, '\n').filter(x => len(x) > 0)

type
  Color = enum
    blue, red, green

type
  Pull = tuple[count: int, color: Color]

proc parse_block(action: string): Pull =
  let col_amount = action.strip.split
  let amount = col_amount[0].strip
  let col = col_amount[1].strip
  
  case col
  of "blue":
    return (count: amount.parseInt, color: blue)
  of "green":
    return (count: amount.parseInt, color: green)
  of "red":
    return (count: amount.parseInt, color: red)
  else:
    raise newException(CatchableError, "No color for " & col)

proc rounds(line: string): seq[seq[Pull]] =
  let hbline = split(line.strip, ':')
  let rds = hbline[1].strip.split(';')
  return rds.map(x=>split(x, ',').map(parse_block))

proc isvalid(line: string): bool =
  for round in line.rounds:
    if round.filterit(it.color == blue).mapit(it.count).sum > 14:
      return false
    if round.filterit(it.color == green).mapit(it.count).sum > 13:
      return false
    if round.filterit(it.color == red).mapit(it.count).sum > 12:
      return false
  return true

proc id(line: string): int =
   let hbline = split(line, ':')
   let header = hbline[0].strip
   result = header[5..header.len-1].parseInt

var answer = 0

for line in ilines:
  if isvalid(line):
    answer += line.id

echo "The answer is ", answer
