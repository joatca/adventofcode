grid = Hash(Tuple(Int32, Int32), Int32).new(default_value: 0)

STDIN.each_line(chomp: true) do |line|
  if line =~ /^(\d+),(\d+)\s*->\s*(\d+),(\d+)$/
    x1, y1, x2, y2 = $1.to_i, $2.to_i, $3.to_i, $4.to_i
    if (x1 == x2) || (y1 == y2) # handle horizontal/vertical lines
      x1, x2 = x2, x1 if x2 < x1 # flip x's to be increasing
      y1, y2 = y2, y1 if y2 < y1 # and y's
      # because we are guaranteed that either x's or y's will be constant we can pretend they form a rectangle
      (x1..x2).each do |x|
        (y1..y2).each do |y|
          grid[{x, y}] += 1
        end
      end
    elsif (x1-x2).abs == (y1-y2).abs # handle diagonal lines
      x1, y1, x2, y2 = x2, y2, x1, y1 if x2 < x1 # ensure x1 is less than x2
      ydiff = (y2 - y1) // (x2 - x1) # so this gives the y direction of the line as x increases
      y = y1
      (x1..x2).each do |x|
        grid[{x, y}] += 1
        y += ydiff
      end
    end
  end
end

puts "Squares with 2 or more lines: #{grid.each_value.count { |val| val >= 2 }}"
