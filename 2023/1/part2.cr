words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
word_to_digit = words.each_with_index.map { |s, i|
  [s, i+1]
}.to_h
revword_to_digit = words.map(&.reverse).each_with_index.map { |s, i|
  [s, i+1]
}.to_h
word_matcher = /(#{word_to_digit.keys.join("|")})/
revword_matcher = /(#{revword_to_digit.keys.join("|")})/
puts ARGF.each_line.map { |line|
  first_digit = line.sub(word_matcher) { |s| word_to_digit[s] }.chars.find!(&.number?).to_i
  last_digit = line.reverse.sub(revword_matcher) { |s| revword_to_digit[s] }.chars.find!(&.number?).to_i
  first_digit * 10 + last_digit
}.sum
