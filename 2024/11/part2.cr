DEPTHS = {25, 75}
stones = STDIN.each_line(chomp: true).map { |line| line.split.map(&.to_i64) }.sum.to_a

class CachedStoneCounter
  def initialize
    @cache = Hash(Tuple(Int32, Int64), Int64).new
  end

  # this really should work as a Hash init block but it doesn't, the recursion screws up weirdly
  def count(depth : Int32, stone : Int64)
    @cache[{depth, stone}] ||= if depth == 0
                                 1_i64
                               elsif stone == 0
                                 count(depth - 1, 1_i64)
                               elsif (digits = stone.to_s).size.even?
                                 half = digits.size // 2
                                 count(depth - 1, digits[...half].to_i64) + count(depth - 1, digits[half..].to_i64)
                               else
                                 count(depth - 1, stone * 2024)
                               end
    @cache[{depth, stone}]
  end
end

stone_counter = CachedStoneCounter.new
DEPTHS.each do |depth|
  puts stones.map { |stone| stone_counter.count(depth, stone) }.sum
end
