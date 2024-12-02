puts STDIN.each_line(chomp: true).map { |line| line.split.map(&.to_i) }.count { |report|
  first_diff = (report[0] <=> report[1])
  report.each_cons(2).to_a.all? { |cons| (cons[0] <=> cons[1]) == first_diff && (1..3).includes?((cons[0]-cons[1]).abs) }
}
