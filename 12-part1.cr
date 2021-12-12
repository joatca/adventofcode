# to represent one cave on the path
class Cave
  @is_small : Bool
  @is_start : Bool
  @is_end : Bool

  getter :name, :is_small, :is_start, :is_end, :visited, :connections

  def initialize(@name : String)
    @is_start = @name == "start"
    @is_end = @name == "end"
    @is_small = @name == @name.downcase
    @visited = false
    @connections = [] of Cave
  end

  def visit
    @visited = true if @is_small
  end

  def unvisit
    @visited = false
  end

  def to_s(io : IO)
    io << @name << " -> " << @connections.map { |c| c.name }.join(io, ',')
  end
end

class CavePath < Array(Cave)
  def to_s(io : IO)
    self.map { |c| c.name }.join(io, '-')
  end
end

class CaveNetwork

  def initialize
    @caves = Hash(String, Cave).new { |h, name| h[name] = Cave.new(name) }
    @path = CavePath.new
  end

  def connect(a : String, b : String)
    @caves[a].connections << @caves[b]
    @caves[b].connections << @caves[a]
  end

  def each_path(cave : Cave?, &block : Array(Cave) -> _)
    cave ||= @caves["start"]
    #puts "At cave #{cave.name} path is #{@path.map { |c| c.name }.inspect}"
    return if cave.visited
    cave.visit
    @path << cave
    if cave.is_end
      yield @path
    else
      cave.connections.each do |other|
        each_path(other, &block)
      end
    end
    cave.unvisit
    @path.pop
  end
  
  def to_s(io : IO)
    @caves.each_value do |cave|
      io << cave << "\n"
    end
  end

end

cavenet = CaveNetwork.new

STDIN.each_line(chomp: true) do |line|
  if line =~ /^([a-z]+)-([a-z]+)$/i
    cavenet.connect($1, $2)
  end
end

path_count = 0
cavenet.each_path(nil) do |path|
  puts path
  path_count += 1
end

puts "Total paths: #{path_count}"
