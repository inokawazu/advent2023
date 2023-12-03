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


proc min_color(line: string, color: Color): int =
  result = 0
  for round in line.rounds:
    result = max(
      round.filterit(it.color == color).mapit(it.count).sum,
      result,
      )

proc id(line: string): int =
   let hbline = split(line, ':')
   let header = hbline[0].strip
   result = header[5..header.len-1].parseInt

var answer = 0
const colors = @[ red, green, blue ]

for line in ilines:
  answer += colors.mapit(min_color(line, it)).prod

echo "The answer is ", answer
