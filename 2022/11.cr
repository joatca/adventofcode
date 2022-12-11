class Monkey
  @operation : Proc(Int64, Int64)
  @divisible_test : Int64
  @items : Array(Int64)
  @truethrow: Int32
  @falsethrow : Int32
  @modulus : Int64?

  getter divisible_test, inspected
  setter modulus
  
  # initialize from the raw string values passed from the parse
  def initialize(items : String, operation : String,
                 divisible_test : String, truethrow : String, falsethrow : String,
                 @worry_divider : Int64)
    @items = items.split(/,\s*/).map(&.to_i64)
    @operation = case operation
                 when /^old \+ (\d+)$/
                   v = $1.to_i64
                   ->(x : Int64) { x + v }
                 when /^old \* (\d+)$/
                   v = $1.to_i64
                   ->(x : Int64) { x * v }
                 when /^old \* old$/
                   ->(x : Int64) { x * x }
                 else
                   # null operation for type safety
                   ->(x : Int64) { x }
                 end
    @divisible_test, @truethrow, @falsethrow = divisible_test.to_i64, truethrow.to_i, falsethrow.to_i
    @modulus = nil
    @inspected = 0_i64
  end

  # inspect each item and yield each item to be thrown and the target
  def inspect
    @items.each do |worry|
      worry = @operation.call(worry) // @worry_divider
      @modulus.try { |m| worry %= m }
      yield(worry, worry % @divisible_test == 0 ? @truethrow : @falsethrow)
    end
    @inspected += @items.size
    @items.clear
  end

  def catch(item : Int64)
    @items.push(item)
  end

  def to_s(io : IO)
    @items.join(io, separator: ", ")
  end
    
end

input = STDIN.gets_to_end
monkeysp1 = Hash(Int32, Monkey).new
monkeysp2 = Hash(Int32, Monkey).new

modulus = 1
input.scan(/Monkey (\d+):\n\s*Starting items: ([\d, ]+)\n\s*Operation: new = ([^\n]*)\n\s*Test: divisible by (\d+)\n\s*If true: throw to monkey (\d+)\n\s*If false: throw to monkey (\d+)\n/m) do |mm| # monkeymatch
  monkeysp1[mm[1].to_i] = Monkey.new(mm[2], mm[3], mm[4], mm[5], mm[6], 3)
  monkeysp2[mm[1].to_i] = Monkey.new(mm[2], mm[3], mm[4], mm[5], mm[6], 1)
  modulus *= monkeysp2[mm[1].to_i].divisible_test
end
monkeysp2.values.each do |monkey|
  monkey.modulus = modulus
end

monkey_order = monkeysp1.keys.sort # this works for both Monkey arrays

20.times do |round|
  monkey_order.each do |i|
    monkeysp1[i].inspect do |worry, target|
      monkeysp1[target].catch(worry)
    end
  end
end

puts "Part 1:"
puts monkeysp1.values.map(&.inspected).sort.reverse.first(2).product

10000.times do |round|
  monkey_order.each do |i|
    monkeysp2[i].inspect do |worry, target|
      monkeysp2[target].catch(worry)
    end
  end
end

puts "Part 2:"
puts monkeysp2.values.map(&.inspected).sort.reverse.first(2).product
