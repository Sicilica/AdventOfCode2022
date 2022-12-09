def to_pri(char)
  if char < "a"
    27 + char[0].ord - "A"[0].ord
  else
    1 + char[0].ord - "a"[0].ord
  end
end

sum = 0
File.read("input.txt").split("\n").each do |line|
  len = line.length
  pockets = [
    line[..len/2-1],
    line[len/2..],
  ].map{|pkt| pkt.chars.map{|k| [k, true]}.to_h}

  shared_chars = pockets[0].keys.filter{|k| pockets[1][k]}

  if shared_chars.length != 1
    raise StandardError.new("wtf")
  end
  shared_char = shared_chars[0]

  sum += to_pri(shared_char)
end

puts "priority sum = #{sum}"

# part 2, just throw away part 1 so we can easily parse by threes
sum = 0
lines = File.read("input.txt").split("\n")
group_count = lines.length / 3
(0..group_count-1).each do |g|
  elves = lines[g*3..g*3+2].map{|elf| elf.chars.map{|k| [k, true]}.to_h}

  shared_chars = elves[0].keys.filter{|k| elves[1][k] and elves[2][k]}
  if shared_chars.length != 1
    raise StandardError.new("wtf")
  end
  sum += to_pri(shared_chars[0])
end

puts "part2 = #{sum}"
