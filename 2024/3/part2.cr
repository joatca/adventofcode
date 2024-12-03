sum, enabled = 0, true
STDIN.each_line do |line|
  line.scan(/do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)/).each do |match|
    case match[0]
    when "do()"
      enabled = true
    when "don't()"
      enabled = false
    else
      sum += match[1].to_i * match[2].to_i if enabled
    end
  end
end
puts sum

