STDIN.gets.try do |fish_s|
  school = Array(Int64).new(size: 9, value: 0) # gives counts of fish with current timer 0 through 8
  fish_s.split(',').each { |fish| school[fish.to_i] += 1 }
  (ARGV[0]? || "80").to_i.times do # do 80 by default or whatever is the first argument
    school.rotate![6] += school[8] # rotate 0 count to pos 8 (spawned) then add that to 6 (original fish)
  end
  puts school.sum
end