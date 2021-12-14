template = STDIN.gets(chomp: true).as(String).split("")

rules = Hash(Array(String), String).new

STDIN.each_line(chomp: true) do |line|
  if line =~ /^([A-Z]{2}) -> ([A-Z])$/
    rules[$1.split("")] = $2
  end
end

result = Array(String).new
10.times do |step|
  result.clear
  template.each_cons_pair do |a, b|
    result << a
    result << rules[[a, b]] # we don't add the second of the pair since next iteration will get it
  end
  result << template.last # we have to add the final item
  template.clear.concat(result)
end

counts = template.tally

mincount, maxcount = counts.values.minmax

puts "Difference between max count and min count: #{maxcount - mincount}"
