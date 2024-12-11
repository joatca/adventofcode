require "set"

class Tile
  property :height
  getter :trails
  
  def initialize(ch : Char)
    @height, @trails = ch.to_i, Set(Array(Tile)).new
  end

  def is_trailhead?
    height == 0
  end

  def maybe_add_trail(other : Tile)
    @trails << [other] if other.height - @height == 1
  end

  def add_trail(others : Array(Tile))
    @trails << others
  end

  def extend_trails
    prev_trails = @trails.to_a
    @trails.clear
    prev_trails.to_a.each do |trail|
      trail.last.trails.each do |following_trail|
        add_trail(trail + following_trail)
      end
    end
  end
end

# read the map
map = STDIN.each_line(chomp: true).map { |line|
  line.chars.map { |ch|
    Tile.new(ch)
  }.to_a
}.to_a

# build initial single-hop trails for each tile and identify trailheads
trailheads = [] of Tile
map.each_with_index do |row, y|
  row.each_with_index do |tile, x|
    trailheads << tile if tile.is_trailhead?
    tile.maybe_add_trail(map[y][x+1]) if x < row.size - 1
    tile.maybe_add_trail(map[y][x-1]) if x > 0
    tile.maybe_add_trail(map[y+1][x]) if y < map.size - 1
    tile.maybe_add_trail(map[y-1][x]) if y > 0
  end
end

# extend each trailhead trail from each trails' next hops
8.times do
  trailheads.each do |trailhead|
    trailhead.extend_trails
  end
end

# and now the result is trivial
puts trailheads.reduce(0) { |rating, tile| rating + tile.trails.size }
