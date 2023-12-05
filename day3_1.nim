import system
import std/strutils
import std/sequtils

const input = slurp("input3.txt")
#const input = slurp("test3.txt")
let ilines = split(input, '\n').filterit(len(it) > 0)

type
  Position = tuple[ row: int, col: int ]

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

iterator neighbor_chars(lines: openArray[string], num_len: int, position: Position): char =
  let 
    rows = (position.row - 1)..(position.row + 1)
    cols = (position.col - 1)..(position.col + num_len)
    nrows = lines.len
    ncols = lines[0].len
  for row in rows: 
    for col in cols:
      #echo "row col = ", row, " ", col
      if row < 0 or row >= nrows: continue
      if col < 0 or col >= ncols: continue
      if row == position.row and (col >= position.col and col < position.col + num_len): continue
      #echo "row col = ", row, " ", col
      yield lines[row][col]

var answer = 0
echo input
for np in number_positions(ilines):
  # echo np
  let ncs = toSeq(neighbor_chars(ilines, np.value.len, np.position))
  if ncs.anyit(not isDigit(it) and it != '.'):
    answer += np.value.parseInt
echo "The answer is ", answer
