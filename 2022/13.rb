pairs = STDIN.each_line(sep="\n\n").map { |pair| pair.split("\n").map { |p| eval(p) } }

# this returns -1 if in order, +1 if not in order, 0 if indeterminate
def rightorder(a, b)
  return a <=> b if a.is_a?(Integer) && b.is_a?(Integer)
  a = [a] if a.is_a?(Integer) && b.is_a?(Array)
  b = [b] if a.is_a?(Array) && b.is_a?(Integer)
  a.zip(b).each do |ae, be|
    return 1 if be.nil? # right list ran out of items
    rightorder(ae, be).tap { |rv| return rv unless rv == 0 }
  end
  return -1 if a.length < b.length # left side ran out of items
  return 0
end

total = 0
pairs.each_with_index do |pair, i|
  total += i+1 if rightorder(pair.first, pair.last) == -1
end

puts "Part 1:"
puts total

sorted = ([ [[2]], [[6]] ] + pairs.flatten(1)).sort { |a, b| rightorder(a, b) }
i1 = sorted.find_index([[2]]) + 1
i2 = sorted.find_index([[6]]) + 1

puts "Part 2:"
puts i1 * i2
