DO_PART_TWO = true

src = nil
dst = nil
heights = []

File.read("input.txt").split("\n").each do |line|
  src = [heights.length, line.index('S')] if line.include?('S')
  dst = [heights.length, line.index('E')] if line.include?('E')

  heights << line.chars.map{|k| k == 'S' ? 'a' : k}.map{|k| k == 'E' ? 'z' : k}.map{|k| k.ord - 'a'.ord}
end

steps = (1..heights.length).map{|k| (1..heights[0].length).map{|k| -1 }}
dist = 0
new_spots = []

explore = Proc.new do |height, spot|
  next if spot[0] < 0 or spot[0] >= heights.length or spot[1] < 0 or spot[1] >= heights[0].length
  next if steps[spot[0]][spot[1]] != -1

  if heights[spot[0]][spot[1]] <= height+1
    steps[spot[0]][spot[1]] = dist
    new_spots << spot
  end
end

if DO_PART_TWO
  (0..heights.length-1).each do |x|
    (0..heights[0].length-1).each do |y|
      explore.call(-1, [x, y])
    end
  end
else
  explore.call(0, src)
end

while new_spots.length > 0 do
  old_spots = new_spots
  new_spots = []
  dist += 1

  old_spots.each do |spot|
    height = heights[spot[0]][spot[1]]
    explore.call(height, [spot[0] + 1, spot[1]])
    explore.call(height, [spot[0] - 1, spot[1]])
    explore.call(height, [spot[0], spot[1] + 1])
    explore.call(height, [spot[0], spot[1] - 1])
  end
end

puts "steps = #{steps[dst[0]][dst[1]]}"
