maps = Hash(String,Hash(Range(Int64, Int64), Int64)).new { |h, k| h[k] = Hash(Range(Int64, Int64), Int64).new }

cur_map = ""
seeds = [] of Int64

ARGF.each_line(chomp: true) do |line|
  case line
  when /^$/ # ignore blank lines
    next
  when /^seeds:\s+(.+)$/
    seeds += $1.split.map(&.to_i64)
  when /^(\S+) map:$/
    cur_map = $1
  when /^(\d+)\s(\d+)\s(\d+)$/
    dest, src, count = $1.to_i64, $2.to_i64, $3.to_i64
    maps[cur_map][src...(src+count)] = dest-src
  else
    raise "invalid input line"
  end
end

sequence = ["seed", "soil", "fertilizer", "water", "light", "temperature", "humidity", "location"].each_cons_pair.map { |from, to|
  "#{from}-to-#{to}"
}.to_a

puts seeds.map { |seed|
  sequence.each do |mapname|
    seed = begin
             range = maps[mapname].keys.find! { |r| r.includes?(seed) }
             seed + maps[mapname][range]
           rescue Enumerable::NotFoundError
             seed
           end
  end
  seed
}.min
