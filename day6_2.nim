import system
import std/strutils
import std/sequtils

type
  RaceRecord = tuple[time: int, dist: int]

const input = slurp("input6.txt")

let lines = input.splitLines(false)

let 
  timeline = lines[0].split(':')[1].filterIt(not isSpaceAscii(it)).join.parseInt
  distline = lines[1].split(':')[1].filterIt(not isSpaceAscii(it)).join.parseInt
  record = RaceRecord (timeline, distline)

func distance_covered(timepushed:int, record:RaceRecord): int =
  let 
    racetime = record.time - timepushed
    speed = timepushed
  return speed * racetime

func beats(timepushed:int, record:RaceRecord): bool =
  return timepushed.distance_covered(record) > record.dist

let answer = (0..record.time).countIt(it.beats(record))
echo "The answer is ", answer
