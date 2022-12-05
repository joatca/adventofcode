stacks1 = [] of Array(String)

STDIN.each_line(chomp: true) do |line|
  break if line =~ /^(\s\d+\s*)*$/ # label line ends the stack definition
  crates = line.scan(/(\[(.)\]|\s\s\s)\s?/).map { |match| match[2]? || " " }
  while stacks1.size < crates.size # allows ragged input lines
    stacks1 << Array(String).new
  end
  # this is slow, but simpler than pushing then reversing later
  crates.each_with_index do |crate, i|
    stacks1[i].insert(0, crate) unless crate == " "
  end
end
stacks2 = stacks1.clone # need two copies of the stacks

record Instruction, count : Int32, from : Int32, to : Int32
instructions = [] of Instruction
STDIN.each_line(chomp: true) do |line|
  if line =~ /^move (\d+) from (\d+) to (\d+)/
    instructions.push(Instruction.new($1.to_i, $2.to_i, $3.to_i))
  end
end

instructions.each do |i|
  # pop and push one at a time
  i.count.times do
    stacks1[i.to-1].push(stacks1[i.from-1].pop)
  end
  # pop the entire count first, then push in the same order
  stacks2[i.from-1].pop(i.count).each do |popped|
    stacks2[i.to-1].push(popped)
  end
end

puts "Part 1:"
puts stacks1.map(&.last).join
puts "Part 2:"
puts stacks2.map(&.last).join
