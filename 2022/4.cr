input = STDIN.each_line(chomp: true).map { |line|
  pair_res = line.scan(/^(\d+)-(\d+),(\d+)-(\d+)$/).first # raises empty enumerable if there's no match
  { (pair_res[1].to_i)..(pair_res[2].to_i), (pair_res[3].to_i)..(pair_res[4].to_i) }
}.to_a

puts "Part 1:" # in how many does one pair completely include the other?
puts input.count { |pair|
  (pair.first.begin <= pair.last.begin && pair.first.end >= pair.last.end) ||
    (pair.last.begin <= pair.first.begin && pair.last.end >= pair.first.end)
}

puts "Part 2:" # in how many do the pairs overlap at all?
puts input.count { |pair|
  !(pair.first.end < pair.last.begin || pair.first.begin > pair.last.end)
}
