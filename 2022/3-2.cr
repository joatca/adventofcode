PRIORITIES = ('a'..'z').each.chain(('A'..'Z').each).zip(1..).to_h

puts STDIN.each_line(chomp: true).each_slice(3).reduce(0) { |accum, slice|
  # #first doesn't work if there are multiple common badges
  accum + PRIORITIES[slice.map { |line| line.each_char.to_set }.reduce { |accs, s| accs & s }.first]
}
