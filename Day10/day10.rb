time = 1
register = 1
sample_times = [20, 60, 100, 140, 180, 220]
sum = 0
display = (1..6).map{|_i| (1..40).map{|_j| '.'}}

cycle = Proc.new do
  sum += (time * register) if sample_times.include? time

  x = (time - 1) % 40
  y = (time - 1) / 40
  display[y][x] = '#' if (register - x).abs <= 1

  time += 1
end

File.read("input.txt").split("\n").each do |line|
  parts = line.split

  case parts[0]
  when 'addx'
    cycle.call
    cycle.call
    register += parts[1].to_i
  when 'noop'
    cycle.call
  end
end

if time <= 220
  puts "ended before 220"
end

puts "part1 = #{sum} (t=#{time}, x=#{register})"
display.each { |line| puts line.join }
