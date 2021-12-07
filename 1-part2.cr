puts STDIN.each_line.map { |line| line.to_i }.
      cons(3).
      map { |triple| triple.sum }.
      cons_pair.
      reduce(0) { |count, pair| count + (pair[1] > pair[0] ? 1 : 0) }
