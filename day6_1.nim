import system
import std/strutils
import std/parseutils
import std/sequtils
import std/math

type
  RaceRecord = tuple[time: int, dist: int]

# time: ....
# distance: ....
#const input = slurp("test6.txt")
const input = slurp("input6.txt")

let lines = input.splitLines(false)

#echo lines

let 
  timeline = lines[0].split(':')[1].splitWhitespace.map(parseInt)
  distline = lines[1].split(':')[1].splitWhitespace.map(parseInt)
  records = zip(timeline, distline).mapIt(RaceRecord it)


#echo timeline
#echo distline
echo records

func distance_covered(timepushed:int, record:RaceRecord): int =
  let 
    racetime = record.time - timepushed
    speed = timepushed
  return speed * racetime

func beats(timepushed:int, record:RaceRecord): bool =
  return timepushed.distance_covered(record) > record.dist


var nways = newSeq[int]()

for record in records:
  let ways = (0..record.time).countIt(it.beats(record))
  echo "Ways = ", ways
  nways.add(ways)

echo "The answer is ", nways.prod
