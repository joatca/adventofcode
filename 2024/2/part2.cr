def is_safe(report : Array(Int32))
  first_diff = (report[0] <=> report[1])
  report.each_cons(2).all? { |c| (c[0] <=> c[1]) == first_diff && (1..3).includes?((c[0]-c[1]).abs) }
end

puts STDIN.each_line(chomp: true).map { |line| line.split.map(&.to_i) }.count { |report|
  is_safe(report) || report.size.times.any? { |i| is_safe(report[0...i] + report[(i+1)..]) }
}
