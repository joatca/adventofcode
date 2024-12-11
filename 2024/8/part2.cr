require "set"

alias Location = NamedTuple(id: Char, x: Int32, y: Int32)
map = Set(Location).new
max_x, max_y = 0, 0
STDIN.each_line(chomp: true).with_index do |line, y|
  max_y = y
  line.chars.each_with_index do |char, x|
    max_x = x if x > max_x
    map << { id: char, x: x, y: y } if char != '.'
  end
end

def add_to_map(map : Set(Location), max_x : Int32, max_y : Int32, x : Int32, y : Int32, ch : Char)
  if x >= 0 && y >= 0 && x <= max_x && y <= max_y
    map << { id: ch, x: x, y: y }
    true
  else
    false
  end
end

frequencies = map.map { |location| location[:id] }.uniq
frequencies.each do |freq|
  map.select { |a| a[:id] == freq }.combinations(2).each do |combination|
    diff_x, diff_y = combination[1][:x] - combination[0][:x], combination[1][:y] - combination[0][:y]
    [-1, 1].each do |direction|
      (0..).each do |i|
        break unless add_to_map(map, max_x, max_y,
                                combination[0][:x] + direction * diff_x * i,
                                combination[0][:y] + direction * diff_y * i,
                                '#')
      end
    end
  end
end

puts map.select { |a| a[:id] == '#' }.size
