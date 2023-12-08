import system
import std/strutils
import std/sequtils
import std/algorithm
import std/tables

type
  Hand = tuple[ cards: string, counts: CountTableRef[char], bid: int]

#const input = slurp("test7.txt")
const input = slurp("input7.txt")

let lines = input.splitLines(false).filterit(it.len != 0 )

let card_sets = lines.mapIt(splitWhitespace(it)[0])
let bids = lines.mapIt(splitWhitespace(it)[1].parseInt)

func card_score(card: char): int = 
  case card:
    of 'A': return 12
    of 'K': return 11
    of 'Q': return 10
    of 'J': return 9
    of 'T': return 8
    of '9': return 7
    of '8': return 6
    of '7': return 5
    of '6': return 4
    of '5': return 3
    of '4': return 2
    of '3': return 1
    of '2': return 0
    else: assert(false, "Invalid card found " & card)

proc makeHand(card_set: string, bid: int): Hand =
  return (cards: card_set, counts: newCountTable(card_set), bid: bid)

let hands = zip(card_sets, bids).mapIt:
  makeHand(it[0], it[1])

func cmp_hand_per_card(hand1, hand2: string): int =
  for (c1, c2) in zip(hand1, hand2):
    let 
      s1 = card_score(c1)
      s2 = card_score(c2)
    if s1 != s2: return s1 - s2
  return 0

func isnhand(hand: Hand, n: int): bool =
  #result = hand.counts.values.anyIt(x => x == n)
  for cnt in hand.counts.values:
    if cnt == n:
      return true
  return false

func isfive(hand: Hand): bool = isnhand(hand, 5)
func isfour(hand: Hand): bool = isnhand(hand, 4)
func isthree(hand: Hand): bool = isnhand(hand, 3)
func ispair(hand: Hand): bool = isnhand(hand, 2)

func isfull(hand: Hand): bool = isthree(hand) and ispair(hand)

func istwopair(hand: Hand): bool =
  return hand.counts.values.countIt(it == 2) == 2

iterator hand_rank_order(hand: Hand): bool =
  yield isfive(hand)
  yield isfour(hand)
  yield isfull(hand)
  yield isthree(hand)
  yield istwopair(hand)
  yield ispair(hand)
  yield true

func hand_cmp(hand1, hand2: Hand): int =
  for (cmp1, cmp2) in zip(hand_rank_order(hand1).toSeq, hand_rank_order(hand2).toSeq):
    if cmp1 xor cmp2: return cmp1.int - cmp2.int
    if cmp1 and cmp2: return cmp_hand_per_card(hand1.cards, hand2.cards)
  return 0

# for hand in sorted(hands, hand_cmp): echo hand

let sorted_hands = sorted(hands, hand_cmp)

var 
  rank = 1
  answer = 0
for hand in sorted_hands:
  answer += hand.bid * rank
  rank += 1

echo "The answer is ", answer
