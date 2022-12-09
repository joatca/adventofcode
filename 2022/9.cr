struct Point
  property x, y
  
  def initialize(@x : Int32, @y : Int32)
  end

  def +(other : Point)
    Point.new(@x + other.x, @y + other.y)
  end

  def -(other : Point)
    Point.new(@x - other.x, @y - other.y)
  end

  def abs_offset
    Point.new(@x.abs, @y.abs)
  end

  def touching?(other : Point)
    diff = (self - other).abs_offset
    diff.x <= 1 && diff.y <= 1
  end

  def sign
    Point.new(@x.sign, @y.sign)
  end
end

struct PlanckRope
  @knots : Array(Point)

  def initialize(x : Int32, y : Int32, knots : Int32)
    raise "need at least 2 knots" if knots < 2
    @knots = Array(Point).new(knots, Point.new(x, y)) # since Point is a struct it's a value type, not a reference
    @tail_visited = Set(Point).new
    record_visit
  end
  
  def record_visit
    @tail_visited << @knots.last
  end
  
  def move_head(direction : Point, count : Int32)
    count.times do
      @knots[0] += direction
      tail_follow_step
    end
  end

  # if necessary, move the tail knots after one head step, per the rules
  def tail_follow_step
    (1...@knots.size).each do |ki|
      @knots[ki] += (@knots[ki-1] - @knots[ki]).sign unless @knots[ki].touching?(@knots[ki-1])
    end
    record_visit
  end

  def tail_visit_count
    @tail_visited.size
  end
end

MOVES = {
  "U" => Point.new(0, -1),
  "D" => Point.new(0, 1),
  "L" => Point.new(-1, 0),
  "R" => Point.new(1, 0)
}

short_rope = PlanckRope.new(0, 0, 2)
long_rope = PlanckRope.new(0, 0, 10)

STDIN.each_line(chomp: true) do |line|
  d, c = line.split
  direction, count = MOVES[d], c.to_i # raises if input is invalid
  short_rope.move_head(direction, count)
  long_rope.move_head(direction, count) # we could instead just track two points on the same rope, but meh
end

puts "Part 1:"
puts short_rope.tail_visit_count

puts "Part 2:"
puts long_rope.tail_visit_count
