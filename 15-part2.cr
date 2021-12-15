class Vertex
  property :distance_value, :neighbour_distances, :risk
  def initialize(@risk : Int64) # the "risk" becomes the distance *to* this vertex from all it's neighbours
    @distance_value = Int64::MAX
    @neighbour_distances = Hash(Vertex, Int64).new
  end
end

initial_grid_i64 = Array(Array(Int64)).new
x_size = 0
STDIN.each_line(chomp: true) do |line|
  initial_grid_i64 << line.each_char.map { |ch| ch.to_i64 }.to_a
  x_size = { x_size, initial_grid_i64.last.size }.max
end
y_size = initial_grid_i64.size

# we need to pre-allocate the whole array to make population easier
grid_i64 = Array(Array(Int64)).new(y_size * 5) { |i| Array(Int64).new(x_size * 5, 0_i64) }

5.times.each do |yc|
  5.times.each do |xc|
    y_size.times.each do |y|
      x_size.times.each do |x|
        #puts "xc #{xc} yc #{yc} x #{x} y #{y} fx #{xc * (x_size + 1) + x} fy #{yc * 5 + y}"
        grid_i64[yc * y_size + y][xc * x_size + x] = (initial_grid_i64[y][x] - 1 + yc + xc) % 9 + 1
      end
    end                                             
  end
end

x_size *= 5
y_size *= 5

grid = grid_i64.map { |row_i| row_i.map { |i| Vertex.new(i) } }

grid[0][0].distance_value = 0_i64

# using sets to track completed and remaining vertices is highly sub-optimal for this problem size, but it still
# completes in ~3 minutes, so meh
spt = Set(Vertex).new
remaining = Set(Vertex).new

# add neighbour distances for each Vertex, to form a network that Dijkstra below can handle
grid.each_with_index do |row, y|
  row.each_with_index do |vertex, x|
    vertex.neighbour_distances[grid[y][x-1]] = grid[y][x-1].risk if x > 0
    vertex.neighbour_distances[grid[y][x+1]] = grid[y][x+1].risk if x < x_size -1
    vertex.neighbour_distances[grid[y-1][x]] = grid[y-1][x].risk if y > 0
    vertex.neighbour_distances[grid[y+1][x]] = grid[y+1][x].risk if y < y_size -1
    remaining << vertex
  end
end

# Dijkstra’s shortest path algorithm https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/
while remaining.size > 0
  # find the vertex in remaining with the shortest distance value
  u = remaining.min_by { |v| v.distance_value }
  # update the distance values
  u.neighbour_distances.each do |v, n_dist|
    v.distance_value = u.distance_value + n_dist if u.distance_value + n_dist < v.distance_value
  end
  # note it as visited
  spt << u
  remaining.delete(u)
end

puts "Distance to far corner: #{grid[y_size-1][x_size-1].distance_value}"
