require 'json'

def compare(a, b)
  if a.is_a?(Integer) and b.is_a?(Integer)
    a <=> b
  else
    a = [a] if a.is_a? Integer
    b = [b] if b.is_a? Integer

    min = [a.length, b.length].min
    (0..min-1).each do |i|
      sub_result = compare(a[i], b[i])
      return sub_result if sub_result != 0
    end

    a.length <=> b.length
  end
end

first_packet = nil
pair_index = 1
part1_sum = 0
all_packets = []
File.read('input.txt').split("\n").each do |line|
  next if line == ''


  pkt = JSON.parse(line)
  all_packets << pkt
  unless first_packet
    first_packet = pkt
    next
  end

  part1_sum += pair_index if compare(first_packet, pkt) <= 0
  first_packet = nil
  pair_index += 1
end

puts "part1 = #{part1_sum}"

divider_a = [[2]]
divider_b = [[6]]
all_packets << divider_a
all_packets << divider_b

all_packets = all_packets.sort{|a, b| compare(a, b)}

index_a = 1 + all_packets.find_index(divider_a)
index_b = 1 + all_packets.find_index(divider_b)
puts "part2 = #{index_a * index_b}"
