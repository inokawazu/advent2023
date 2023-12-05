import system
import std/strutils
import std/sequtils
import std/sets
import std/math

const input = slurp("input4.txt")
#const input = slurp("test4_2.txt")
let lines = split(input, '\n').filterit(len(it) > 0)

type
  Card = tuple[id: int, winning: HashSet[int], actual: HashSet[int]]

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
    winning: num_secs[0].splitWhitespace.map(parseInt).toHashSet,
    actual: num_secs[1].splitWhitespace.map(parseInt).toHashSet
    )

proc nmatching(card: Card): int = len(card.actual * card.winning)

proc score(card: Card): int =
  let nwinning = nmatching(card)
  if nwinning > 0: return 2^(nwinning - 1)
  else: return 0

#let answer = ilines.map(parseCard).map(nmatching)
#echo "The answer is ", answer

let cards = lines.map(parseCard)
var card_counts = newSeq[int](len(cards))
for cc in card_counts.mitems: cc = 1

#for ci in key

for (ci, card) in pairs(cards):
  let nwins = nmatching(card)
  for cj in ci+1..min(len(cards)-1, ci+nwins):
    echo "Adding ", card_counts[ci], " to card ", cj+1, " from card ", ci+1
    card_counts[cj] += card_counts[ci]
  # echo (ci, nwins, card)

echo "The answer is ", sum(card_counts)
