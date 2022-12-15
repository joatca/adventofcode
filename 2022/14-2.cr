record Point, x : Int32, y : Int32

SOURCE = Point.new(500, 0)

blocked = Set(Point).new

max_y = SOURCE.y

STDIN.each_line(chomp: true) do |line|
  line.split(" -> ").map { |sp| sp.split(',') }.map { |p| Point.new(p.first.to_i, p.last.to_i) }.each_cons_pair do |from, to|
    if from.x == to.x # vertical
      (from.y..to.y).step(by: (to.y-from.y).sign).each do |y|
        blocked << Point.new(from.x, y)
      end
      max_y = {max_y, from.y, to.y}.max
    else # horizontal
      (from.x..to.x).step(by: (to.x-from.x).sign).each do |x|
        blocked << Point.new(x, from.y)
      end
      max_y = {max_y, from.y}.max
    end
  end
end

def is_blocked(floor : Int32, blocked : Set(Point), x : Int32, y : Int32)
  y >= floor || blocked.includes?(Point.new(x, y))
end

floor = max_y + 2

grains = 0
x, y = SOURCE.x, SOURCE.y
loop do
  break if is_blocked(floor, blocked, SOURCE.x, SOURCE.y)
  if is_blocked(floor, blocked, x, y+1) # directly down is blocked
    if is_blocked(floor, blocked, x-1, y+1) # down and down-left is blocked
      if is_blocked(floor, blocked, x+1, y+1) # all paths are blocked
        blocked << Point.new(x, y)
        grains += 1
        x, y = SOURCE.x, SOURCE.y
      else # down-right not blocked
        x += 1
        y += 1
      end
    else # down-left not blocked
      x -= 1
      y += 1
    end
  else # not blocked below
    y += 1
  end
end

puts "Part 2:"
puts grains
