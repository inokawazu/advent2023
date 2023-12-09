import system
import std/strutils
import std/sequtils
import std/algorithm
import std/tables

#const input = slurp("test8.txt")
const input = slurp("input8.txt")

let lines = input.splitLines(false)

type
  Direction = enum
    Left
    Right
  Location = string
  InstructionMap = TableRef[(Direction, Location), Location]

# for line in lines: echo line

func parseDirection(l: char): Direction =
  case l:
    of 'L': return Left
    of 'R': return Right
    else: assert(false, "No direction for " & l)

func parseInstruction(line: string): (Location, Location, Location) =
  discard "0123456789012345"
  discard "AAA = (BBB, CCC)"
  assert(line.len == 16, "Line is not the write len.")
  return (line[0..2], line[7..9], line[12..14])

#echo lines[0].map(parseDirection)
#echo lines[2..^2].map(parseInstruction)

func makeInstructionMap(insts: seq[(Location, Location, Location)]): InstructionMap =
  var imap = newTable[(Direction, Location), Location]()
  for (fromloc, toleftloc, torightloc) in insts:
    imap[(Left, fromloc)] = toleftloc
    imap[(Right, fromloc)] = torightloc
  return imap

let 
  instMap = lines[2..^2].map(parseInstruction).makeInstructionMap
  leftRights = lines[0].map(parseDirection)

var 
  steps = 0 
  currentLoc: Location = "AAA"
  lrPointer = 0

while currentLoc != "ZZZ":
  let nextDir = leftRights[lrPointer]
  currentLoc = instMap[(nextDir, currentLoc)]

  steps += 1
  lrPointer += 1
  lrPointer = lrPointer mod leftRights.len

echo "The answer is ", steps
