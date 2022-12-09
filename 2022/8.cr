trees = STDIN.each_line(chomp: true).map { |line| line.each_char.map { |ch| ch.ord - '0'.ord }.to_a }.to_a

raise "bad grid" if trees.size == 0 || trees[1..].any? { |row| row.size != trees[0].size }

visible, max_scenic_score = 0, 0
range_x, range_y = 0..(trees[0].size-1), 0..(trees.size-1)
# we don't need to check the edge trees - at least one direction will be zero so the product will be zero
(1...range_y.end).each do |y|
  (1...range_x.end).each do |x|
    is_visible, scenic_score = false, 1
    [ {0,1}, {1,0}, {0,-1}, {-1,0} ].each do |mx, my|
      view_distance = 0
      ix, iy = x+mx, y+my
      while range_x.includes?(ix) && range_y.includes?(iy)
        view_distance += 1
        break if trees[iy][ix] >= trees[y][x] # view out or in is blocked
        ix += mx; iy += my
      end
      scenic_score *= view_distance
      is_visible ||= !range_x.includes?(ix) || !range_y.includes?(iy) # if it fell off the end, must be visible
    end
    visible += 1 if is_visible
    max_scenic_score = [max_scenic_score, scenic_score].max
  end
end

puts "Part 1:"
puts visible + trees[0].size * 2 + (trees.size - 2) * 2 # all trees at the edge are visible

puts "Part 2:"
puts max_scenic_score
