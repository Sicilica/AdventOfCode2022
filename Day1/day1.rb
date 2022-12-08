elves = []
current = 0

# Load data
File.read("input.txt").split("\n").each do |line|
  if line == ""
    elves << current
    current = 0
  else
    current += line.to_i
  end
end
elves << current

elves = elves.sort.reverse

puts "the most is #{elves[0]}"
puts "the top 3 are #{(0..2).map{ |k| elves[k]}.reduce{ |a, b| a+b }}"
