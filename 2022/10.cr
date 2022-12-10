class ElvenCPU
  property cycle : Int32
  property x : Int32

  def initialize
    @cycle, @x = 1, 1
  end

  # we start at cycle 1 so we yield *before* processing; for noop this yields once then increments the cycle;
  # for addx this yields twice, once before incrementing the cycle and once after (and before processing the
  # add, which will be visible next call)
  def execute(instruction : String)
    case instruction
    when /^noop$/
      yield @cycle, @x
      @cycle += 1
    when /^addx ([-+]?\d+)$/
      yield @cycle, @x
      @cycle += 1
      yield @cycle, @x
      @cycle += 1
      @x += $1.to_i
    else
      raise "bad instruction \"line\""
    end
  end

  def signal_strength
    @cycle * @x
  end
end

cpu = ElvenCPU.new

note_cycles = Set.new([20, 60, 100, 140, 180, 220])
ss_total = 0

CRT_WIDTH = 40
CRT_HEIGHT = 6

crt = Array(Array(Char)).new(CRT_HEIGHT) { |i| ['.'] * CRT_WIDTH }

STDIN.each_line(chomp: true) do |line|
  cpu.execute(line) do |cycle, x|
    if note_cycles.includes?(cycle)
      ss_total += cpu.signal_strength
    end
    row = (cycle-1) // CRT_WIDTH
    col = (cycle-1) % CRT_WIDTH
    crt[row][col] = '#' if ((col-1)..(col+1)).includes?(x)
  end
end

puts "Part 1:"
puts ss_total

puts "Part 2:"
puts crt.map { |row| row.join }.join("\n")
