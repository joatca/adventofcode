target = "XMAS".chars
target_len = target.size
directions = [ {x: 1, y: 0}, {x: -1, y: 0}, {x: 0, y: 1}, {x: 0, y: -1},
               {x: 1, y: 1}, {x: 1, y: -1}, {x: -1, y: 1}, {x: -1, y: -1} ]
data = STDIN.each_line(chomp: true).map { |line| line.chars }.to_a
width = data[0].size
raise "uneven input" unless data.all? { |d| d.size == width }
padding = target.size - 1
grid = Array.new(padding) { |i| [' '] * (width + padding * 2) } +
       data.map { |row| ([' '] * padding) + row + ([' '] * padding) } +
       Array.new(padding) { |i| [' '] * (width + padding * 2) }
width += padding * 2
count = 0
grid.size.times do |y|
  width.times do |x|
    count += directions.count { |dir|
      target_len.times.all? { |i|
        target[i] == grid[y + i*dir[:y]][x + i*dir[:x]]
      }
    }      
  end
end
puts count
