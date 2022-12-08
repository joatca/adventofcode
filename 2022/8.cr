trees = STDIN.each_line(chomp: true).map { |line| line.each_char.map { |ch| ch.ord - '0'.ord }.to_a }.to_a

raise "empty grid" if trees.size == 0
raise "ragged grid" if trees[1..].any? { |row| row.size != trees[0].size }

visible = 0
max_score = 0
best_x = best_y = 0 # this initial value doesn't matter
max_x, max_y = trees[0].size - 1, trees.size - 1
# we don't need to check the edge trees - at least one direction will be zero so the product score will be zero
(1..(trees.size-2)).each do |y|
  (1..(trees[y].size-2)).each do |x|
    height = trees[y][x]
    most_x = (x+1).upto(max_x).find(max_x) { |xx| trees[y][xx] >= height }
    least_x = (x-1).downto(0).find(0) { |xx| trees[y][xx] >= height }
    most_y = (y+1).upto(max_y).find(max_y) { |yy| trees[yy][x] >= height }
    least_y = (y-1).downto(0).find(0) { |yy| trees[yy][x] >= height }
    visible += 1 if
      (most_x == max_x && trees[y][most_x] < height) ||
      (least_x == 0 && trees[y][least_x] < height) ||
      (most_y == max_y && trees[most_y][x] < height) ||
      (least_y == 0 && trees[least_y][x] < height)
    score = (most_x-x) * (x-least_x) * (most_y-y) * (y-least_y)
    if score > max_score
      max_score, best_x, best_y = score, x, y
    end
  end
end

puts "Part 1:"
puts visible + trees[0].size * 2 + (trees.size - 2) * 2 # all trees at the edge are visible

puts "Part 2:"
puts "Max score #{max_score} at #{best_x},#{best_y}"
