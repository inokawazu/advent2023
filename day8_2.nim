import system
import std/strutils
import std/sequtils
import std/algorithm
import std/tables
import std/math

const input = slurp("input8.txt")

let lines = input.splitLines(false)

type
  Direction = enum
    Left
    Right
  Location = string
  InstructionMap = TableRef[(Direction, Location), Location]

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
  currentLocs: seq[Location] = lines[2..^2].map(parseInstruction).mapIt(it[0]).filterIt(it[^1] == 'A')
  locationCycles = newSeq[int]()
  lrPointer = 0

for cl in currentLocs: locationCycles.add(0)

while currentLocs.anyIt(it[^1] != 'Z'):

  for i in 0..<currentLocs.len:
    let 
      currentLoc = currentLocs[i]
      currentCycle = locationCycles[i]
    if currentCycle == 0 and currentLoc[^1] == 'Z': locationCycles[i] = steps

  if locationCycles.allIt(it != 0): break

  let nextDir = leftRights[lrPointer]
  for i in 0..<currentLocs.len:
    currentLocs[i] = instMap[(nextDir, currentLocs[i])]

  steps += 1
  lrPointer += 1
  lrPointer = lrPointer mod leftRights.len

echo "The answer is ", lcm(locationCycles)
