class Tree
  getter height, visible
  
  def initialize(@height : Int32)
    @visible = false
  end

  def check(tallest : Int32)
    if @height > tallest
      @visible = true
      return @height
    else
      return tallest
    end
  end
end

trees = STDIN.each_line(chomp: true).map { |line| line.each_char.map { |ch| Tree.new(ch.ord - '0'.ord) }.to_a }.to_a
raise "bad grid" if trees.size == 0 || trees[1..].any? { |row| row.size != trees[0].size }

# process part 1 east/west first
trees.each do |row|
  tallest_eastward = tallest_westward = -1
  row.size.times do |col|
    tallest_eastward = row[col].check(tallest_eastward)
    tallest_westward = row[row.size - 1 - col].check(tallest_westward)
  end
end

# now do part 1 north/south
trees[0].size.times do |col|
  tallest_southward = tallest_northward = -1
  trees.size.times do |row|
    tallest_southward = trees[row][col].check(tallest_southward)
    tallest_northward = trees[trees.size - 1 - row][col].check(tallest_northward)
  end
end

puts "Part 1:"
puts trees.map { |row| row.count { |tree| tree.visible } }.sum
