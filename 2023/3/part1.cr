class Label

  property :value, :length
  
  def initialize
    @value, @length = 0, 0
  end

  def add_digit(i : Int32)
    @value, @length = @value * 10 + i, @length + 1
  end
end

labels = Hash(Int32, Hash(Int32, Label)).new { |row, y|
  row[y] = Hash(Int32, Label).new { |col, x| col[x] = Label.new }
}

symbols = Hash(Int32, Hash(Int32, Char)).new { |row, y| row[y] = Hash(Int32, Char).new }

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
      end
      current_label.add_digit(symbol.to_i)
    else # assume it's a symbol
      symbols[y][x] = symbol
      current_label = nil
    end
  end
  current_label = nil
end

total = 0
labels.each do |y, row|
  row.each do |x, label|
    if ((y-1)..(y+1)).map { |y1|
      ((x-1)..(x+label.length)).count { |x1| symbols[y1].has_key?(x1) }
       }.sum > 0
      total += label.value
    else
    end
  end
end

puts total
