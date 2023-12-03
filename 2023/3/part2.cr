class Label

  property :value, :length
  
  def initialize
    @value, @length = 0, 0
  end

  def add_digit(i : Int32)
    @value, @length = @value * 10 + i, @length + 1
    #puts " label is now #{value}"
  end
end

class Sym
  def initialize(@ch : Char)
    @labels = [] of Label
  end

  def add_label(l : Label)
    @labels << l
  end
  
  def ratio
    return 0 unless @ch == '*'
    return 0 unless @labels.size == 2
    @labels.map { |l| l.value }.product
  end
end

labels = Hash(Int32, Hash(Int32, Label)).new { |row, y|
  row[y] = Hash(Int32, Label).new { |col, x| col[x] = Label.new }
}

symbols = Hash(Int32, Hash(Int32, Sym)).new { |row, y| row[y] = Hash(Int32, Sym).new }

current_label = nil

ARGF.each_line(chomp: true).with_index do |line, y|
  line.each_char.with_index do |symbol, x|
    case symbol
    when '.'
      current_label = nil
      next
    when .number?
      if current_label.nil?
        current_label = labels[y][x]
        #puts "new label at (#{x},#{y})"
      end
      current_label.add_digit(symbol.to_i)
    else # assume it's a symbol
      symbols[y][x] = Sym.new(symbol)
      current_label = nil
    end
  end
  current_label = nil
end

total = 0
labels.each do |y, row|
  row.each do |x, label|
    ((y-1)..(y+1)).each do |y1|
      ((x-1)..(x+label.length)).each do |x1|
        if symbols[y1].has_key?(x1)
          symbols[y1][x1].add_label(label)
        end
      end
    end
  end
end

puts symbols.values.map { |row| row.values.map(&.ratio).sum }.sum

