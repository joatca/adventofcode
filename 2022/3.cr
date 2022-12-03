input = STDIN.each_line(chomp: true).to_a

PRIORITIES = ('a'..'z').each.chain(('A'..'Z').each).zip(1..).to_h

puts "Part 1:"
puts input.reduce(0) { |accum, line|
  compartment1 = line[0...(line.size//2)].each_char.to_set
  errors = line[(line.size//2)..].each_char.select { |ch| compartment1.includes?(ch) }.to_set
  accum + errors.map { |err| PRIORITIES[err] }.sum # this works if there are multiple errors
}

puts "Part 2:"
puts input.each_slice(3).reduce(0) { |accum, slice|
  # #first doesn't work if there are multiple common badges
  accum + PRIORITIES[slice.map { |line| line.each_char.to_set }.reduce { |accs, s| accs & s }.first]
}
