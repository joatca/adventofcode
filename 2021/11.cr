class Octopus
  property :energy, :flashed
  
  def initialize(@energy : Int32)
    @flashed = false
  end
end

class OctopusGrid # this is a pretty amazing class name

  def initialize
    @octopuses = Array(Array(Octopus)).new
    @size_x = @size_y = 0
  end

  def add_row(s : String) # convert a puzzle input row into actual data
    # auto-sizing the grid let's us accept any puzzle size
    @size_y += 1
    @size_x = {@size_x, s.size}.max
    @octopuses << s.each_char.map { |ch| Octopus.new(ch.to_i) }.to_a
  end

  def each_octopus
    @size_y.times do |y|
      @size_x.times do |x|
        yield x, y, @octopuses[y][x]
      end
    end
  end

  def octopus_count
    @size_x * @size_y
  end
  
  def each_surrounding(xc : Int32, yc : Int32)
    ((xc-1)..(xc+1)).each do |x|
      ((yc-1)..(yc+1)).each do |y|
        yield @octopuses[y][x] if x >= 0 && x < @size_x && y >= 0 && y < @size_y && !(x == xc && y == yc)
      end
    end
  end

  # perform one simulation step
  def step
    flash_count = 0 # set to true if any octopus flashes
    each_octopus do |x, y, octopus|
      octopus.energy += 1
    end
    loop do
      flashed = false
      each_octopus do |x, y, octopus|
        # if any octopus flashes, bump the surrounding ones
        if octopus.energy > 9 && !octopus.flashed
          octopus.flashed = flashed = true
          flash_count += 1
          each_surrounding(x, y) do |nearby|
            nearby.energy += 1
          end
        end
      end
      break unless flashed
    end
    # once we get here it means we had a whole cycle where no octopus flashed
    each_octopus do |x, y, octopus|
      if octopus.flashed
        octopus.energy = 0
        octopus.flashed = false
      end
    end
    return flash_count
  end

end

octopus_grid = OctopusGrid.new
STDIN.each_line(chomp: true) do |line|
  octopus_grid.add_row(line)
end

flash_count_100 = 0
first_all_flash : Int32? = nil
step = 1
while step < 100 || !first_all_flash
  flashes_this_step = octopus_grid.step
  flash_count_100 += flashes_this_step if step <= 100
  first_all_flash ||= step if flashes_this_step == octopus_grid.octopus_count
  step += 1
end

puts "Total flashes after 100 steps: #{flash_count_100}; first all-flash step: #{first_all_flash.inspect}"
