MATCHING_BRACES = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}
OPENING_BRACES = MATCHING_BRACES.values.to_set

SCORES = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
}

def find_illegal(s : String)
  stack = Array(Char).new
  s.each_char do |ch|
    if OPENING_BRACES.includes?(ch)
      stack << ch
    elsif MATCHING_BRACES.has_key?(ch)
      return SCORES[ch] unless stack.pop == MATCHING_BRACES[ch]
    else
      raise "invalid character"
    end
  end
  return 0
end

puts STDIN.each_line(chomp: true).map { |navsys|find_illegal(navsys) }.sum
