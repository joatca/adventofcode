class Vertex
  property :distance_value, :neighbour_distances, :risk
  def initialize(@risk : Int64) # the "risk" becomes the distance *to* this vertex from all it's neighbours
    @distance_value = Int64::MAX
    @neighbour_distances = Hash(Vertex, Int64).new
  end
end

max_x = 0
grid = Array(Array(Vertex)).new
STDIN.each_line(chomp: true) do |line|
  grid << line.each_char.map { |ch| Vertex.new(ch.to_i64) }.to_a
  max_x = { max_x, grid.last.size - 1 }.max
end
max_y = grid.size - 1

grid[0][0].distance_value = 0_i64

spt = Set(Vertex).new
remaining = Set(Vertex).new

# add neighbour distances for each Vertex
grid.each_with_index do |row, y|
  row.each_with_index do |vertex, x|
    vertex.neighbour_distances[grid[y][x-1]] = grid[y][x-1].risk if x > 0
    vertex.neighbour_distances[grid[y][x+1]] = grid[y][x+1].risk if x < max_x
    vertex.neighbour_distances[grid[y-1][x]] = grid[y-1][x].risk if y > 0
    vertex.neighbour_distances[grid[y+1][x]] = grid[y+1][x].risk if y < max_y
    remaining << vertex
  end
end

# Dijkstra’s shortest path algorithm https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/

while remaining.size > 0
  # find the vertex in remaining with the shortest distance value
  u = remaining.min_by { |v| v.distance_value }
  u.neighbour_distances.each do |v, n_dist|
    v.distance_value = u.distance_value + n_dist if u.distance_value + n_dist < v.distance_value
  end
  spt << u
  remaining.delete(u)
end

puts "Distance to far corner: #{grid[max_y][max_x].distance_value}"
