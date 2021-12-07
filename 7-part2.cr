# sum of an arithmetic sequence; a = first term, d = common difference, n = number of terms
def arith(a : Int32, d : Int32, n : Int32)
  n * (2*a + (n-1) * d) // 2
end

STDIN.gets.try do |input|
  positions = input.split(',').map(&.to_i)
  minpos, maxpos = positions.minmax # the best horizontal position must be in this range
  puts (minpos..maxpos).min_of { |pos| positions.map { |crab| arith(1, 1, (pos-crab).abs) }.sum }
end
