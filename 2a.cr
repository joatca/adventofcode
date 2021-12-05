position = depth = 0

STDIN.each_line.map { |line| line.chomp.split }.each do |parts|
  direction, amount = parts[0], parts[1].to_i
  case direction
  when "forward"
    position += amount
  when "down"
    depth += amount
  when "up"
    depth -= amount
  end
end

puts "#{position} #{depth} #{position * depth}"

