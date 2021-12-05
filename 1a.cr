puts STDIN.each_line.map { |line| line.to_i }.cons_pair.map { |pair| pair[1] > pair[0] ? 1 : 0 }.sum
