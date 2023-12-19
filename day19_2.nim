# Broken 
import system
import std/strutils
import std/tables
import std/deques

type
  Part = Table[string, int]
  PartRange = Table[string, (int, int)]
  CompareType = enum
    GT
    LT
    T
  WorkFlowRule = tuple
    cmp: CompareType
    cmp_field: string
    cmp_value: int
    target: string
  WorkFlowTable = Table[string, seq[WorkFlowRule]]

func initPart(): Part = initTable[string, int]()

func parse_workflows(s: string): WorkFlowTable =
  for line in s.strip.splitLines:
    let 
      lbi = line.find('{')
      name = line[0..<lbi]
      entries = line[(lbi + 1)..^2].split(',')
    # echo (line, lbi, name, entries)
    # echo entries
    var workflow = newSeq[WorkFlowRule]()
    for entry in entries:
      if '<' in entry:
        let 
          cmpi = entry.find('<')
          coli = entry.find(':')
          cmp = CompareType.LT
          cmp_field = entry[0..<cmpi]
          cmp_value = entry[cmpi+1..<coli].parseInt
          target = entry[coli+1..^1]
          workflowrule: WorkFlowRule = (cmp, cmp_field, cmp_value, target)
        workflow.add(workflowrule)
      elif '>' in entry:
        let 
          cmpi = entry.find('>')
          coli = entry.find(':')
          cmp = CompareType.GT
          cmp_field = entry[0..<cmpi]
          cmp_value = entry[cmpi+1..<coli].parseInt
          target = entry[coli+1..^1]
          workflowrule: WorkFlowRule = (cmp, cmp_field, cmp_value, target)
        workflow.add(workflowrule)
      elif not (':' in entry):
        let 
          cmp = CompareType.T
          cmp_field = ""
          cmp_value = -1
          target = entry
          workflowrule: WorkFlowRule = (cmp, cmp_field, cmp_value, target)
        workflow.add(workflowrule)
      else: assert false, "Unreachable"
    result[name] = workflow

func parse_parts(s: string): seq[Part] =
  for line in s.strip.splitLines:
    var part = initPart()
    let entries = line[1..^2].split(',')
    assert entries.len == 4
    for entry in entries:
      let leftright = entry.split('=')
      assert leftright.len == 2
      part[leftright[0]] = leftright[1].parseInt
    result.add(part)

func process_input(s: string): (WorkFlowTable, seq[Part]) =
  let s_parts = s.strip.split("\n\n")
  assert s_parts.len == 2
  return (parse_workflows(s_parts[0]), parse_parts(s_parts[1]))

func prod_ranges(prange: PartRange): int =
  result = 1
  for (left, right) in prange.values: result *= right - left + 1

proc count_all_combos(wft: WorkFlowTable): int =
  var part_range_dests = initDeque[(string, PartRange)]()
  var first_range: PartRange
  for c in "xmas": first_range[$c] = (1, 4000)
  part_range_dests.addLast(("in", first_range))

  while part_range_dests.len > 0:
    var (wf_name, part_range) = part_range_dests.popFirst()
    for rule in wft[wf_name]:
      var go_range = part_range
      case rule.cmp:
        of GT:
          let (left, right) = part_range[rule.cmp_field]
          if left <= rule.cmp_value and right > rule.cmp_value:
            go_range[rule.cmp_field] = (rule.cmp_value + 1, right)
            part_range[rule.cmp_field] = (left, rule.cmp_value) 
        of LT:
          let (left, right) = part_range[rule.cmp_field]
          if left < rule.cmp_value and right >= rule.cmp_value:
            go_range[rule.cmp_field] = (left, rule.cmp_value - 1)
            part_range[rule.cmp_field] = (rule.cmp_value, right) 
        of T: discard
      case rule.target:
        of "A": result += prod_ranges(go_range)
        of "R": discard
        else: part_range_dests.addLast((rule.target, go_range))

let (test_wft, test_parts) = """
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
""".process_input
discard test_parts

assert test_wft.count_all_combos == 167409079868000

let (input_wft, input_parts) = readFile("input19.txt").process_input
discard input_parts

let answer = input_wft.count_all_combos
echo "The answer is ", answer
