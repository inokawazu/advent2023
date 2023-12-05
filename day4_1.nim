import system
import std/strutils
import std/sequtils
import std/sets
import std/math

const input = slurp("input4.txt")
#const input = slurp("test4.txt")
let ilines = split(input, '\n').filterit(len(it) > 0)

type
  Card = tuple[id: int, winning: seq[int], actual: seq[int]]

# echo input

proc parseCard(line: string): Card =
  #echo line
  let secs = line.split(':')
  #echo secs[0]
  let id_sec = secs[0]
  let id = id_sec.splitWhitespace[1].parseInt

  let num_secs = secs[1].split('|')
  #echo num_secs
  return (
    id: id, 
    winning: num_secs[0].splitWhitespace.map(parseInt),
    actual: num_secs[1].splitWhitespace.map(parseInt)
    )

proc score(card: Card): int =
  let nwinning = len(toHashSet(card.actual) * toHashSet(card.winning))
  if nwinning > 0: return 2^(nwinning - 1)
  else: return 0

let answer = ilines.map(parseCard).map(score).sum
echo "The answer is ", answer
