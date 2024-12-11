stones = STDIN.each_line(chomp: true).map { |line| line.split.map(&.to_i64) }.sum.to_a

25.times do
  new_stones = [] of Int64
  stones.each do |stone|
    if stone == 0
      new_stones << 1
    elsif (digits = stone.digits).size.even?
      digits.reverse!
      new_stones << digits[0...(digits.size // 2)].join.to_i64 << digits[(digits.size // 2)..].join.to_i64
    else
      new_stones << stone * 2024
    end
  end
  stones = new_stones
end
p stones.size
