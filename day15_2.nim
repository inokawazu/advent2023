import system
import std/strutils
import std/math
import std/sequtils
import std/enumerate

type 
  Lense = tuple[label: string, focal_length: int]

let input = readFile("input15.txt").strip.replaceWord("\n", "").split(',')

func hash(str: string): int =
  for ch in str:
    result += ch.int
    result *= 17
    result = result %% 256

assert hash("HASH") == 52
assert "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7".split(',').mapit(it.hash).sum == 1320


#let answer = input.map(hash).sum
#echo "The answer is ", answer

func delete_lense(boxes: var seq[seq[Lense]], label: string): void =
  let box_ind = hash(label)
  var box = boxes[box_ind]
  let lense_ind = box.mapIt(it.label).find(label)
  if lense_ind != -1:
    boxes[box_ind].delete(lense_ind)

func add_lense(boxes: var seq[seq[Lense]], lense: Lense): void =
  let box_ind = hash(lense.label)
  var box = boxes[box_ind]
  let lense_ind = box.mapIt(it.label).find(lense.label)
  if lense_ind != -1:
    # var present_lense = box[lense_ind]
    boxes[box_ind][lense_ind].focal_length = lense.focal_length
    return
  boxes[box_ind].add(lense)

proc carryout_insts(input: seq[string]): seq[seq[Lense]] =
  var boxes = newSeq[seq[Lense]](256)
  for inst in input:
    if inst[^1] == '-':
      let label = inst[0..^2]
      boxes.delete_lense(label)
    else:
      assert '=' in inst
      let 
        inst_split = inst.split('=')
        label = inst_split[0]
        focal_length = inst_split[1].parseInt
      boxes.add_lense((label: label, focal_length: focal_length))
  return boxes

func focusing_power(boxes: seq[seq[Lense]]): int =
  for box_num in 0..255:
    for slot_num, lense in enumerate(boxes[box_num]):
      result += (box_num + 1) * (slot_num + 1) * lense.focal_length

let test_boxes = carryout_insts("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7".split(','))
#for tb in test_boxes: 
#  if tb.len != 0: echo tb

assert test_boxes.focusing_power() == 145

let answer = input.carryout_insts.focusing_power
echo "The answer is ", answer
