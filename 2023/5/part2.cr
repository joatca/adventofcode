struct Segment(T)
  property :range, :offset
  def initialize(@range : Range(T, T), @offset : T)
  end

  def combine(other : Segment)
    if other.range.begin < self.range.begin
      other.combine(self)
    else
      s1 = self.range.exclusive? ? Segment.new(self.range.first..(self.range.end-1), self.offset) : self
      s2 = other.range.exclusive? ? Segment.new(other.range.first..(other.range.end-1), other.offset) : other
      if (s1.range.begin == s2.range.begin && s2.range.end > s1.range.end) ||
         (s1.range.end == s2.range.end && s2.range.begin < s1.range.begin)
        # ensure s1 bigger than s2 if they start or end the same
        s1, s2 = s2, s1
      end
      if s2.range.begin > self.range.end # no overlap, return the originals
        return [ s1, s2 ]
      elsif s1.range == s2.range # exactly match
        return [ Segment.new((s1.range.begin)..(s1.range.end), s1.offset+s2.offset) ]
      elsif s1.range.begin == s2.range.begin # start is the same, s1 always bigger than s2
        return [ Segment.new((s1.range.begin)..(s2.range.end), s1.offset+s2.offset),
                 Segment.new((s2.range.end + 1)..(s1.range.end), s1.offset)]
      elsif s2.range.end == s1.range.end # end is the same, s1 always bigger than s2
        return [ Segment.new((s1.range.begin)..(s2.range.begin-1), s1.offset),
                 Segment.new((s2.range.begin)..(s2.range.end), s1.offset+s2.offset) ]
      elsif s2.range.end > s1.range.end # s2 hangs off the end of s1
        return [ Segment.new((s1.range.begin)..(s2.range.begin-1), s1.offset),
                 Segment.new((s2.range.begin)..(s1.range.end), s1.offset + s2.offset),
                 Segment.new((s1.range.end+1)..(s2.range.end), s2.offset) ]
      else # s2 is completely inside s1
        return [ Segment.new((s1.range.begin)..(s2.range.begin-1), s1.offset),
                 Segment.new((s2.range.begin)..(s2.range.end), s1.offset+s2.offset),
                 Segment.new((s2.range.end+1)..(s1.range.end), s1.offset) ]
      end
    end
  end

  def to_s(io : IO)
    io << self.range << " " << self.offset
  end
  def inspect(io : IO)
    to_s(io)
  end
end

maps = Hash(String,Array(Segment(Int64))).new { |h, k| h[k] = [] of Segment(Int64) }

cur_map = ""
seeds = [] of Segment(Int64)

ARGF.each_line(chomp: true) do |line|
  case line
  when /^$/ # ignore blank lines
    next
  when /^seeds:\s+(.+)$/
    seeds += $1.split.map(&.to_i64).each_slice(2).map { |pair| Segment.new(pair[0]...(pair[0]+pair[1]), 0) }.to_a
  when /^(\S+) map:$/
    cur_map = $1
  when /^(\d+)\s(\d+)\s(\d+)$/
    dest, src, count = $1.to_i64, $2.to_i64, $3.to_i64
    maps[cur_map] << Segment.new(src...(src+count), dest-src)
  else
    raise "invalid input line"
  end
end

sequence = ["seed", "soil", "fertilizer", "water", "light", "temperature", "humidity", "location"].each_cons_pair.map { |from, to|
  "#{from}-to-#{to}"
}.to_a

#p seeds, sequence, maps

segments = seeds.dup

puts "initial segments #{segments}"
sequence.each do |mapname|
  puts "sequence #{mapname}"
  next_segments = [] of Segment(Int64)
  segments.each do |segment|
    puts " doing segment #{segment} map #{mapname}"
    maps[mapname].each do |map_segment|
      puts "  trying map segment #{map_segment}"
      next_segments += segment.combine(map_segment)
      puts "  after map segment #{map_segment} next is #{next_segments}"
    end
  end
  puts "final next is #{next_segments}"
  segments = next_segments
end
puts "final segments is #{segments}"
  
# seeds.each_slice(2).map { |pair|
#   rng = (pair[0]...(pair[0]+pair[1]))
#   (pair[0]...(pair[0]+pair[1])).map { |seed|
#     sequence.each do |mapname|
#       seed = begin
#                range = maps[mapname].keys.find! { |r| r.includes?(seed) }
#                seed + maps[mapname][range]
#              rescue Enumerable::NotFoundError
#                seed
#              end
#     end
#     seed
#   }.min
# }.min
