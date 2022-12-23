# Construct field
cubes = File.read('input.txt').split.map do |line|
  m = line.match /^(\d+),(\d+),(\d+)$/
  (1..3).map{ |k| m[k].to_i }
end
bounds = cubes.reduce([0,0,0]) do |bounds, cube|
  (0..2).map do |k|
    [bounds[k], cube[k]].max
  end
end
field = Array.new(bounds[0]+1).map do
  Array.new(bounds[1]+1).map do
    Array.new(bounds[2]+1).map{ false }
  end
end
cubes.each do |cube|
  field[cube[0]][cube[1]][cube[2]] = true
end

# Part1 - count surfaces
# We only need to trace each ray from one direction, since we're guaranteed to
# have the exact same surface count from the other direction
count_surfaces_on_ray = Proc.new do |start, axis_idx|
  surface_count = 0
  prev_solid = false
  pos = start
  (start[axis_idx]..bounds[axis_idx]).each do |i|
    pos[axis_idx] = i
    this_solid = field[pos[0]][pos[1]][pos[2]]
    surface_count += 1 if this_solid and not prev_solid
    prev_solid = this_solid
  end
  surface_count
end
count_all_surfaces = Proc.new do
  surface_count = 0
  # X, Z
  (0..bounds[1]).each do |y|
    (0..bounds[2]).each do |z|
      surface_count += count_surfaces_on_ray.call([0, y, z], 0)
    end
    (0..bounds[0]).each do |x|
      surface_count += count_surfaces_on_ray.call([x, y, 0], 2)
    end
  end
  # Y
  (0..bounds[0]).each do |x|
    (0..bounds[2]).each do |z|
      surface_count += count_surfaces_on_ray.call([x, 0, z], 1)
    end
  end
  # Double for reverse direction
  surface_count * 2
end

puts "part1 = #{count_all_surfaces.call}"



# Part2 - fill in interior (unreachable) gaps, then recount as normal
# Mark all empty spaces as "maybe"
(0..bounds[0]).each do |x|
  (0..bounds[1]).each do |y|
    (0..bounds[2]).each do |z|
      field[x][y][z] = :maybe unless field[x][y][z]
    end
  end
end
# Enqueue all the outermost cubes
queue = []
(0..bounds[0]).each do |x|
  (0..bounds[1]).each do |y|
    queue << [x, y, 0]
    queue << [x, y, bounds[2]]
  end
  (0..bounds[2]).each do |z|
    queue << [x, 0, z]
    queue << [x, bounds[1], z]
  end
end
(0..bounds[1]).each do |y|
  (0..bounds[2]).each do |z|
    queue << [0, y, z]
    queue << [bounds[0], y, z]
  end
end
# Scan for all reachable cubes
while queue.length > 0 do
  cube = queue.shift

  next unless field[cube[0]][cube[1]][cube[2]] == :maybe
  field[cube[0]][cube[1]][cube[2]] = false

  queue << [cube[0]-1, cube[1], cube[2]] if cube[0] > 0
  queue << [cube[0]+1, cube[1], cube[2]] if cube[0] < bounds[0]
  queue << [cube[0], cube[1]-1, cube[2]] if cube[1] > 0
  queue << [cube[0], cube[1]+1, cube[2]] if cube[1] < bounds[1]
  queue << [cube[0], cube[1], cube[2]-1] if cube[2] > 0
  queue << [cube[0], cube[1], cube[2]+1] if cube[2] < bounds[2]
end
# Solidify any remaining cubes
(0..bounds[0]).each do |x|
  (0..bounds[1]).each do |y|
    (0..bounds[2]).each do |z|
      field[x][y][z] = true if field[x][y][z] == :maybe
    end
  end
end

puts "part2 = #{count_all_surfaces.call}"
