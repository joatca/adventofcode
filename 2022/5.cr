stacks_part1 = Array(Array(String)).new

STDIN.each_line(chomp: true) do |line|
  break if line =~ /^(\s\d+\s*)*$/ # label line ends the stack definition
  row_results = line.scan(/(\[(.)\]|\s\s\s)\s?/).map { |match| match[2]? || " " }
  # expand the array of stacks if this row has more items
  while stacks_part1.size < row_results.size
    stacks_part1 << Array(String).new
  end
  # this is slow, but simpler than pushing then reversing later
  row_results.each_with_index do |crate, i|
    stacks_part1[i].insert(0, crate) unless crate == " "
  end
end

stacks_part2 = stacks_part1.clone

record Instruction, count : Int32, from : Int32, to : Int32

instructions = Array(Instruction).new
STDIN.each_line(chomp: true) do |line|
  if line =~ /^move (\d+) from (\d+) to (\d+)/
    instructions.push(Instruction.new($1.to_i, $2.to_i, $3.to_i))
  end
end

instructions.each do |i|
  # pop and push one at a time
  i.count.times do
    stacks_part1[i.to-1].push(stacks_part1[i.from-1].pop)
  end
  # pop the entire count first, then push in the same order
  stacks_part2[i.from-1].pop(i.count).each do |popped|
    stacks_part2[i.to-1].push(popped)
  end
end

puts "Part 1:"
puts stacks_part1.map(&.last).join

puts "Part 2:"
puts stacks_part2.map(&.last).join
