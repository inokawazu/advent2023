import system
import std/strutils
import std/sequtils
import std/sugar
import std/math

const input = slurp("input1_1.txt")
const ilines = split(input, '\n').filter(x => len(x) > 0)

const digit_map = @[
    ("one", "1"),
    ("two", "2"),
    ("three", "3"),
    ("four", "4"),
    ("five", "5"),
    ("six", "6"),
    ("seven", "7"),
    ("eight", "8"),
    ("nine", "9"),
    ("1", "1"),
    ("2", "2"),
    ("3", "3"),
    ("4", "4"),
    ("5", "5"),
    ("6", "6"),
    ("7", "7"),
    ("8", "8"),
    ("9", "9"),
    ]

func filter_ints(line: string): string =
  for i in 0 ..< len(line):
    for ( key, digit ) in digit_map:
      if continuesWith(line, key, i):
        result = result & digit
        break

proc process_line(line: string): int =
  let int_line = filter_ints(line)
  return parseInt(int_line[0] & int_line[len(int_line)-1])

echo "The answer is ", ilines.map(process_line).sum
