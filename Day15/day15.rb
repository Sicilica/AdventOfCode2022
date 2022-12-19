class Pos
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def dist_to(other)
    (@x - other.x).abs + (@y - other.y).abs
  end
end

class SensorReading
  attr_accessor :sensor, :beacon

  def initialize(sensor, beacon)
    @sensor = sensor
    @beacon = beacon
  end

  def to_s
    "[S=#{@sensor.to_s} B=#{@beacon.to_s}]"
  end
end



def expand_bounds(bounds, point)
  [Pos.new([bounds[0].x, point.x].min, [bounds[0].y, point.y].min), Pos.new([bounds[1].x, point.x].max, [bounds[1].y, point.y].max)]
end

bounds = [Pos.new(0, 0), Pos.new(0, 0)]
readings = []
File.read('input.txt').split("\n").each do |line|
  m = line.match(/^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$/)

  reading = SensorReading.new(
    Pos.new(m[1].to_i, m[2].to_i),
    Pos.new(m[3].to_i, m[4].to_i)
  )
  readings << reading
  bounds = expand_bounds(bounds, reading.sensor)
  bounds = expand_bounds(bounds, reading.beacon)
end



def query_row(readings, y)
  # Create regions
  regions = readings.map do |reading|
    sensor_range = reading.sensor.dist_to(reading.beacon)
    dy = (reading.sensor.y - y).abs
    center = reading.sensor.x

    x0 = center - (sensor_range - dy)
    x1 = center + (sensor_range - dy)

    [x0, x1]
  end

  # Remove empty regions
  regions = regions.select{ |region| region[0] <= region[1] }

  # Sort regions
  regions = regions.sort do |a, b|
    a[0] <=> b[0]
  end

  # Combine overlapping regions
  regions = regions.reduce([]) do |memo, region|
    if memo.length > 0 and memo.last[1] >= region[0] - 1
      memo[-1] = [memo.last[0], [memo.last[1], region[1]].max]
    else
      memo << region
    end
    memo
  end

  regions
end

def part1(readings, y)
  beacon_count = readings.select{ |reading| reading.beacon.y == y }.map{ |reading| reading.beacon.x }.group_by{ |k| k }.length
  marked_count = query_row(readings, y).reduce(0) { |sum, region| sum + region[1] - region[0] + 1 }
  marked_count - beacon_count
end

puts "part1 = #{part1(readings, 2000000)}"

def part2(readings, bounds)
  (bounds[1][0]..bounds[1][1]).each do |y|
    regions = query_row(readings, y)

    # Clamp to bounds
    regions = regions.select{ |k| k[1] >= bounds[0][0] and k[0] <= bounds[0][1] }
    if regions.length == 2
      return [regions[0][1] + 1, y]
    end
  end

  'no solution?'
end

missing_beacon = part2(readings, [[0, 4000000], [0, 4000000]])
puts "part2 = #{missing_beacon[0] * 4000000 + missing_beacon[1]}"
