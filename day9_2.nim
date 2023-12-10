import system
import std/strutils
import std/sequtils
import std/algorithm
import std/tables
import std/math

#const input = slurp("test9.txt")
const input = slurp("input9.txt")

let 
  lines = input.splitLines(false)[0..^2] 
  seq_lines = lines.mapIt(it.splitWhitespace.map(parseInt))

func diff[T](s: seq[T]): seq[T] =
  for i in 0..(s.len-2):
    let 
      inext = i + 1
      snext = s[inext] - s[i]
    result.add(snext)

func iszeroseq[T](s: seq[T]): bool = s.allIt(it == 0)

# echo seq_lines.map(diff)
# echo seq_lines.map(diff).map(iszeroseq)

proc find_prev[T](s: seq[T]): T =
  var ss = newSeq[seq[int]]()
  ss.add(s)
  while not iszeroseq(ss[^1]):
    ss.add(ss[^1].diff)
  ss.reverse
  for s in ss: 
    result = s[0] - result


#for n in seq_lines.map(find_prev): echo n

let answer = seq_lines.map(find_prev).sum
echo "The answer is ", answer
