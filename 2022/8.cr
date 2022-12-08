trees = STDIN.each_line(chomp: true).map { |line| line.each_char.map { |ch| ch.ord - '0'.ord }.to_a }.to_a

raise "empty grid" if trees.size == 0
raise "ragged grid" if trees[1..].any? { |row| row.size != trees[0].size }

visible, max_scenic = 0, 0
range_x, range_y = 0..(trees[0].size-1), 0..(trees.size-1)
# we don't need to check the edge trees - at least one direction will be zero so the product will be zero
(1..(range_y.end-1)).each do |y|
  (1..(range_x.end-1)).each do |x|
    height = trees[y][x]
    is_visible, scenic = false, 1
    [ {0,1}, {1,0}, {0,-1}, {-1,0} ].each do |mx, my|
      direction_visible, direction_scenic = true, 0
      ix, iy = x+mx, y+my
      while range_x.includes?(ix) && range_y.includes?(iy)
        direction_scenic += 1
        if trees[iy][ix] >= trees[y][x]
          direction_visible = false
          break
        end
        ix += mx; iy += my
      end
      scenic *= direction_scenic
      is_visible ||= direction_visible
    end
    visible += 1 if is_visible
    max_scenic = [max_scenic, scenic].max
  end
end

puts "Part 1:"
puts visible + trees[0].size * 2 + (trees.size - 2) * 2 # all trees at the edge are visible

puts "Part 2:"
puts max_scenic
