puts STDIN.each_line(chomp: true).map { |line| line.split.map(&.to_i) }.count { |report|
  first_diff = (report[0] <=> report[1])
  report.each_cons(2).all? { |c| (c[0] <=> c[1]) == first_diff && (1..3).includes?((c[0]-c[1]).abs) }
}
