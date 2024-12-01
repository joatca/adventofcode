puts STDIN.each_line.map { |l| l.split.map(&.to_i) }.to_a.transpose.map(&.sort).transpose.reduce(0) { |s, p| s += (p[0]-p[1]).abs }

