befores = Hash(Int32, Array(Int32)).new { |h, k| h[k] = Array(Int32).new }
updates = Array(Array(Int32)).new

STDIN.each_line(chomp: true) do |line|
  case line
  when /^\s*$/
    next
  when /^(\d+)\|(\d+)$/
    befores[$2.to_i] << $1.to_i
  when /^[\d,]+/
    updates << line.split(',').map { |s| s.to_i }
  end
end

correct_tot, incorrect_tot = 0, 0
updates.each do |update|
  correct = true
  update.size.times.each do |i|
    j = i + 1
    loop do
      # find the first incorrect item
      fi = (j...update.size).find { |k| befores[update[i]].includes?(update[k]) }
      if fi.nil?
        j += 1
        break if j >= update.size
      else
        correct = false
        # relocate the item
        item = update.delete_at(fi)
        update.insert(i, item)
      end
    end
  end
  if correct
    correct_tot += update[update.size // 2]
  else
    incorrect_tot += update[update.size // 2]
  end
end
puts "Correct #{correct_tot} incorrect #{incorrect_tot}"

