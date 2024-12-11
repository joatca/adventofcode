OPERATORS = {
  "+" => ->(a : Int64, b : Int64) { a + b },
  "*" => ->(a : Int64, b : Int64) { a * b },
  "||" => ->(a : Int64, b : Int64) { Int64.new(a.to_s + b.to_s) },
}
OPNAMES = OPERATORS.keys
OPPOW = OPERATORS.size

equations = Hash(Int64, Array(Int64)).new
STDIN.each_line(chomp: true) do |line|
  if line =~ /^(\d+): ([\d ]+)$/
    equations[Int64.new($1)] = $2.split.map { |s| Int64.new(s) }
  end
end

total_valid = 0_i64
equations.each do |target, numbers|
  op_count = numbers.size - 1
  combinations = OPPOW ** op_count
  combinations.times do |combination|
    op_nums = combination.digits(OPPOW)
    op_nums += [0] * (op_count - op_nums.size) # pad with zeros
    val = op_nums.size.times.reduce(numbers[0]) { |v, i| v = OPERATORS[OPNAMES[op_nums[i]]].call(v, numbers[i+1]) }
    if val == target
      total_valid += val
      break
    end
  end
end
puts total_valid
