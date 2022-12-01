STDIN.gets.try do |input|
  positions = input.split(',').map(&.to_i)
  minpos, maxpos = positions.minmax # the best horizontal position must be in this range
  puts (minpos..maxpos).min_of { |pos| positions.map { |crab| (pos-crab).abs }.sum }
end
