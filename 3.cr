# part 1

setcounts = [] of UInt32 # how many of each bit position are set to 1

# suck everything into memory
report = STDIN.each_line.map { |line| { bits: line.chomp.size, num: line.to_u32(base: 2) } }.to_a

# compute how many of each bit position are set to 1
report.each do |val|
  # expand the array if necessary
  while setcounts.size < val[:bits]
    setcounts << 0
  end
  setcounts.size.times do |bitnum|
    setcounts[bitnum] += val[:num].bit(bitnum)
  end
end

# array holding, for each bit position, which value is most common, 0 or 1
most_common_bits = setcounts.map { |count| count >= (report.size // 2) ? 1 : 0 }

# convert that to an actual integer
gamma = 0
most_common_bits.each_with_index do |bit, i|
  gamma += bit << i
end

# epsilon is the just the XOR of gamma, using a mask the same size as the max bits
epsilon = gamma ^ ((1_u32 << most_common_bits.size) - 1)

puts "gamma: #{gamma} epsilon: #{epsilon} power consumption: #{gamma * epsilon}"

# part 2

# for the first pass we can gain a little efficiency by using partition instead of select/reject
bitnum = most_common_bits.size - 1
oxygen, scrubber = report.map { |val| val[:num] }.partition { |num| num.bit(bitnum) == most_common_bits[bitnum] }

bitnum -= 1 # we already did the first bit position
while oxygen.size > 1 && bitnum >= 0
  one_count = oxygen.count { |num| num.bit(bitnum) == 1 } # how many 1s?
  most_common = one_count * 2 >= oxygen.size ? 1 : 0 # if number of 1s is half or more, most common is 1 else 0
  oxygen.select! { |num| num.bit(bitnum) == most_common } # select only numbers with that bit in the current position
  bitnum -= 1
end

bitnum = most_common_bits.size - 2 # we already did the first bit position
while scrubber.size > 1 && bitnum >= 0
  one_count = scrubber.count { |num| num.bit(bitnum) == 1 } # how many 1s?
  most_common = one_count * 2 >= scrubber.size ? 1 : 0 # if number of 1s is half or more, most common is 1 else 0
  scrubber.reject! { |num| num.bit(bitnum) == most_common } # reject numbers with that bit in the current position
  bitnum -= 1
end

puts "Oxygen generator rating: #{oxygen.first} CO2 scrubber rating: #{scrubber.first} life support rating: #{scrubber.first * oxygen.first}"

