class Rock

  attr_accessor :width, :height

  def initialize(pattern)
    @width = pattern[0].length
    @height = pattern.length

    @data = Array.new(@width * @height)
    (0..@height-1).each do |y|
      (0..@width-1).each do |x|
        @data[x + y * @width] = (pattern[y][x] == '#')
      end
    end
  end

  def solid_at?(x, y)
    @data[x + y * @width]
  end

  # If this rock had its bottom-left corner at (x, y), would it collide with
  # existing tiles in the field?
  def overlaps_field?(field, x, y, field_width)
    if x < 0 or x + @width > field_width or y < 0
      return true
    end

    (0..@height-1).each do |suby|
      next if y+suby >= field.length
      (0..@width-1).each do |subx|
        next unless solid_at?(subx, suby)

        if field[y+suby][x+subx]
          return true
        end
      end
    end

    return false
  end

end



jet_pattern = File.read('input.txt').chars[..-2].map{ |char| char == "<" ? -1 : 1 }

rocks = [
  [
    "####",
  ],
  [
    ".#.",
    "###",
    ".#.",
  ],
  [
    "..#",
    "..#",
    "###",
    # It doesn't matter for the other rocks, but flipping this rock on Y to make
    # it work easier
  ].reverse,
  [
    "#",
    "#",
    "#",
    "#",
  ],
  [
    "##",
    "##",
  ],
].map{ |k| Rock.new(k) }

def clamp(n, min, max)
  [[n, min].max, max].min
end



FIELD_WIDTH = 7

field = []
jet_idx = 0
drop_rock_with_index = Proc.new do |idx|
  rock = rocks[idx % rocks.length]

  # rock_x and rock_y track the bottom-left corner of the rock, with +y being upward
  rock_x = 2
  rock_y = field.length

  # before we actually reach the base position above, we will have encountered
  # three jets
  (1..3).each do
    rock_x = clamp(rock_x + jet_pattern[jet_idx % jet_pattern.length], 0, FIELD_WIDTH - rock.width)
    jet_idx += 1
  end

  # move until we land
  loop do
    # Attempt jet movement
    jet_delta = jet_pattern[jet_idx % jet_pattern.length]
    jet_idx += 1
    rock_x += jet_delta unless rock.overlaps_field?(field, rock_x + jet_delta, rock_y, FIELD_WIDTH)

    # Attempt falling movement
    if rock.overlaps_field?(field, rock_x, rock_y - 1, FIELD_WIDTH)
      break
    else
      rock_y -= 1
    end
  end

  # add rock to field
  added_height = rock_y + rock.height - field.length
  (1..added_height).each do
    field << Array.new(7).map{ |_k| false }
  end
  (0..rock.height-1).each do |suby|
    (0..rock.width-1).each do |subx|
      field[rock_y+suby][rock_x+subx] = true if rock.solid_at?(subx, suby)
    end
  end
end

PART1_COUNT = 2022
(0..PART1_COUNT-1).each do |rock_idx|
  drop_rock_with_index.call rock_idx
end

puts "part1 = #{field.length}"



field = []
jet_idx = 0
rock_idx = 0
history = {}
REPETITIONS_BEFORE_STABLE = 3
stable_state_str = nil
loop do
  drop_rock_with_index.call rock_idx
  rock_idx += 1

  state_str = "r#{rock_idx%5}j#{jet_idx%jet_pattern.length}"
  history[state_str] = [] unless history.has_key?(state_str)
  history[state_str] << {
    height: field.length,
    rock_idx: rock_idx,
    jet_idx: jet_idx
  }

  h = history[state_str]
  if h.length == REPETITIONS_BEFORE_STABLE + 1
    gaps = (1..h.length-1).map do |k|
      ({
        height: h[k][:height] - h[k-1][:height],
        rocks: h[k][:rock_idx] - h[k-1][:rock_idx],
        jets: h[k][:jet_idx] - h[k-1][:jet_idx],
      })
    end
    stable = (1..gaps.length-1).all? do |k|
      gaps[k][:height] == gaps[k-1][:height] &&
      gaps[k][:rocks] == gaps[k-1][:rocks] &&
      gaps[k][:jets] == gaps[k-1][:jets]
    end
    if stable
      puts "found stable pattern '#{state_str}' with gaps #{gaps[0].to_s}"
      stable_state_str = state_str
      break
    end
  end
end

ONE_TRILLION = 1000000000000
intro_rocks = history[stable_state_str][0][:rock_idx]
intro_height = history[stable_state_str][0][:height]
puts "the height of the first section - before the loop - is #{intro_height}, after #{intro_rocks} rocks"
loop_rocks = history[stable_state_str][1][:rock_idx] - history[stable_state_str][0][:rock_idx]
loop_height = history[stable_state_str][1][:height] - history[stable_state_str][0][:height]
puts "each loop iteration uses #{loop_rocks} rocks and adds #{loop_height} height"
loop_count = (ONE_TRILLION - intro_rocks) / loop_rocks
puts "we can complete this loop #{loop_count} times, for #{loop_count * loop_height} height"
outro_rocks = ONE_TRILLION - intro_rocks - loop_rocks * loop_count
puts "then we will still have #{outro_rocks} rocks left to complete a partial cycle"

pre_outro_height = field.length
(1..outro_rocks).each do
  drop_rock_with_index.call rock_idx
  rock_idx += 1
end

outro_height = field.length - pre_outro_height
puts "that gives an extra #{outro_height} height"
puts "so our final height is: #{intro_height + loop_count * loop_height + outro_height}"
