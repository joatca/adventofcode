data = STDIN.each_line.map { |l| l.split.map(&.to_i) }.to_a.transpose
right_count = Hash(Int32, Int32).new(0).merge!(data[1].tally)
puts data[0].reduce(0) { |sum, val| sum += val * right_count[val] }

