class Dir

  attr_reader :parent
  attr_reader :name

  def initialize(name, parent)
    @name = name
    @parent = parent
    @files = {}
    @size = nil
  end

  def add(name, sizeOrDir)
    @files[name] = sizeOrDir
  end

  def get(name)
    @files[name]
  end

  def size
    if @size.nil?
      @size = 0
      @files.each do |_, file|
        if file.is_a?(Dir)
          @size += file.size
        else
          @size += file
        end
      end
    end

    @size
  end

  def print
    print! ""
  end

  def print!(indent)
    puts "#{indent}- #{@name} (dir)"
    indent += "  "
    @files.each do |key, val|
      if val.is_a?(Dir)
        val.print!(indent)
      else
        puts "#{indent}- #{key} (file, size=#{val})"
      end
    end
  end

end

root = Dir.new("/", nil)
pwd = root
cmd = nil
all_dirs = [root]
File.read("input.txt").split("\n").each do |line|
  parts = line.split

  if parts[0] == "$"
    cmd = parts[1]
    args = parts[2..]

    case cmd
    when "cd"
      if args[0] == '..'
        pwd = pwd.parent
      elsif args[0] == '/'
        pwd = root
      else
        pwd = pwd.get(args[0])
      end
    when "ls"
      # noop
    else
      raise StandardError.new("unrecognized command")
    end

    next
  end

  case cmd
  when "ls"
    if parts[0] == "dir"
      dir = Dir.new(parts[1], pwd)
      pwd.add(parts[1], dir)
      all_dirs << dir
    else
      pwd.add(parts[1], parts[0].to_i)
    end
  else
    raise StandardError.new("unexpected command output")
  end
end

puts "part 1 = #{all_dirs.filter{ |dir| dir.size <= 100000 }.map{ |dir| dir.size }.reduce{ |a, b| a+b }}"

total_disk_space = 70000000
update_size = 30000000
available_space = total_disk_space - root.size
space_to_free = update_size - available_space
puts "we have #{available_space} free, so must delete at least #{space_to_free}"
min_size = total_disk_space
all_dirs.each do |dir|
  min_size = dir.size if dir.size >= space_to_free and dir.size < min_size
end
puts "best candidate is #{min_size}"
