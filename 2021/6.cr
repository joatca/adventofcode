STDIN.gets.try do |fish_s|
  school = Array(Int64).new(size: 9, value: 0) # gives counts of fish with current timer 0 through 8
  fish_s.split(',').each { |fish| school[fish.to_i] += 1 }
  (ARGV[0]? || "80").to_i.times { school.rotate![6] += school[8] } # [1..8]->[0..7], [0]->[8] & [6]+=[0] in one operation
  puts school.sum
end
