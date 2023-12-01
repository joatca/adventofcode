class Valve
  property name, flow_rate, adjacents

  def initialize(@name : String)
    @adjacents = Hash(Valve, Int64).new(Int64::MAX)
    @flow_rate = 0_i64
  end

  def add_tunnel(valve : Valve, distance : Int64)
    @adjacents[valve] = distance if @adjacents[valve] > distance
  end

  def del_tunnel(valve : Valve)
    @adjacents.delete(valve)
  end

  def replace_tunnel(orig : Valve, replacements : Array(Valve))
    replacements.each do |new|
      unless new == self
        @adjacents[new] = @adjacents[orig] + 1
        #puts "in #{@name}, replace #{orig.name} with #{new.name}"
      end
    end
    del_tunnel(orig)
  end

  def to_s(io : IO)
    io << "#{@name} rate #{@flow_rate} (adjacents: #{@adjacents.keys.map(&.name).join(',')})"
  end
end

valves = Hash(String, Valve).new { |h, name| h[name] = Valve.new(name) }

STDIN.each_line(chomp: true) do |line|
  if line =~ /Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.+)$/
    name, rate, adjacents = $1, $2.to_i64, $3.split(/, */)
    valves[$1].flow_rate = rate
    adjacents.each do |vname|
      valves[name].add_tunnel(valves[vname], 1)
    end
  end
end

START_VALVE = "AA"

# trim out valves with no flow rate and relink tunnel costs
valves.keys.each do |vname|
  if valves[vname].flow_rate == 0 && vname != START_VALVE # we'll only ever pass through this valve, chop it out
    valves[vname].adjacents.each_key do |from_adj_valve|
      from_adj_valve.replace_tunnel(valves[vname], valves[vname].adjacents.keys)
    end
    valves.delete(vname)
  end
end

valves.each_value do |v|
  puts v
end

valve_names = valves.keys.sort # this puts "AA" first - cheater!

# note - distance cannot be greater than the original number of valves, so we can initialize the distances with that value
distances = Hash(Tuple(String, String), Int64).new(valves.size)

puts "\nempty"
p distances

# now run Floyd-Warshall to find all valve-to-valve distances

# set the distances we know directly from the adjacencies
valves.each do |name, valve|
  distances[{name,name}] = 0
  valve.adjacents.each do |adjacent, distance|
    distances[{name,adjacent.name.not_nil!}] = distance
  end
end

puts "\nbefore"
p distances

valve_names.each do |k|
  valve_names.each do |i|
    valve_names.each do |j|
      distances[{i,j}] = distances[{i,k}] + distances[{k,j}] if distances[{i,j}] > distances[{i,k}] + distances[{k,j}]
    end
  end
end

puts "\nafter"

puts "   #{valve_names.map {|vn| " "+vn }.join}"
valve_names.each do |row|
  puts "#{row} #{valve_names.map {|col|sprintf("%3d", distances[{row,col}])}.join}"
end

position = START_VALVE
pressure_released = 0
MAX_TIME = 30
time_remaining = MAX_TIME

def find_best_path(time_remaining : Int64, 
while valves.size > 0 && time_remaining > 2
  # find the valve that will give us the biggest bang for the buck right now
  cur_valve = valves[position]
  valves.delete(position) # we won't do this one again
  valve_list = valves.keys
  best_valve = nil
  best_valve_pres = 0
  best_valve_dist = 0
  puts "Searching at time=#{time_remaining} on valve #{position}"
  valve_list.each do |vname|
    distance = distances[{position,vname}]
    if time_remaining < distance + 2
      puts "deleting #{vname}, distance #{distance} is too far"
      valves.delete(vname)
      next
    else
      valve_pres = valves[vname].flow_rate * (time_remaining - distance - 1)
      print "Score for #{vname} distance #{distance} rate #{valves[vname].flow_rate} is #{valve_pres} "
      if valve_pres > best_valve_pres
        puts "new best"
        best_valve_pres = valve_pres
        best_valve = vname
        best_valve_dist = distance
      else
        puts "not better"
      end
    end
  end
  if best_valve.nil?
    puts "No more found"
    break # we've found everything we can
  else
    pressure_released += best_valve_pres
    time_remaining -= best_valve_dist + 1
    puts "#{best_valve} is best, distance #{best_valve_dist}, released #{best_valve_pres}, time left #{time_remaining}"
    position = best_valve
  end
end

puts pressure_released
