# to represent one cave on the path
class Cave
  @is_small : Bool
  @is_start : Bool
  @is_end : Bool

  getter :name, :is_small, :is_start, :is_end, :visits, :connections

  def initialize(@name : String)
    @is_start = @name == "start"
    @is_end = @name == "end"
    @is_small = @name == @name.downcase
    @visits = 0
    @connections = [] of Cave
  end

  def visit
    @visits += 1
  end

  def unvisit
    @visits -= 1
  end

  def can_be_visited(twice_available : Bool)
    if @is_small
      return @visits == 0 if @is_start # can never revisit the start
      return true if @is_end # can always visit the end
      return twice_available || @visits == 0 # can revisit a small cave if we haven't yet visited a small
    else
      return true # can always visit a large
    end
  end
  
  def to_s(io : IO)
    io << @name
  end
end

class CavePath < Array(Cave)
  def to_s(io : IO)
    self.map { |c| c.to_s }.join(io, '-')
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

  def each_path(cave : Cave?, twice_available : Bool = true, &block : Array(Cave) -> _)
    cave ||= @caves["start"]
    return unless cave.can_be_visited(twice_available)
    twice_available = false if cave.visits > 0 && cave.is_small
    cave.visit
    @path.push(cave)
    if cave.is_end
      yield @path
    else
      cave.connections.each do |other|
        each_path(other, twice_available, &block)
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
  puts "#{path}"
  path_count += 1
end

puts "Total paths: #{path_count}"
