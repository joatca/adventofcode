A_COST = 3_i64
B_COST = 1_i64
PRIZE_OFFSET = 0_i64 #10000000000000_i64

def least_tokens(buta_x : Int64, buta_y : Int64, butb_x : Int64, butb_y : Int64, prize_x : Int64, prize_y : Int64)
  # else try to solve this as a pair of simultaneous equations buta_x×a + butb_x×b = prize_x and buta_y×a + butb_y×b == prize_y
  # multiply each equation by the opposite's a coefficient
  buta_x, butb_x, prize_x, buta_y, butb_y, prize_y = buta_x * buta_y, butb_x * buta_y, prize_x * buta_y, buta_y * buta_x, butb_y * buta_x, prize_y * buta_x
  # subtract one from the other; a coefficient will be zero so we only need to calculate b coefficient and the result
  c = butb_x - butb_y
  cdebug = buta_x - buta_y
  raise "oops" unless cdebug == 0
  v = prize_x - prize_y
  b, bmod = v.divmod(c)
  if bmod != 0_i64 # one solution but not integral, game isn't winnable, spend no tokens
    puts "not winnable"
    0_i64
  elsif b == 0
    raise "oops"
    0_i64
  else
    # exactly one solution, calculate the number of tokens; this will be after rearranging
    #  buta_x×a + butb_x×b = prize_x to a = (prize_x - butb_x×b)/buta_x
    B_COST * b + A_COST * ((prize_x - butb_x * b) // buta_x)
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
