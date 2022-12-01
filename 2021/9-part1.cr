map = Hash(Tuple(Int32, Int32), Int32).new { |h, k| h[k] = 9 } # default is always high, makes checking below easier

width = height = 0
STDIN.each_line(chomp: true).each_with_index do |line, y|
  line.each_char_with_index do |ch, x|
    map[{x, y}] = ch.to_i
    width = {x, width}.max
  end
  height = {height, y}.max
end

risks = 0
(0..width).each do |x|
  (0..height).each do |y|
    risks += 1 + map[{x, y}] if [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}].all? { |adjacent| map[adjacent] > map[{x, y}] }
  end
end

p risks
