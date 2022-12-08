part1_score = 0
part2_score = 0
File.read("input.txt").split("\n").each do |line|
  parts = line.split
  opponent = parts[0][0].ord - 'A'.ord
  us = parts[1][0].ord - 'X'.ord

  # X,Y,Z as rock paper scissors
  part1_score += 1 + us
  result = (opponent - us) % 3
  part1_score += [3, 0, 6][result]

  # X,Y,Z as lose,draw,win
  part2_score += [0, 3, 6][us]
  we_throw = (opponent+us+2) % 3
  part2_score += 1 + we_throw
end

puts "part1 = #{part1_score}"
puts "part2 = #{part2_score}"
