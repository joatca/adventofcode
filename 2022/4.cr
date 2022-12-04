input = STDIN.each_line(chomp: true).map { |line|
  pair_res = line.scan(/^(\d+)-(\d+),(\d+)-(\d+)$/).first # raises empty enumerable if there's no match
  { (pair_res[1].to_i)..(pair_res[2].to_i), (pair_res[3].to_i)..(pair_res[4].to_i) }
}.to_a

# add convenience methods to the existing Range
struct Range(B, E)
  def includes?(other : Range(B, E))
    self.begin <= other.begin && self.end >= other.end
  end

  def overlaps?(other : Range(B, E))
    !(self.end < other.begin || self.begin > other.end)
  end
end

puts "Part 1:" # in how many does one pair completely include the other?
puts input.count { |pair| pair.first.includes?(pair.last) || pair.last.includes?(pair.first) }

puts "Part 2:" # in how many do the pairs overlap at all?
puts input.count { |pair| pair.first.overlaps?(pair.last) }
