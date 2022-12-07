STDIN.each_char.cons(14).with_index.find { |t| t.first.to_set.size == 14 }.try { |x| puts x.last + 14 }
