DIRECTIONS = [ { x: 0, y: -1 }, { x: 1, y: 0 }, { x: 0, y: 1 }, { x: -1, y: 0 } ]

guard_x = guard_y = direction = 0
map = STDIN.each_line(chomp: true).with_index.map { |line, y|
  line.chars.each_with_index.map { |ch, x|
    case ch
    when '^'
      guard_x, guard_y = x, y
      'X'
    else
      ch
    end
  }.to_a
}.to_a

loop do
  next_x, next_y = guard_x + DIRECTIONS[direction][:x], guard_y + DIRECTIONS[direction][:y]
  break if next_x < 0 || next_y < 0 || next_x >= map[0].size || next_y >= map.size # left area
  if map[next_y][next_x] == '#'
    direction = (direction + 1) % DIRECTIONS.size
  else
    guard_x, guard_y = next_x, next_y
    map[guard_y][guard_x] = 'X'
  end
  # puts "(#{guard_x},#{guard_y})"
  # map.each do |row|
  #   puts row.join("")
  # end
end

puts "Visited #{map.reduce(0) { |a, row| a + row.count('X') }}"
