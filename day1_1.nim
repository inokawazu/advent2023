import system
import std/strutils
import std/sequtils
import std/sugar
import std/math

const input = slurp("input1_1.txt")
let ilines = split(input, '\n').filter(x => len(x) > 0)

func filter_ints(line: string): string =
  for c in line:
    if isDigit(c):
      result = result & c

proc process_line(line: string): int =
  let int_line = filter_ints(line)
  return parseInt(int_line[0] & int_line[len(int_line)-1])

echo "The answer is ", sum(ilines.map(process_line))
