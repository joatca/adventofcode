struct Sensor
  property px, py, bx, by, dist_limit
  
  @known_range : Int64
  
  def initialize(@px : Int64, @py : Int64, @bx : Int64, @by : Int64)
    @known_range = mdist(@px, @py, @bx, @by)
  end

  def mdist(x1 : Int64, y1 : Int64, x2 : Int64, y2 : Int64)
    (x1 - x2).abs + (y1 - y2).abs
  end

  def mdist_other(ox : Int64, oy : Int64)
    mdist(@px, @py, ox, oy)
  end

  def out_of_range?(ox : Int64, oy : Int64)
    mdist_other(ox, oy) > @known_range
  end
  
  def no_beacon_possible?(ox : Int64, oy : Int64)
    !(ox == @bx && oy == @by) && mdist_other(ox, oy) <= @known_range
  end

  def min_x_extent
    @px - @known_range
  end

  def max_x_extent
    @px + @known_range
  end

  def min_y_extent
    @py - @known_range
  end

  def max_y_extent
    @py + @known_range
  end

  # yield each pixel outside of the border of the extent
  def border_pixels
    border_dist = @known_range + 1
    @known_range.times do |i|
      yield @px + i, @py - border_dist + i # from top down to the right
      yield @px + border_dist - i, @py + i # from right down to the left
      yield @px - i, @py + border_dist - i # from bottom up to the left
      yield @px - border_dist + i, @py - i # from left up to the right
    end
  end
end

sensors = [] of Sensor
STDIN.each_line do |line|
  if line =~ /^sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/i
    sensors << Sensor.new($1.to_i64, $2.to_i64, $3.to_i64, $4.to_i64)
  end
end

map_min_x = sensors.map { |s| s.min_x_extent }.min
map_max_x = sensors.map { |s| s.max_x_extent }.max
map_min_y = sensors.map { |s| s.min_y_extent }.min
map_max_y = sensors.map { |s| s.max_y_extent }.max

test_y = ARGV.shift.to_i64

puts "Part 1:"
puts (map_min_x..map_max_x).count { |x| sensors.any? { |s| s.no_beacon_possible?(x, test_y) } }

search_range = 0..4000000
puts "Part 2:"
sensors.each_with_index do |sensor, i|
  sensor.border_pixels do |x, y|
    next unless search_range.includes?(x) && search_range.includes?(y)
    if sensors.reject(sensor).all? { |s| s.out_of_range?(x, y) }
      puts x * 4000000 + y
      exit 0
    end
  end
end
