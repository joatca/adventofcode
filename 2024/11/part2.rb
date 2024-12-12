DEPTHS = [ 25, 75 ]
stones = STDIN.each_line(chomp: true).map { |line| line.split.map { |s| s.to_i } }.flatten

cached_stone_counter = Hash.new { |h, k|
  depth, stone = k
  h[k] = if depth == 0
           1
         elsif stone == 0
           h[[depth - 1, 1]]
         elsif (digits = stone.to_s).size.even?
           half = digits.size / 2
           h[[depth - 1, digits[...half].to_i]] + h[[depth - 1, digits[half..].to_i]]
         else
           h[[depth - 1, stone * 2024]]
         end
}

DEPTHS.each do |depth|
  puts stones.map { |stone| cached_stone_counter[[depth, stone]] }.sum
end
