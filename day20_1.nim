# broken
import system
import strutils
import sequtils
import tables
import deques

type
  Signal = enum
    High
    Low
  ModuleType = enum
    FlipFlop
    Conjunction
    Normal
  Module = tuple
    module_type: ModuleType
    targets: seq[string]
    incoming: Deque[Signal]
    ison: bool
    memory: Table[string, Signal]

proc process_input(s: string): Table[string, Module] =
  for line in s.strip.splitLines:
    let leftright = line.split " -> "
    assert leftright.len == 2
    let 
      left = leftright[0]
      right = leftright[1]
    var module: Module
    if left[0] == '%':
      module.module_type = FlipFlop
      module.targets = right.split ", "
      result[left[1..^1]] = module
    elif left[0] == '&':
      module.module_type = Conjunction
      module.targets = right.split ", "
      result[left[1..^1]] = module
    else:
      module.module_type = Normal
      module.targets = right.split ", "
      result[left] = module
  for name, imodule in result:
    for target in imodule.targets:
      var tmodule = result[target]
      case tmodule.module_type:
        of Conjunction:
          result[target].memory[name] = Low
        else: discard

iterator run_signals(sys: var Table[string, Module]): Signal =
  assert sys.hasKey("broadcast")
  var traveling_signals = initDeque[(string, string, Signal)]()
  traveling_signals.addLast(("button", "broadcast", Low))
  while traveling_signals.len > 0:
    var processing_signals = traveling_signals
    traveling_signals.clear()
    assert processing_signals.len > 0

    for (sender, receiver, isignal) in processing_signals:
      yield isignal
      var osignal: Signal
      case sys[receiver].module_type:
        of FlipFlop:
          case isignal:
            of Low:
              sys[receiver].ison = sys[receiver].ison xor true
              if sys[receiver].ison: osignal = High else: osignal = Low
            of High: discard
        of Conjunction:
          sys[receiver].memory[sender] = isignal
          if sys[receiver].memory.values.toSeq.allIt(it == High): osignal = Low else: osignal = High
        of Normal: osignal = isignal
      for target in sys[receiver].targets:
        if not sys.hasKey(target): continue

let test_input = readFile("test20.txt")
for i, v in test_input.process_input: echo i, " => ", v
