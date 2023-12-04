require "set"

puts ARGF.each_line(chomp: true).map { |line|
  raise "invalid input line: #{line}" unless line =~ /^Card\s+\d+:(.+)\|(.+)$/
  winning, have = $1.split.to_set, $2.split
  1 << (have.count { |num| winning.includes?(num) } - 1)
}.sum

