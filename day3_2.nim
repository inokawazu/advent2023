import system
import std/strutils
import std/sequtils
import std/tables

const input = slurp("input3.txt")
#const input = slurp("test3.txt")
let ilines = split(input, '\n').filterit(len(it) > 0)

type
  Position = tuple[row: int, col: int]

iterator number_positions(lines: openArray[string]): tuple[value : string, position : Position] =
  for lp in lines.pairs:
    let 
      row = lp[0]
      l = lp[1]
    var col = 0
    while col < len(l): 
      let col_begin = col
      while col < l.len and isDigit(l[col]):
        col += 1
      if col != col_begin:
        let value = (l[col_begin..col-1])
        yield (value: value, position: (row: row, col: col_begin))
      col += 1

iterator gear_positions(lines: openArray[string]): Position =
  for lp in lines.pairs:
    let 
      row = lp[0]
      l = lp[1]
    var col = 0
    while col < len(l): 
      if l[col] == '*':
        yield (row: row, col: col)
      col += 1

iterator neighbor_chars(lines: openArray[string], num_len: int, position: Position): (char, Position) =
  let 
    rows = (position.row - 1)..(position.row + 1)
    cols = (position.col - 1)..(position.col + num_len)
    nrows = lines.len
    ncols = lines[0].len
  for row in rows: 
    for col in cols:
      if row < 0 or row >= nrows: continue
      if col < 0 or col >= ncols: continue
      if row == position.row and (col >= position.col and col < position.col + num_len): continue
      yield (lines[row][col], (row: row, col:col))

#echo input

let gps = gear_positions(ilines).toSeq
var  gear_counts = initTable[Position, tuple[count: int, ratio: int]]()

for np in number_positions(ilines):
  let gnc = neighbor_chars(ilines, np.value.len, np.position).toSeq.filterIt(it[0] == '*')
  for (_, found_gp) in gnc:
    # echo found_gp, " ", np
    let (count, ratio) = if gear_counts.hasKey(found_gp):
      gear_counts[found_gp]
    else: 
      (0, 1)
    gear_counts[found_gp] = (count: count+1, ratio: ratio * np.value.parseInt)

var answer = 0
for (count, ratio) in values(gear_counts):
  if count == 2: answer += ratio
# echo gear_counts

echo "The answer is ", answer
