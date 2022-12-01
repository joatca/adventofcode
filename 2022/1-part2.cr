puts STDIN.each_line(delimiter = "\n\n").map { |chunk| chunk.split.map(&.to_i).sum }.to_a.sort.reverse.first(3).sum
