class ValveRoom
  attr_accessor :name, :flow_rate, :tunnels

  attr_accessor :dist_to

  def to_s
    "#{@name} #{@flow_rate} #{@tunnels.to_s}"
  end
end

# Parse
valves_map = {}
valves_arr = []
File.read('input.txt').split("\n").each do |line|
  m = line.match(/^Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.+)$/)

  v = ValveRoom.new
  v.name = m[1]
  v.flow_rate = m[2].to_i
  v.tunnels = m[3].split(', ')
  valves_map[v.name] = v
  valves_arr << v
end

if valves_map['AA'].flow_rate > 0
  puts 'uhhhh AA having flow_rate isn\'t supported :)'
  return
end

# We really only care about going to these valves
# Sort them, for cache key generation later
nonzero_valves = valves_arr.select{ |v| v.flow_rate > 0 }.map{ |v| v.name }.sort

# Calculate paths to every nonzero valve (to save time later)
puts 'Precomputing paths.'
valves_arr.each do |v|
  v.dist_to = {}
end
nonzero_valves.each do |target|
  valves_map[target].dist_to[target] = 0
  explore = [valves_map[target]]

  while explore.length > 0 do
    old_explore = explore
    explore = []
    old_explore.each do |v|
      v.tunnels.each do |tunnel|
        next unless valves_map[tunnel].dist_to[target].nil?

        valves_map[tunnel].dist_to[target] = v.dist_to[target] + 1
        explore << valves_map[tunnel]
      end
    end
  end
end

# Recursive function
def solver(valves_map, start_pos, open_valves, time, solver_cache)
  return 0 if open_valves.length == 0

  cache_key = "#{start_pos}::#{time}::#{open_valves.join}"
  return solver_cache[cache_key] if solver_cache.has_key? cache_key

  start_room = valves_map[start_pos]
  options = open_valves.map do |target|
    dist = start_room.dist_to[target]
    if time < dist + 2
      0
    else
      valve_room = valves_map[target]
      immediate_value = valve_room.flow_rate * (time - dist - 1)
      remaining_valves = open_valves.select{ |v| v != target }

      immediate_value + solver(valves_map, target, remaining_valves, time - dist - 1, solver_cache)
    end
  end
  solver_cache[cache_key] = options.max
  options.max
end

# For part2, we can just find a way to assign sets of valves to each agent
def part2_solver(valves_map, unclaimed_valves, p1_valves, p2_valves, solver_cache)
  if unclaimed_valves.length == 0
    return solver(valves_map, 'AA', p1_valves, 26, solver_cache) + solver(valves_map, 'AA', p2_valves, 26, solver_cache)
  end

  return [
    part2_solver(valves_map, unclaimed_valves[1..], p1_valves + unclaimed_valves[..0], p2_valves, solver_cache),
    part2_solver(valves_map, unclaimed_valves[1..], p1_valves, p2_valves + unclaimed_valves[..0], solver_cache),
  ].max
end

# Now go!
solver_cache = {}
puts "Solving."
puts "part1 = #{solver(valves_map, 'AA', nonzero_valves, 30, solver_cache)}"
puts "part2 = #{part2_solver(valves_map, nonzero_valves[1..], [nonzero_valves[0]], [], solver_cache)}"
