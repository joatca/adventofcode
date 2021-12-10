CLOSING_TO_OPENING = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}
OPENING_TO_CLOSING = CLOSING_TO_OPENING.invert
OPENING_BRACES = OPENING_TO_CLOSING.keys.to_set

SCORES = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4,
}

def completion_score(s : String)
  stack = Array(Char).new
  s.each_char do |ch|
    if OPENING_BRACES.includes?(ch)
      stack << ch
    elsif CLOSING_TO_OPENING.has_key?(ch)
      return nil unless stack.pop == CLOSING_TO_OPENING[ch] # effectively discards the result
    else
      raise "invalid character"
    end
  end
  # now whatever is left on the stack can be scored
  return stack.reverse.reduce(0_i64) { |score, ch| score * 5 + SCORES[OPENING_TO_CLOSING[ch]] }
end

scores = STDIN.each_line(chomp: true).compact_map { |navsys| completion_score(navsys) }.to_a.sort!

raise "not odd number of scores" if scores.size % 2 == 0

puts scores[scores.size // 2]
