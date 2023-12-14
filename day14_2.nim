# Broken 

import system
import std/strutils
import std/sequtils
import std/algorithm
import std/tables

type RockMap = seq[string]

let 
  input = readFile("test14.txt")
  rows: RockMap = input.splitLines()[0..^2]

func tilt_east(rmap: RockMap): RockMap =
  for row in rmap:
    let 
      split_row = row.split('#')
      sorted_row = split_row.mapIt(it.sorted.join)
    result.add(join(sorted_row, "#"))

func flip(rmap: RockMap): RockMap =
  for r in rmap: result.add(r.reversed.join)

func transpose(rmap: RockMap): RockMap =
  let 
    col_inds = 0..<rmap[0].len
    row_inds = 0..<rmap.len
  for col_ind in col_inds:
    let col = row_inds.mapIt(rmap[it][col_ind]).join
    result.add(col)

func rotate_clockwise(rmap: RockMap): RockMap =
  return rmap.flip.transpose

func spin_platform(rmap: RockMap): RockMap =
  result = rmap
  for _ in 0..<4:
    result = result.rotate_clockwise.tilt_east

func north_load(rmap: RockMap): int =
  for i in 1..rmap.len:
    let row = rmap[rmap.len - i]
    result += row.count('O') * i

func solve(input_rmap: RockMap): int =
  var rmap = input_rmap
  var rm_dict = initTable[RockMap, int]()
  for i in 1..1000000000:
    rmap = spin_platform(rmap)
    if rm_dict.hasKeyOrPut(rmap, i):
      let
        loop_start = rm_dict[rmap]
        loop_length = i - loop_start
        ind_f = (1000000000 - loop_start) mod loop_length + loop_start
      for inner_rmap, j in rm_dict.pairs:
        if j == ind_f: return north_load(inner_rmap)

for r in rows: echo r
echo ""
for r in rows.transpose: echo r
#echo ""
#for r in rows.spin_platform.spin_platform: echo r

#let answer = solve(rows)
#echo "The answer is ", answer
