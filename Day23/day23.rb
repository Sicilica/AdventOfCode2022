def vec_add(a, b)
  (0..a.length-1).map{ |i| a[i] + b[i] }
end

def vec_to_str(v)
  v.join(':')
end

def vec_from_str(s)
  s.split(':').map(&:to_i)
end

elves = {}
lines = File.read('input.txt').split
(0..lines.length-1).each do |y|
  line = lines[y].chars
  (0..line.length-1).each do |x|
    elves[vec_to_str([x, y])] = nil if line[x] == '#'
  end
end

# N -> S -> W -> E
DIRECTIONS = [
  {
    move: [0, -1],
    check: [
      [-1, -1],
      [0, -1],
      [1, -1],
    ],
  },
  {
    move: [0, 1],
    check: [
      [-1, 1],
      [0, 1],
      [1, 1],
    ],
  },
  {
    move: [-1, 0],
    check: [
      [-1, -1],
      [-1, 0],
      [-1, 1],
    ],
  },
  {
    move: [1, 0],
    check: [
      [1, -1],
      [1, 0],
      [1, 1],
    ],
  },
]

any_elf_moved = false
simulate = Proc.new do |round_idx|
  any_elf_moved = false
  directions = (0..3).map{ |i| DIRECTIONS[(i + round_idx) % 4] }
  proposals = {}
  elves.keys.each do |k|
    start_pos = vec_from_str(k)

    next if (-1..1).all?{ |x| (-1..1).all?{ |y| (x == 0 and y == 0) or not elves.has_key?(vec_to_str(vec_add(start_pos, [x, y]))) } }

    proposed_dir = directions.find{ |dir| dir[:check].all?{ |offset| not elves.has_key?(vec_to_str(vec_add(start_pos, offset))) } }
    next if proposed_dir.nil?

    proposed_key = vec_to_str(vec_add(start_pos, proposed_dir[:move]))
    elves[k] = proposed_key
    proposals[proposed_key] = 0 unless proposals.has_key?(proposed_key)
    proposals[proposed_key] += 1
  end
  elves.keys.each do |start_key|
    proposed_key = elves[start_key]
    next if proposed_key.nil?

    if proposals[proposed_key] == 1
      elves.delete(start_key)
      elves[proposed_key] = nil
      any_elf_moved = true
    else
      elves[start_key] = nil
    end
  end
end

PART1_ROUNDS = 10
(0..PART1_ROUNDS-1).each do |round_idx|
  simulate.call(round_idx)
end

bounds = nil
elves.each do |k, _v|
  pos = vec_from_str(k)

  bounds = [[pos[0], pos[0]], [pos[1], pos[1]]] if bounds == nil
  bounds = (0..1).map{ |k| [[bounds[k][0], pos[k]].min, [bounds[k][1], pos[k]].max] }
end

# (bounds[1][0]..bounds[1][1]).each do |y|
#   puts (bounds[0][0]..bounds[0][1]).map{ |x| elves.has_key?(vec_to_str([x, y])) ? '#' : '.' }.join
# end

puts "part1 = #{bounds.map{ |arr| arr[1]-arr[0] + 1 }.reduce{ |a, b| a*b } - elves.length}"



round_idx = PART1_ROUNDS
loop do
  simulate.call(round_idx)
  break unless any_elf_moved
  round_idx += 1
end

puts "part2 = #{round_idx+1}"
