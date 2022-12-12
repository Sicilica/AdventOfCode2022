class Monkey

  attr_accessor :items, :operation, :test, :on_true, :on_false, :inspect_count

  def initialize
    @inspect_count = 0
  end

end

DO_PART_2 = true

monkeys = []

current_monkey = nil
factor = 1
File.read("input.txt").split("\n").each do |line|
  if line.start_with?("  ")
    parts = line.split
    case parts[0]
    when "Starting"
      current_monkey.items = parts[2..].map do |x|
        x = x[..-2] if x.end_with? ","
        x.to_i
      end
    when "Operation:"
      sym = parts[4]
      amt = parts[5]
      if amt == "old"
        sym = "**"
      else
        amt = amt.to_i
      end

      current_monkey.operation = Proc.new do |x|
        case sym
        when "+"
          x + amt
        when "*"
          x * amt
        when "**"
          x * x
        end
      end
    when "Test:"
      divisor = parts[3].to_i
      factor *= divisor
      current_monkey.test = Proc.new do |x|
        x % divisor == 0
      end
    when "If"
      case parts[1]
      when "true:"
        current_monkey.on_true = parts[5].to_i
      when "false:"
        current_monkey.on_false = parts[5].to_i
      end
    end
  elsif line.start_with?("Monkey")
    current_monkey = Monkey.new
    monkeys << current_monkey
  end
end

round_count = 20
round_count = 10000 if DO_PART_2
(1..round_count).each do
  monkeys.each do |monkey|
    while monkey.items.length > 0 do
      monkey.inspect_count += 1
      item = monkey.items.shift
      item = monkey.operation.call(item)
      if DO_PART_2
        item = item % factor
      else
        item = item / 3
      end
      if monkey.test.call(item)
        monkeys[monkey.on_true].items << item
      else
        monkeys[monkey.on_false].items << item
      end
    end
  end
end

# monkeys.each do |monkey|
#   puts monkey.inspect_count
# end

counts = monkeys.map{|k| k.inspect_count}.sort.reverse
puts "monkey business = #{counts[0]*counts[1]}"
