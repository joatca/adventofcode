# pre-populate the counts with the template

template = STDIN.gets(chomp: true).as(String).split("")

letter_counts =  Hash(String, Int64).new(0_i64)
template.each do |letter|
  letter_counts[letter] += 1
end

pair_counts = Hash(Array(String), Int64).new(0_i64)
template.each_cons_pair do |a, b|
  pair_counts[[a,b]] += 1
end

rules = Hash(Array(String), String).new

STDIN.each_line(chomp: true) do |line|
  if line =~ /^([A-Z]{2}) -> ([A-Z])$/
    rules[$1.split("")] = $2
  end
end

40.times do |step|
  stage_pair_counts = pair_counts.dup
  pair_counts.each do |pair, count|
    #puts "Pair #{pair.inspect} count #{count}"
    stage_pair_counts[pair] -= count
    stage_pair_counts[[pair.first, rules[pair]]] += count
    stage_pair_counts[[rules[pair], pair.last]] += count
    letter_counts[rules[pair]] += count
  end
  #puts "Stage #{step}: stage counts#{stage_counts.inspect}"
  pair_counts.clear.merge!(stage_pair_counts)
  #puts "After step #{step}: #{counts.inspect}"
end

mincount, maxcount = letter_counts.values.minmax

puts "Difference between max count and min count: #{maxcount - mincount}"
