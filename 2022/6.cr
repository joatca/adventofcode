# this lets us detect markers without slurping the entire input, we only need a buffer/hash of the length of the
# marker + 1
class ElvenMarkerDetector(T)
  def initialize(@marker_length : Int32)
    @buffer = Deque(T).new(initial_capacity: @marker_length + 1)
    @counts = Hash(T, Int32).new(default_value: 0)
  end

  def add(v : T)
    @counts[v] += 1
    @buffer.push(v)
    if @buffer.size > @marker_length
      t = @buffer.shift
      @counts[t] -= 1
      @counts.delete(t) if @counts[t] == 0
    end
    marker?
  end

  def marker?
    @counts.size >= @marker_length
  end
end

packet_detector = ElvenMarkerDetector(Char).new(4)
message_detector = ElvenMarkerDetector(Char).new(14)

found_packet = false

STDIN.each_char.each_with_index(offset: 1) do |ch, i|
  if !found_packet && packet_detector.add(ch)
    puts "Part 1:"
    puts i
    found_packet = true
  end
  if message_detector.add(ch)
    puts "Part 2:"
    puts i
    break
  end
end
