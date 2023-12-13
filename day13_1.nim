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

proc find_reflection2[T](arr: openArray[T]): int =
  let cinds = if arr.len %% 2 == 1: @[(arr.len-1) div 2] else: @[(arr.len-1) div 2 - 1, (arr.len-1) div 2]
  for cind in cinds:
    if arr.isreflection_about(cind): return cind
  return -1

func isreflection_about[T](arr: openArray[T], ind: int): bool =
  var
    isreflection = true
    left_ind = ind
    right_ind = ind + 1
  while left_ind >= 0 and right_ind < arr.len:
    isreflection = isreflection and arr[left_ind] == arr[right_ind]
    left_ind -= 1
    right_ind += 1
  return isreflection

iterator find_reflections[T](arr: openArray[T]): int =
  var ind = 0
  while ind < arr.len - 1:
    #var
    #  isreflection = true
    #  left_ind = ind
    #  right_ind = ind + 1
    #while left_ind >= 0 and right_ind < arr.len:
    #  isreflection = isreflection and arr[left_ind] == arr[right_ind]
    #  left_ind -= 1
    #  right_ind += 1
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

#let p1 = patterns[0]

#  vv  
# vv
#01234
#0123

#for r in patterns[0]: echo r.join
#echo ""
#for r in p1.rows: echo r.join
#echo ""
#for c in p1.cols: echo c.join

#for p in patterns:
#  echo (p.rows.toSeq.find_reflections.toSeq(), p.cols.toSeq.find_reflections.toSeq())
#  echo (p.rows.toSeq.find_reflection, p.cols.toSeq.find_reflection)
#  echo (p.rows.toSeq.find_reflection2, p.cols.toSeq.find_reflection2)
#  echo "Score = ", p.score
#  echo ""
#  for r in p.rows: echo r.join
#  echo ""
#  #for c in p.cols: echo c.join
#  #echo ""
