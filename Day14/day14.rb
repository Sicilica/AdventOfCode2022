DO_PART_TWO = true

# Parse input
# (Note that this converts it to [y, x] format, which we'll use going forward)
paths = File.read('input.txt').split("\n").map{
  |line| line.split(' -> ').map{ |point| point.split(',').map(&:to_i).reverse }
}

# Calculate bounds
bounds = nil
paths.each do |path|
  path.each do |point|
    bounds = [[point[0], point[0]], [point[1], point[1]]] unless bounds
    bounds = [
      [
        [bounds[0][0], point[0]].min,
        [bounds[0][1], point[0]].max,
      ],
      [
        [bounds[1][0], point[1]].min,
        [bounds[1][1], point[1]].max,
      ],
    ]
  end
end
bounds[0][0] = [bounds[0][0], 0].min
if DO_PART_TWO
  bounds[1][0] = [bounds[1][0], 0].min
  bounds[1][1] = [bounds[1][1], 1000].max
  bounds[0][1] += 2
end

# Build cave with rock
cave = Array.new(bounds[0][1]-bounds[0][0] + 1).map{ |row| Array.new(bounds[1][1]-bounds[1][0] + 1) }
offset = [bounds[0][0], bounds[1][0]]
paths.each do |path|
  prev = path[0]
  cave[prev[0] - offset[0]][prev[1] - offset[1]] = :rock
  (1..path.length-1).each do |idx|
    point = path[idx]
    diff = [0, 1].map{ |k| point[k]-prev[k] }
    dir = diff.map{ |k| k <=> 0 }
    dist = diff.map(&:abs).max

    (1..dist).each do |delta|
      sq = [0, 1].map{ |k| prev[k] + dir[k] * delta }
      cave[sq[0] - offset[0]][sq[1] - offset[1]] = :rock
    end
    prev = point
  end
end
if DO_PART_TWO
  (bounds[1][0]..bounds[1][1]).each do |x|
    cave.last[x] = :rock
  end
else
  cave[0 - offset[0]][500 - offset[1]] = :source
end

# Pour sand
sand_count = 0
fell_out_of_bounds = false
while (DO_PART_TWO ? cave[0 - offset[0]][500 - offset[1]] == nil : !fell_out_of_bounds) do
  point = [0 - offset[0], 500 - offset[1]]

  loop do
    fall_to = [
      [1, 0],
      [1, -1],
      [1, 1],
    ].map{
      |k| [k[0] + point[0], k[1] + point[1]]
    }.map{
      |k|
        (k[0] < 0 or
        k[0] >= cave.length or
        k[1] < 0 or
        k[1] >= cave[0].length) ?
          :out_of_bounds : k
    }.find{
      |k|
        k == :out_of_bounds or
        cave[k[0]][k[1]] == nil
    }

    if fall_to
      if fall_to == :out_of_bounds
        fell_out_of_bounds = true
        break
      end
      point = fall_to
    else
      cave[point[0]][point[1]] = :sand
      sand_count += 1
      break
    end
  end
end

# Debug print stuff
# puts bounds.to_s
# cave.each do |row|
#   row_str = row.map do |sq|
#     case sq
#     when :source
#       '+'
#     when :rock
#       '#'
#     when :sand
#       'o'
#     else
#       '.'
#     end
#   end
#   puts row_str.join
# end

# Answers
puts "result = #{sand_count}"
