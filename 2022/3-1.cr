PRIORITIES = ('a'..'z').each.chain(('A'..'Z').each).zip(1..).to_h

puts STDIN.each_line(chomp: true).reduce(0) { |accum, line|
  compartment1 = line[0...(line.size//2)].each_char.to_set
  errors = line[(line.size//2)...].each_char.select { |ch| compartment1.includes?(ch) }.to_set
  accum + errors.map { |err| PRIORITIES[err] }.sum # this works if there are multiple errors
}
