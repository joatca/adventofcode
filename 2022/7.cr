TOTAL_DISKSPACE = 70000000
REQUIRED_FREE = 30000000

sizes = Hash(Array(String), Int64).new(default_value: 0)
ls_counts = Hash(Array(String), Int64).new(default_value: 0)
root = [] of String
path = [] of String

STDIN.each_line(chomp: true) do |line|
  case line
  when /^\$ cd (.*)$/
    case $1
    when "/"
      path.clear
    when ".."
      path.pop
    else
      path.push $1
    end
  when /^\$ ls$/
    ls_counts[path] += 1
  when /^dir/
    # ignore
  when /^([0-9]+)/
    if ls_counts[path] == 1 # only record sizes the first time we see an ls
      (0..path.size).each do |pathlen|
        sizes[path[0, pathlen]] += $1.to_i
      end
    end
  end
end

puts "Part 1:"
puts sizes.values.select { |v| v <= 100000 }.sum

unused_space = TOTAL_DISKSPACE - sizes[root]
required_space = REQUIRED_FREE - unused_space

puts "Part 2:"
if required_space > 0
  puts sizes.values.select { |v| v > required_space}.min
else
  puts 0
end
