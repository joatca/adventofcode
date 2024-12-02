puts STDIN.each_line.map { |line| line.split.map(&.to_i) }.to_a.transpose.map(&.sort!).transpose.reduce(0) { |sum, pair| sum += (pair[0]-pair[1]).abs }

