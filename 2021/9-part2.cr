# we assume here that every basin has exactly one low point

alias Point = Tuple(Int32, Int32)

map = Hash(Point, Int32).new { |h, k| h[k] = 9 } # default is always high, makes checking below easier

width = height = 0
STDIN.each_line(chomp: true).each_with_index do |line, y|
  line.each_char_with_index do |ch, x|
    map[{x, y}] = ch.to_i
    width = {x, width}.max
  end
  height += 1
end

low_points = Array(Point).new

(0..width).each do |x|
  (0..height).each do |y|
    low_points << {x, y} if [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}].all? { |adjacent| map[adjacent] > map[{x, y}] }
  end
end

def find_basin_size(map : Hash(Point, Int32), x : Int32, y : Int32)
  return 0 if map[{x, y}] >= 9
  map.delete({x, y}) # effectively marks it as done
  return 1 + [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}].reduce(0) { |size, point| size + find_basin_size(map, point[0], point[1]) }
end

puts "Low points: #{low_points.inspect}"

largest_basins = low_points.map { |lp| find_basin_size(map, lp[0], lp[1]) }.sort_by! { |size| -size }[0,3]

puts "Largest basin sizes #{largest_basins.inspect} top 3 product #{largest_basins.product}"
