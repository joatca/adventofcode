A_COST = 3_i64
B_COST = 1_i64
PRIZE_OFFSET = 10000000000000_i64

def least_tokens(ca1 : Int64, ca2 : Int64, cb1 : Int64, cb2 : Int64, va : Int64, vb : Int64)
  # else try to solve this as a pair of simultaneous equations ca1×a + ca2×b = va and cb1×a + cb2×b == vb
  # multiply each equation by the opposite's b coefficient
  ca1, cb1, va, ca2, cb2, vb = ca1 * cb2, cb1 * cb2, va * cb2, ca2 * cb1, cb2 * cb1, vb * cb1
  # subtract one from the other; y coefficient will be zero so we only need to calculate x coefficient and the result
  c = ca1 - ca2
  v = va - vb
  a, amod = v.divmod(c)
  if amod != 0_i64 # one solution but not integral, game isn't winnable, spend no tokens
    puts "not winnable"
    0_i64
  else
    # exactly one solution, calculate the number of tokens; this will be after rearranging
    #  ca1×a + cb1×b = va to b = (va - ca1×a)/cb1
    A_COST * a + B_COST * ((va - ca1 * a) // cb1)
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
    # if prizex % bx == 0 && prizey % by == 0 && prizex // bx == prizey // by
    #   sleep 3
    #   raise "exact B"
    # end
    tokens += least_tokens(ax, ay, bx, by, prizex, prizey)
  end
end
puts tokens
