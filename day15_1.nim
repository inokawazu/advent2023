import system
import std/strutils
import std/math
import std/sequtils

let input = readFile("input15.txt").strip.replaceWord("\n", "").split(',')
#let input = "HASH"

func hash(str: string): int =
  for ch in str:
    result += ch.int
    result *= 17
    result = result %% 256

assert hash("HASH") == 52
assert "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7".split(',').mapit(it.hash).sum == 1320

let answer = input.map(hash).sum
echo "The answer is ", answer
