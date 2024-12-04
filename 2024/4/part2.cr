dirs = [ {x: 1, y: 1}, {x: -1, y: 1}, {x: -1, y: -1}, {x: 1, y: -1} ]
data = STDIN.each_line(chomp: true).map { |line| line.chars }.to_a
width = data[0].size
raise "uneven input" unless data.all? { |d| d.size == width }
padding = 1

grid = Array.new(padding) { |i| [' '] * (width + padding * 2) } +
       data.map { |row| ([' '] * padding) + row + ([' '] * padding) } +
       Array.new(padding) { |i| [' '] * (width + padding * 2) }
width += padding * 2
count = 0
(1...grid.size).each do |y|
  (1...width).each do |x|
    next unless grid[y][x] == 'A' # X-MAS must have an A at the centre
    em_pos = dirs.size.times.select { |i| grid[y + dirs[i][:y]][x + dirs[i][:x]] == 'M' }.to_a
    next unless em_pos.size == 2 # must have exactly 2 M's
    next if (em_pos[1] - em_pos[0]) % 2 == 0 # cannot have M's opposite each other
    # must have A's opposite the M's
    next unless em_pos.map { |p| (p+2)%4 }.all? { |s_pos|
      grid[y + dirs[s_pos][:y]][x + dirs[s_pos][:x]] == 'S'
    }
    count += 1
  end
end
puts count
