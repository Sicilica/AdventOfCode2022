def all_different(chars)
  (0..chars.length-2).each do |i|
    (i+1..chars.length-1).each do |j|
      if chars[i] == chars[j]
        return false
      end
    end
  end
  return true
end

stream = File.read("input.txt").chars
stream.pop if stream.last == "\n"

idx = (4..stream.length).find do |k|
  segment = stream[k-4..k-1]
  all_different(segment)
end
puts "part1 = #{idx}"

idx = (14..stream.length).find do |k|
  segment = stream[k-14..k-1]
  all_different(segment)
end
puts "part2 = #{idx}"
