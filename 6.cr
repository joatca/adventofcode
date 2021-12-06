STDIN.gets.try do |fish_s|
  school = Array(Int64).new(size: 9, value: 0) # gives counts of fish with current timer 0 through 8
  fish_s.split(',').each { |fish| school[fish.to_i] += 1 }
  (ARGV[0]? || "80").to_i.times do # do 80 by default or whatever is the first argument
    spawned = school.shift # now the number of fish who were at zero is in spawned and all the others decrement by one
    school[6] += spawned # the spawning fish reset to timer 6
    school << spawned # and spawn extra fish with timer 8
  end
  p school.sum
end
