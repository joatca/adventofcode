N = 0; S = 1; E = 2; W = 3

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

trees = STDIN.each_line(chomp: true).map { |line| line.each_char.map { |ch| Tree.new(ch.ord - '0'.ord) }.to_a }.to_a
raise "bad grid" if trees.size == 0 || trees[1..].any? { |row| row.size != trees[0].size }

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
