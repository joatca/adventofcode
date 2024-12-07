befores = Hash(Int32, Array(Int32)).new { |h, k| h[k] = Array(Int32).new }
updates = Array(Array(Int32)).new

STDIN.each_line(chomp: true) do |line|
  case line
  when /^\s*$/ # ignore blanks
    next
  when /^(\d+)\|(\d+)$/ # before|after
    befores[$2.to_i] << $1.to_i
  when /^[\d,]+/ # n1,n2,n3,...
    updates << line.split(',').map { |s| s.to_i }
  end
end

total_correct, total_incorrect = 0, 0
updates.each do |update|
  correct = true
  update.size.times.each do |i| # i → index of current update page
    j = i + 1 # start the loop one along from the current i
    loop do
      # find the first incorrect item
      fi = (j...update.size).find { |k| befores[update[i]].includes?(update[k]) }
      if fi.nil? # if none then loop
        j += 1
        break if j >= update.size
      else # if found, mark update as incorrect then move the incorrect item just before i
        correct = false
        # relocate the item
        update.insert(i, update.delete_at(fi))
      end
    end
  end
  if correct
    total_correct += update[update.size // 2]
  else
    total_incorrect += update[update.size // 2]
  end
end
puts "Correct #{total_correct} incorrect #{total_incorrect}"

