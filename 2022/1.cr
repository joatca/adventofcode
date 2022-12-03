input = STDIN.each_line(delimiter = "\n\n").to_a

puts "Part 1:"
puts input.map { |chunk| chunk.split.map(&.to_i).sum }.max

puts "Part 2:"
puts input.map { |chunk| chunk.split.map(&.to_i).sum }.to_a.sort.reverse.first(3).sum
