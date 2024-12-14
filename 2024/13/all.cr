A_COST = 3_i64
B_COST = 1_i64
#PRIZE_OFFSET = 0_i64
PRIZE_OFFSET = 10000000000000_i64

def least_tokens(buta_x : Int64, buta_y : Int64, butb_x : Int64, butb_y : Int64, prize_x : Int64, prize_y : Int64)
  determinant = buta_x*butb_y - buta_y*butb_x
  a = (prize_x * butb_y - prize_y * butb_x) // determinant
  b = (buta_x * prize_y - buta_y * prize_x) // determinant
  if a * buta_x + b * butb_x == prize_x && a * buta_y + b * butb_y == prize_y
    return a * A_COST + b * B_COST
  else
    return 0_i64
  end
end

ax, ay, bx, by, prizex, prizey = 0_i64, 0_i64, 0_i64, 0_i64, 0_i64, 0_i64
tokens = 0_i64
STDIN.each_line(chomp: true) do |line|
  case line
  when /^Button (A|B): X\+(\d+), Y\+(\d+)$/
    puts line
    case $1
    when "A"
      ax, ay = $2.to_i64, $3.to_i64
    when "B"
      bx, by = $2.to_i64, $3.to_i64
    else
      raise "unknown button"
    end
  when /^Prize: X=(\d+), Y=(\d+)$/
    puts line
    prizex, prizey = $1.to_i64 + PRIZE_OFFSET, $2.to_i64 + PRIZE_OFFSET
    puts "a (#{ax},#{ay}) b (#{bx},#{by}) prize (#{prizex},#{prizey})"
    tokens += least_tokens(ax, ay, bx, by, prizex, prizey)
  end
end
puts tokens
