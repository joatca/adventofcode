enum FoldType
  X
  Y
end

class Fold
  getter :position, :type
  def initialize(@position : Int32, @type : FoldType)
  end

  def self.from_s(pos_s : String, type_s : String)
    self.new(pos_s.to_i, type_s == "x" ? FoldType::X : FoldType::Y)
  end
end

class Point
  getter :x, :y
  def initialize(@x : Int32, @y : Int32)
  end
end

class Paper

  def initialize(io : IO)
    @points = Array(Point).new
    @folds = Array(Fold).new

    io.each_line(chomp: true) do |line|
      case line
      when /^(\d+),(\d+)$/
        @points.push(Point.new($1.to_i, $2.to_i))
      when /^fold along ([xy])=(\d+)$/
        @folds.push(Fold.from_s($2, $1))
      end
    end
    max_x, max_y = @points.map { |p| p.x }.max, @points.map { |p| p.y }.max
    x_prototype = Array(Bool).new(max_x+1, false)
    @grid = Array(Array(Bool)).new
    (0..max_y).each do
      @grid.push(x_prototype.clone)
    end
    @points.each do |p|
      @grid[p.y][p.x] = true
    end
  end

  def do_folds
    @folds.each do |f|
      fold(f)
    end
  end
  
  def fold(f : Fold)
    case f.type
    when FoldType::Y
      fold_y(f.position)
    when FoldType::X
      fold_x(f.position)
    end
  end

  def fold_y(pos : Int32)
    puts "Fold Y at #{pos}"
    top = @grid[0...pos]
    bottom = @grid[(pos+1)..-1]
    # if the bottom is same size or smaller than the top then we can overlay directly, if it's bigger then we
    # can first flip and prepend the excess to the top to make it so
    if bottom.size > top.size
      excess = bottom.size - top.size
      top = bottom[-excess..-1].reverse + top
      bottom = bottom[0...-excess]
    end
    # now bottom is no bigger than top
    difference = top.size - bottom.size
    bottom = bottom.reverse # flip it first
    bottom.each_with_index do |row, y|
      overlay_row(row, top[y + difference])
    end
    @grid = top
  end

  # very inefficient but this cheat gets us there quicker
  def fold_x(pos : Int32)
    @grid = @grid.transpose
    fold_y(pos)
    @grid = @grid.transpose
  end
  
  def overlay_row(from : Array(Bool), to : Array(Bool))
    to.size.times do |x|
      to[x] |= from[x]
    end
  end

  def print_grid(msg : String, grid : Array(Array(Bool)))
    puts msg
    grid.each do |row|
      row.each do |cell|
        STDOUT << (cell ? '#' : '.')
      end
      STDOUT << '\n'
    end
  end

  def dot_count
    @grid.map { |row| row.count(true) }.sum
  end

  def to_s(io : IO)
    @grid.each do |row|
      row.each do |cell|
        io << (cell ? '#' : '.')
      end
      io << '\n'
    end
  end
end

paper = Paper.new(STDIN)
paper.do_folds

puts "Paper:\n#{paper}\nDots: #{paper.dot_count}"

