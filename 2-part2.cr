position = depth = aim = 0

STDIN.each_line.map { |line| line.chomp.split }.each do |parts|
  direction, amount = parts[0], parts[1].to_i
  case direction
  when "forward"
    position += amount
    depth += aim * amount
  when "down"
    aim += amount
  when "up"
    aim -= amount
  end
end

puts position * depth
