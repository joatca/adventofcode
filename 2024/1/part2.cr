left, right = STDIN.each_line.map { |line| line.split.map(&.to_i) }.to_a.transpose
right_count = Hash(Int32, Int32).new(0).merge!(right.tally)
puts left.reduce(0) { |total, lnum| total + lnum * right_count[lnum] }
