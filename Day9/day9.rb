class Offset

  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Offset.new(@x + other.x, @y + other.y)
  end

  def -(other)
    Offset.new(@x - other.x, @y - other.y)
  end

  def to_dir
    Offset.new(@x <=> 0, @y <=> 0)
  end

  def to_s
    "(#{@x}, #{@y})"
  end

end

rope_length = 10

rope = (1..rope_length).map{|_k| Offset.new(0, 0)}
tail_hist = {}
tail_hist[rope[0].to_s] = true
File.read("input.txt").split("\n").each do |line|
  parts = line.split

  case parts[0]
  when 'U'
    dir = Offset.new(0, 1)
  when 'D'
    dir = Offset.new(0, -1)
  when 'L'
    dir = Offset.new(-1, 0)
  when 'R'
    dir = Offset.new(1, 0)
  end

  dist = parts[1].to_i

  (1..dist).each do
    rope[0] = rope[0] + dir

    (1..rope_length-1).each do |k|
      delta = rope[k-1] - rope[k]
      if delta.x.abs > 1 or delta.y.abs > 1
        rope[k] = rope[k] + delta.to_dir
      end
    end

    tail_hist[rope[rope_length-1].to_s] = true
  end
end

puts "rope length #{rope_length}, tail visits #{tail_hist.length} positions"
