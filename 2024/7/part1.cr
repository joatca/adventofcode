require "big"

OPERATORS = [ '+', '*' ]

equations = Hash(BigInt, Array(BigInt)).new
STDIN.each_line(chomp: true) do |line|
  if line =~ /^(\d+): ([\d ]+)$/
    equations[BigInt.new($1)] = $2.split.map { |s| BigInt.new(s) }
  end
end

def do_op(op : Char, a : BigInt, b : BigInt)
  case op
  when '+'
    a+b
  when '*'
    a*b
  else
    raise "unknown op #{op}"
  end
end

total_valid = 0
equations.each do |target, numbers|
  op_bit_count = numbers.size - 1
  op_combos = 2 << op_bit_count
  op_combos.times do |op_bits|
    val = op_bit_count.times.reduce(numbers[0]) { |v, i| v = do_op(OPERATORS[op_bits.bit(i)], v, numbers[i+1]) }
    if val == target
      total_valid += val
      break
    end
  end
end

p total_valid
