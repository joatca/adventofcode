word_to_digit = "one two three four five six seven eight nine".split.each_with_index(offset: 1).to_h
revword_to_digit = word_to_digit.map { |s, i| {s.reverse, i} }.to_h
word_matcher = /(#{word_to_digit.keys.join("|")})/
revword_matcher = /(#{revword_to_digit.keys.join("|")})/
puts ARGF.each_line.map { |line|
  first_digit = line.sub(word_matcher) { |s| word_to_digit[s] }.chars.find!(&.number?).to_i
  last_digit = line.reverse.sub(revword_matcher) { |s| revword_to_digit[s] }.chars.find!(&.number?).to_i
  first_digit * 10 + last_digit
}.sum
