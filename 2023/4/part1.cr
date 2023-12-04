require "set"

puts ARGF.each_line(chomp: true).map { |line|
  if line =~ /^Card\s+(\d+):(.+)\|(.+)$/
    num, winning, have = $1, $2.split.to_set, $3.split
    1 << (have.count { |num| winning.includes?(num) } - 1)
  else
    raise "invalid input line: #{line}"
  end
}.sum

