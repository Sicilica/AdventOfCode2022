initial_box_lines = []
stacks_p1 = nil
stacks_p2 = nil
File.read("input.txt").split("\n").each do |line|
  if stacks_p1 == nil
    if line == ""
      stacks_p1 = (1..initial_box_lines.pop.split.last.to_i).map{|_k| []}
      initial_box_lines.reverse.each do |line|
        (0..stacks_p1.length-1).each do |k|
          idx = 4 * k + 1
          if idx >= line.length or line[idx] == " "
            next
          end
          stacks_p1[k] << line[idx]
        end
      end
      stacks_p2 = stacks_p1.map(&:dup)
    else
      initial_box_lines << line
    end
    next
  end

  m = line.match /^move (\d+) from (\d+) to (\d+)$/
  count = m[1].to_i
  src = m[2].to_i - 1
  dst = m[3].to_i - 1

  # part 1
  (1..count).each do
    stacks_p1[dst] << stacks_p1[src].pop
  end

  # part 2
  crates = stacks_p2[src][stacks_p2[src].length-count..]
  stacks_p2[dst] = stacks_p2[dst] + crates
  (1..count).each do
    stacks_p2[src].pop
  end
end

puts "part1 = #{stacks_p1.map(&:last).join("")}"
puts "part2 = #{stacks_p2.map(&:last).join("")}"
