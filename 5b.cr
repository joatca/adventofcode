grid = Hash(Tuple(Int32, Int32), Int32).new(default_value: 0)

STDIN.each_line(chomp: true) do |line|
  if line =~ /^(\d+),(\d+)\s*->\s*(\d+),(\d+)$/
    x1, y1, x2, y2 = $1.to_i, $2.to_i, $3.to_i, $4.to_i
    xinc, yinc, xmag, ymag = (x2 - x1).sign, (y2 - y1).sign, (x2 - x1).abs, (y2 - y1).abs
    if xinc == 0 || yinc == 0 || xmag == ymag # ensure we only handle horizontals, verticals or diagonals
      pixels = { xmag, ymag }.max + 1 # how many pixels we draw to complete the line
      pixels.times do |pixel|
        grid[{x1 + pixel * xinc, y1 + pixel * yinc}] += 1
      end
    end
  end
end

puts "Squares with 2 or more lines: #{grid.each_value.count { |val| val >= 2 }}"
