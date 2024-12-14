require "set"

class Robot
  getter :x, :y
  def initialize(@x : Int64, @y : Int64, @vx : Int64, @vy : Int64)
  end
  def move(seconds : Int64, width : Int64, height : Int64)
    @x = (@x + seconds * @vx) % width
    @y = (@y + seconds * @vy) % height
  end
  def quadrant(width : Int64, height : Int64)
    mid_x, mid_y = width // 2, height // 2
    return nil if @x == mid_x || @y == mid_y
    @x < mid_x ? (@y < mid_y ? 0 : 1) : (@y < mid_y ? 2 : 3)
  end
end

class Map
  SHAPE_MINIMUM = 20_i64
  @robots : Array(Robot)
  def initialize(@width : Int64, @height : Int64, io : IO)
    raise "invalid map" if @width % 2 == 0 || @height % 2 == 0
    @robots = io.each_line(chomp: true).map { |line|
      line =~ /^p=(\d+),(\d+) v=(-?\d+),(-?\d+)$/
      Robot.new($1.to_i64, $2.to_i64, $3.to_i64, $4.to_i64)
    }.to_a
    @time = 0_i64
  end
  def move_to_seconds(seconds : Int64)
    @robots.each do |robot|
      robot.move(seconds - @time, @width, @height)
    end
    @time = seconds
  end
  def safety_factor
    @robots.map { |r| r.quadrant(@width, @height) }.compact.tally.values.product
  end
  def point_set
    @robots.map { |r| { r.x, r.y } }.to_set
  end
  def render
    points = point_set
    puts @height.times.map { |y| @width.times.map { |x| points.includes?({x, y}) ? 'X' : ' ' }.join }.join("\n")
  end
  def shape_size(points, current : Tuple(Int64, Int64))
    if points.includes?(current)
      points.delete(current)
      x, y = current.first, current.last
      1_i64 + shape_size(points, { x+1_i64, y }) + shape_size(points, { x-1_i64, y }) +
        shape_size(points, { x, y+1_i64 }) + shape_size(points, { x, y-1_i64 })
    else
      0_i64
    end
  end
  def shape_exists
    points = point_set
    while points.size > 0
      return true if shape_size(points, points.first) > SHAPE_MINIMUM
    end
    false
  end
end

width = ARGV.shift.to_i64
height = ARGV.shift.to_i64
intervals = ARGV.map(&.to_i64)

map = Map.new(width, height, STDIN)
intervals.sort.each do |seconds|
  puts "@#{seconds}" if seconds % 10000 == 0
  map.move_to_seconds(seconds)
  puts "Part 1, #{seconds}s: #{map.safety_factor}"
end
(0_i64..).each do |seconds|
  map.move_to_seconds(seconds)
  if map.shape_exists
    map.render
    puts "Part 2 large shape found at #{seconds}s"
    break
  end
end
