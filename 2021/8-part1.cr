correct = [
  "abcefg",
  "cf",
  "acdeg",
  "acdfg",
  "bcdf",
  "abdfg",
  "abdefg",
  "acf",
  "abcdefg",
  "abcdfg",
]

correct_segment_counts = correct.map { |segment| segment.size } # how many segments are active for each digit?
segment_count_tally = correct_segment_counts.tally # how many are there of each segment count?
unique_segment_counts = segment_count_tally.select { |count, tally| tally == 1 }.map { |count, tally| count } # which segment counts are unique?
digits_with_unique_segment_count = correct_segment_counts.each_with_index.select { |count, digit|
  unique_segment_counts.includes?(count)
}.map { |count, digit| digit }.to_a

unique_digit_count = 0
STDIN.each_line(chomp: true) do |line|
  unique_digits, output_displays = line.split(" | ")
  output_values = output_displays.split
  unique_digit_count += output_values.count { |value| unique_segment_counts.includes?(value.size) }
end

p unique_digit_count
