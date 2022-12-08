data = File.read("input.txt").split("\n").map do |line|
  line.split("").map{ |char| char.to_i }
end
w = data[0].length
h = data.length

# brute force, cause it's not even THAT big
seen = (1..w*h).map{ |k| false }
(0..w-1).each do |i|
  height = -1
  (0..h-1).each do |j|
    if data[j][i] > height
      seen[i+j*w] = true
      height = data[j][i]
    end
  end
  height = -1
  (0..h-1).reverse_each do |j|
    if data[j][i] > height
      seen[i+j*w] = true
      height = data[j][i]
    end
  end
end
(0..h-1).each do |j|
  height = -1
  (0..w-1).each do |i|
    if data[j][i] > height
      seen[i+j*w] = true
      height = data[j][i]
    end
  end
  height = -1
  (0..w-1).reverse_each do |i|
    if data[j][i] > height
      seen[i+j*w] = true
      height = data[j][i]
    end
  end
end
puts "visible trees from outside = #{seen.select{ |k| k }.length}"

# part 2
def clean(base, idx)
  if idx.nil?
    base
  else
    idx + 1
  end
end
max_score = 0
(0..w-1).each do |x|
  (0..h-1).each do |y|
    score = 1

    # left
    score *= clean(x, (0..x-1).map{|k|k}.reverse.find_index{ |i| data[y][i] >= data[y][x] })
    # right
    score *= clean(w-x-1, (x+1..w-1).map{|k|k}.find_index{ |i| data[y][i] >= data[y][x] })
    # up
    score *= clean(y, (0..y-1).map{|k|k}.reverse.find_index{ |i| data[i][x] >= data[y][x] })
    # down
    score *= clean(h-y-1, (y+1..h-1).map{|k|k}.find_index{ |i| data[i][x] >= data[y][x] })

    max_score = score if score > max_score
  end
end

puts "max scenic = #{max_score}"
