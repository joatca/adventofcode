require "set"

class Tile
  property :height
  getter :can_reach
  
  def initialize(ch : Char)
    @height = ch.to_i
    @can_reach = Set(Tile).new
  end

  def add_reach(other : Tile)
    @can_reach << other if other.height - @height == 1
  end

  def set_next_reachable
    # find everything reachable by all the tiles this one can reach
    next_reachable = @can_reach.map { |reachable_tile| reachable_tile.can_reach.to_a }.flatten
    p next_reachable unless next_reachable.empty?
    # replace what this tile can reach
    @can_reach.clear.concat(next_reachable)
  end

  def to_s(io : IO)
    io << (@can_reach.empty? ? "#{@height}" : "#{height}->#{@can_reach.join(',')}")
  end
end

map = STDIN.each_line(chomp: true).map { |line|
  line.chars.map { |ch| Tile.new(ch) }.to_a
}.to_a

by_height = Hash(Int32, Set(Tile)).new { |h, k| h[k] = Set(Tile).new }

map.each_with_index do |row, y|
  row.each_with_index do |tile, x|
    by_height[tile.height] << tile
    tile.add_reach(map[y][x+1]) if x < row.size - 1
    tile.add_reach(map[y][x-1]) if x > 0
    tile.add_reach(map[y+1][x]) if y < map.size - 1
    tile.add_reach(map[y-1][x]) if y > 0
  end
end

map.each do |row|
  puts row.map { |tile| tile.to_s }.join(' ')
end
puts ""

8.times do
  by_height[0].each do |trailhead|
    trailhead.set_next_reachable
  end
  map.each do |row|
    puts row.map { |tile| tile.to_s }.join(' ')
  end
  puts ""
end

puts by_height[0].map { |tile| tile.can_reach.size }.sum
