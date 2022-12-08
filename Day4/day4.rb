part1_count = 0
pairs = File.read("input.txt").split("\n").map do |line|
  m = line.match(/^(\d+)-(\d+),(\d+)-(\d+)$/)
  {
    a0: m[1].to_i,
    a1: m[2].to_i,
    b0: m[3].to_i,
    b1: m[4].to_i,
  }
end

puts "part1 = #{pairs.filter{ |p| (p[:a0] <= p[:b0] && p[:a1] >= p[:b1]) || (p[:a0] >= p[:b0] && p[:a1] <= p[:b1])}.length}"
puts "part2 = #{pairs.filter{ |p| !(p[:a0] > p[:b1] || p[:b0] > p[:a1]) }.length}"
