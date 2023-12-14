import system
import std/strutils
import std/sequtils

let 
  #input = readFile("test14.txt")
  input = readFile("input14.txt")
  rows = input.splitLines()[0..^2]
#echo input
#echo lines
#for l in lines: echo l.len

func cols(rows: seq[string]): seq[string] =
  let ncols = rows[0].len()
  for col in 0..<ncols:
    result.add(rows.mapIt(it[col]).join())

#for r in rows: echo r
#echo ""
#for c in rows.cols: echo c

func next_rock_ind(col: string, start_from: int): int =
  var ind = start_from + 1
  while ind < col.len:
    if col[ind] == '#': return ind
    ind += 1
  return ind


func calc_load(col: string): int =
  var ind = 0
  while ind < col.len:
    if col[ind] != '#':
      let rind = col.next_rock_ind(ind)
      var ncircs = col[ind..<rind].countIt(it == 'O')
      while ncircs > 0:
        result += col.len - ind
        ncircs -= 1
        ind += 1
      ind = rind
    ind += 1

#var ind = 3
#while ind > 0:
#  echo ind  
#  ind -= 1

var answer = 0
for col in rows.cols:
  answer += col.calc_load
echo "The answer is ", answer
