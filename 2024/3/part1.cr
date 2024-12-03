puts STDIN.each_line.map { |l| l.scan(/mul\((\d{1,3}),(\d{1,3})\)/).reduce(0) { |sum, md| sum + md[1].to_i * md[2].to_i } }.sum
