N = 0
S = 1
E = 2
W = 3

class Tree
  DIR_SIZE = 4
  getter height
  
  def initialize(@height : Int32)
    @visible = Array(Bool).new(size: DIR_SIZE, value: false)
  end

  def check(dir : Int32, tallest : Int32)
    if @height > tallest
      @visible[dir] = true
      return @height
    else
      @visible[dir] = false
      return tallest
    end
  end

  def visible?
    @visible.any?
  end
end

trees = STDIN.each_line(chomp: true).map { |line|
  line.each_char.map { |ch| Tree.new(ch.ord - '0'.ord) }.to_a
}.to_a

raise "empty grid" if trees.size == 0
raise "ragged grid" if trees[1..].any? { |row| row.size != trees[0].size }

# process part 1 east/west first
trees.each do |row|
  tallest_eastward = tallest_westward = -1
  row.size.times do |col|
    tallest_eastward = row[col].check(E, tallest_eastward)
    tallest_westward = row[row.size - 1 - col].check(W, tallest_westward)
  end
end

# now do part 1 north/south
trees[0].size.times do |col|
  tallest_southward = tallest_northward = -1
  trees.size.times do |row|
    tallest_southward = trees[row][col].check(N, tallest_southward)
    tallest_northward = trees[trees.size - 1 - row][col].check(S, tallest_northward)
  end
end

puts "Part 1:"
puts trees.map { |row| row.count { |tree| tree.visible? } }.sum

# just brute force for Part 2
max_score = 0
best_x = best_y = 0 # this initial value doesn't matter
max_x, max_y = trees[0].size - 1, trees.size - 1
# we don't need to check the edge trees - at least one direction will be zero so the product score will be zero
(1..(trees.size-2)).each do |y|
  (1..(trees[y].size-2)).each do |x|
    height = trees[y][x].height
    most_x = (x+1).upto(max_x).find(max_x) { |xx| trees[y][xx].height >= height }
    least_x = (x-1).downto(0).find(0) { |xx| trees[y][xx].height >= height }
    most_y = (y+1).upto(max_y).find(max_y) { |yy| trees[yy][x].height >= height }
    least_y = (y-1).downto(0).find(0) { |yy| trees[yy][x].height >= height }
    score = (most_x-x) * (x-least_x) * (most_y-y) * (y-least_y)
    if score > max_score
      max_score, best_x, best_y = score, x, y
    end
  end
end

puts "Part 2:"
puts "Max score #{max_score} at #{best_x},#{best_y}"
