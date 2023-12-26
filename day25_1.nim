import system
import strutils
import sequtils
import tables
import sets
import math
import deques
import algorithm

type
  Connections = Table[string, HashSet[string]]

func add_connection(connections: var Connections, from_node, to_node: string): void =
  if not connections.hasKey(from_node): connections[from_node] = initHashSet[string]()
  if not connections.hasKey(to_node): connections[to_node] = initHashSet[string]()
  connections[to_node].incl(from_node)
  connections[from_node].incl(to_node)

func cut_connection(connections: var Connections, from_node, to_node: string): void =
  if not connections.hasKey(from_node): connections[from_node] = initHashSet[string]()
  if not connections.hasKey(to_node): connections[to_node] = initHashSet[string]()
  connections[to_node].excl(from_node)
  connections[from_node].excl(to_node)

func with_cut_connection(connections: Connections, from_node, to_node: string): Connections =
  result = connections
  cut_connection(result, from_node, to_node)

func parse_input(s: string): Connections =
  let ss = s.strip
  for line in ss.splitLines:
    let 
      colon_split = line.split(": ")
      connect_tos = colon_split[1].split(' ')
    for connect_to in connect_tos: add_connection(result, colon_split[0], connect_to)

func groups(connections: Connections): seq[ HashSet[string] ] =
  var 
    connected_group = initHashSet[string]()
    nodes = connections.keys.toSeq.toHashSet
    nodes_to_connect = newSeq[string]()
  while nodes.len > 0:

    connected_group.clear()
    nodes_to_connect.add(nodes.pop())

    while nodes_to_connect.len > 0:
      let node = nodes_to_connect.pop()
      connected_group.incl(node)
      nodes.excl(node)

      for next_node in connections[node]:
        if next_node in connected_group: continue
        nodes_to_connect.add(next_node)
    result.add(connected_group)

func count_groups(connections: Connections): int = connections.groups.len

iterator cpairs(connections: Connections): (string, string) =
  var past = initHashSet[(string, string)]()
  for from_node, to_nodes in connections:
    for to_node in to_nodes:
      if (from_node, to_node) in past: continue
      if (to_node, from_node) in past: continue

      if from_node > to_node: 
        yield (from_node, to_node)
        past.incl((from_node, to_node))
      else:
        yield (to_node, from_node)
        past.incl((to_node, from_node))

iterator threesubperms[T](x: seq[T]): seq[T] =
  for x1 in x:
    for x2 in x:
      if x2 == x1: continue
      for x3 in x:
        if x2 == x3 or x1 == x3: continue
        yield @[x1, x2, x3]

proc hitsmap(input: Connections, hits: var Table[string, int], firsttovisit: string): void =
  var 
    visited = initHashSet[string]()
    tovisit = [firsttovisit].toDeque

  while tovisit.len > 0:
    let node  = tovisit.popFirst
    if hits.hasKeyOrPut(node, 0): hits[node] += 1

    if node in visited: continue
    visited.incl(node)
    for next_node in input[node]: 
      tovisit.addLast(next_node)

proc hitsmap(input: Connections): Table[string, int] =
  for i, v in input: hitsmap(input, result, i)

func seccmp[T](a, b: T): int = cmp(a[1], b[1])

proc print_table[T, V](t: Table[T, V]): void =
  var ps = t.pairs.toSeq()
  ps.sort(seccmp)
  for ( i, v ) in ps: echo (i, v)
  echo ""

proc solve(input: Connections): int =
  let 
    htable = input.hitsmap
    minhits = htable.values.toSeq.min
    nmin = htable.values.toSeq.filterIt(it == minhits).len
  return (htable.len - nmin) * nmin
#proc solve(input: Connections): int =
#  var connections = input
#  let 
#    cps = connections.cpairs.toSeq
#  for todiss in cps.threesubperms:
#    for (from_node, to_node) in todiss:
#      connections.cut_connection(from_node, to_node)
#    let found_groups = connections.groups
#    if found_groups.len > 1: return found_groups.mapIt(it.len).prod
#    for (from_node, to_node) in todiss:
#      connections.add_connection(from_node, to_node)

let test_input = """
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
""".parse_input

# echo "The test is ", test_input.solve
# echo readFile("input25.txt").parse_input.solve
#test_input.hitsmap.print_table
#readFile("input25.txt").parse_input.hitsmap.print_table

echo test_input.solve
echo readFile("input25.txt").parse_input.solve

#test_input.with_cut_connection("jqt", "rhn").hitsmap.print_table
#
#test_input.with_cut_connection("hfx", "pzl").hitsmap.print_table
#
#test_input.with_cut_connection("hfx", "pzl").with_cut_connection("bvb", "cmg").hitsmap.print_table

#for i, v in test_output:
#  if v == 4: echo i
#echo ""
#for i, v in test_output:
#  if v == 3: echo i
#echo ""

# discard test_input.with_cut_connection("jqt", "rhn").solve

# discard test_input.with_cut_connection("hfx", "pzl").with_cut_connection("bvb", "cmg").solve

#assert test_input.solve == 54
#echo "The answer is ", readFile("input25.txt").parse_input.solve
