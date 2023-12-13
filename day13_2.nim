import system
import std/sequtils
import std/strutils
import std/math

type Pattern = seq[seq[char]]

proc toPattern(text: string): Pattern =
  for l in text.splitLines().filterit(it.len > 0): result.add(l.toSeq())

func `[]`(p: Pattern, r, c: int): char = p[r][c]

proc find_reflection[T](arr: openArray[T]): int =
  var ind = -1
  for cind in arr.find_reflections():
    if abs(cind - arr.len div 2) < abs(ind - arr.len div 2):
      ind = cind
  return ind

const REFLECTION_DIFF = 1
func isreflection_about[T](arr: openArray[T], ind: int): bool =
  var
    total_diff = 0
    left_ind = ind
    right_ind = ind + 1
  while left_ind >= 0 and right_ind < arr.len:
    # isreflection = isreflection and arr[left_ind] == arr[right_ind]
    total_diff += zip(arr[left_ind], arr[right_ind]).countIt(it[0] != it[1])
    left_ind -= 1
    right_ind += 1
  return total_diff == REFLECTION_DIFF

proc find_reflection2[T](arr: openArray[T]): int =
  let cinds = if arr.len %% 2 == 1: @[(arr.len-1) div 2] else: @[(arr.len-1) div 2 - 1, (arr.len-1) div 2]
  for cind in cinds:
    if arr.isreflection_about(cind): return cind
  return -1

iterator find_reflections[T](arr: openArray[T]): int =
  var ind = 0
  while ind < arr.len - 1:
    if arr.isreflection_about(ind): yield ind
    ind += 1

iterator rows(p: Pattern): seq[char] =
  for r in p: 
    yield r

iterator cols(p: Pattern): seq[char] =
  let 
    ncols = p[0].len
    nrows = p.len
  for col in 0..<ncols: 
    yield (0..<nrows).mapIt(p[it, col])

func score(p: Pattern): int =
  let
    row_ref = p.rows.toSeq.find_reflection()
    col_ref = p.cols.toSeq.find_reflection()
  if col_ref >= 0: result += col_ref + 1
  if row_ref >= 0: result += 100 * ( row_ref + 1 )


#const input = slurp("test13.txt")
const input = slurp("input13.txt")
let patterns = input.split("\n\n").map(toPattern)

let answer = patterns.map(score).sum()
echo "The answer is ", answer
