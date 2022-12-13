class MapPoint
  property distance_value, neighbour_costs, height
  setter neighbour_checker : Proc(MapPoint, MapPoint, Bool)?
  def initialize(height_ch : Char)
    @height = case height_ch
              when 'S'
                0
              when 'E'
                25
              when 'a'..'z'
                height_ch.ord - 'a'.ord
              else
                raise "bad map character"
              end
    @neighbour_costs = Hash(MapPoint, Int64).new
    @neighbour_checker = nil
    @distance_value = Int64::MAX
  end

  def set_checker(checker : Proc(MapPoint, MapPoint, Bool))
    @neighbour_checker = checker
  end
  
  def reset
    @distance_value = Int64::MAX
    @neighbour_costs.clear
  end

  def set_start
    @distance_value = 0_i64
  end

  def add_neighbour(other : MapPoint)
    if @neighbour_checker.try { |c| c.call(self, other) }
      @neighbour_costs[other] = 1
    end
  end

  def inspect(io : IO)
    io.print "height #{@height} dist #{@distance_value} neighbours(#{@neighbour_costs.values.join(",")})"
  end
end

# Dijkstra’s shortest path algorithm https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
# we pass a block which is in-turn passed to MapPoint, to decide whether a move is possible; this is used once
# in the forward direction (for part 1) and once in the reverse direction (for part 2, to get all distances so
# we cna later extract only the height zero ones)
def dijkstra(start_point : MapPoint, end_point : MapPoint?, grid : Array(Array(MapPoint)),
             &checker : Proc(MapPoint, MapPoint, Bool))
  # add neighbour cost for each MapPoint
  grid.each_with_index do |row, y|
    row.each_with_index do |point, x|
      point.reset
      point.set_checker(checker)
      point.add_neighbour(grid[y][x-1]) if x > 0
      point.add_neighbour(grid[y][x+1]) if x < grid[y].size - 1
      point.add_neighbour(grid[y-1][x]) if y > 0
      point.add_neighbour(grid[y+1][x]) if y < grid.size - 1
    end
  end
  spt = Set(MapPoint).new
  remaining = grid.reduce(Set(MapPoint).new) { |s, row| s.concat(row) }
  start_point.set_start
  while remaining.size > 0
    u = remaining.min_by { |v| v.distance_value }
    u.neighbour_costs.each do |v, n_cost|
      begin
        v.distance_value = u.distance_value + n_cost if u.distance_value + n_cost < v.distance_value
      rescue e : OverflowError
        return Int64::MAX unless end_point.nil? # if endpoint exists then impossible (isolated?), otherwise ignore if no endpoint
      end
    end
    spt << u
    remaining.delete(u)
    break if u == end_point # quit if we're done with the declared end point; always false if there's no end_point
  end
end

start_point = end_point = nil
grid = Array(Array(MapPoint)).new
STDIN.each_line(chomp: true) do |line|
  row = Array(MapPoint).new
  line.each_char do |ch|
    row << MapPoint.new(ch)
    start_point = row.last if ch == 'S'
    end_point =  row.last if ch == 'E'
  end
  grid << row
end

puts "Part 1:"
# the checker is the rules as given, moving from the start towards the end point
dijkstra(start_point.not_nil!, end_point.not_nil!, grid) { |this, other| other.height - this.height <= 1 }
puts end_point.try(&.distance_value)

puts "Part 2:"
# the checker is the reverse rule, moving away from the end point (i.e. we pass the end point as the start point
# and declare no end point)
dijkstra(end_point.not_nil!, nil, grid) { |this, other| other.height - this.height >= -1 }
# find all the low points then extract the minimum distance from the end point
puts grid.reduce(Array(MapPoint).new) { |acc, row| acc.concat(row.select { |point| point.height == 0 }) }.map(&.distance_value).min
