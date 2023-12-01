puts ARGF.each_line.map { |line| line.chars.select(&.number?).map(&.to_i) }.map { |ary| ary.first * 10 + ary.last }.sum
