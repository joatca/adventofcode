require "set"

rules = Hash(Int32, Set(Int32)).new { |h, k| h[k] = Set(Int32).new }
updates = Array(Array(Int32)).new

STDIN.each_line(chomp: true) do |line|
  case line
  when /^\s*$/
    next
  when /^(\d+)\|(\d+)$/
    rules[$2.to_i] << $1.to_i
  when /^[\d,]+/
    updates << line.split(',').map { |s| s.to_i }
  end
end

middles = 0
updates.each do |update|
  if update.size.times.any? { |i|
       ((i+1)...update.size).any? { |j| rules[update[i]].includes?(update[j]) }
     }
    next
  end
  middles += update[update.size // 2]
end
puts middles
