import system
import std/strutils
import std/sequtils
import std/tables

type
  FromTo = (string, string)
  InstMap = tuple[ dest_start: int, srce_start: int, range_len: int ]

const input = slurp("input5.txt")
#const input = slurp("test5.txt")
let sections = split(input, "\n\n").filterit(len(it) > 0)

#for section in sections:
#  echo "--------------"
#  echo section
#  echo "--------------"

let seeds = sections[0].split(':')[1].splitWhitespace.map(parseInt)
#echo "Seeds = ", seeds

proc parse_map_section(section: string): tuple[fromto: FromTo, inst_map: seq[InstMap] ] =
  # let fromto: FromTo = ((section_lines[0]).splitWhitespace()[0]).split("-to-")
  let 
    section_lines = section.splitLines.filterit(len(it) > 0)
    fromtoseq = section_lines[0].splitWhitespace()[0].split("-to-")
  # var inst_maps = initTable[int, int]()
  var inst_map = newSeq[InstMap]()
  for map_line in section_lines[1..(len(section_lines)-1)]:
    let 
      map_nums = map_line.splitWhitespace.map(parseInt)
      dest_start = map_nums[0]
      srce_start = map_nums[1]
      range_len = map_nums[2]
    inst_map.add((dest_start, srce_start, range_len))
    
  return (fromto: (fromtoseq[0], fromtoseq[1]), inst_map: inst_map)

#echo input

proc contains(inst: InstMap, num: int): bool =
  return inst.srce_start <= num and num < (inst.srce_start + inst.range_len)

proc dest(inst: InstMap, num: int): int =
  let index = num - inst.srce_start 
  return inst.dest_start + index

proc map_to_seeds(input_nums: seq[int], tomaps: seq[InstMap]): seq[int] =
  var nums = newSeq[int]()
  for n in input_nums: nums.add(n)
  for num in nums.mitems:
    for inst in tomaps:
      if num in inst:
        num = dest(inst, num)
        break
  return nums

#for section in sections[1..(len(sections)-1)]:
#  echo parse_map_section(section)

let inst_maps = (sections[1..(len(sections)-1)]).map(parse_map_section).mapIt(it.inst_map)
#echo inst_maps
# echo foldl(inst_maps, map_to_seeds, seeds)
var locs = seeds
for inst_map in inst_maps: 
  locs = map_to_seeds(locs, inst_map)

echo "The answer is ", foldl(locs, min(a, b))
