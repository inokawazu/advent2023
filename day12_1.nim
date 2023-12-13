import system
import std/sequtils
import std/strutils

#const input = slurp("test12.txt")
const input = slurp("input12.txt")
let 
  lines = input.splitLines(false)[0..^2]
  counts_vec = lines.mapit(it.splitWhitespace).mapit(it[1].split(",").map(parseInt))
  springs_vec = lines.mapit(it.splitWhitespace).mapit(it[0])

type
  SpringProb = tuple[springs: string, counts: seq[int]]


iterator hgroups(s: string): string =
  var i = 0
  while i < s.len:
    if s[i] == '#':
      var j = i
      while j+1 < s.len and s[j+1] == '#': j += 1
      yield s[i..j]
      i = j + 1
    else: i += 1

func isValid(sp: SpringProb): bool =
  if '?' in sp.springs: return false
  let hgs = sp.springs.hgroups.toSeq
  if hgs.len != sp.counts.len: return false
  for (hchars, hcount) in zip(hgs, sp.counts):
    if hchars.len != hcount: return false
  return true

proc count_ways(sp: SpringProb): int =
  if sp.isvalid():
    return 1

  let qind = sp.springs.find('?')
  if qind < 0: return 0

  for nxtchar in @['.', '#']:
    var nxtspngs = sp.springs
    nxtspngs[qind] = nxtchar
    result += count_ways((springs: nxtspngs, counts: sp.counts))

var 
  answer = 0
  linei = 0
for ( springs, counts ) in zip(springs_vec, counts_vec):
  let prob: SpringProb = (springs: springs, counts: counts)
  answer += count_ways(prob)
  linei += 1
echo "The answer is ", answer

# ???.### 1,1,3
# .??..??...?##. 1,1,3
# ?#?#?#?#?#?#?#? 1,3,1,6
# ????.#...#... 4,1,1
# ????.######..#####. 1,6,5
# ?###???????? 3,2,1

# ???.### 1,1,3

# .??.### 1,1,3
# #??.### 1,1,3

# .#?.### 1,1,3
# ..?.### 1,1,3
# ##?.### 1,1,3
# #.?.### 1,1,3

# .##.### 1,1,3
# .#..### 1,1,3
# ..#.### 1,1,3
# ....### 1,1,3
# ###.### 1,1,3
# ##..### 1,1,3
# #.#.### 1,1,3
# #...### 1,1,3

# ??m?? n -> #... ..#. .#.. ...#
# ??m?? n -> ##.. .##. ..##
# m - n + 1 ways
