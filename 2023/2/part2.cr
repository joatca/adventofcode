puts ARGF.each_line(chomp: true).reduce(0) { |power_sum, gameline|
  if gameline =~ /^Game (\d+): (.*)$/
    id, games = $1.to_i, $2
    bag = Hash(String, Int32).new(0)
    games.split("; ").each do |gametext|
      gametext.split(", ").each do |colourtext|
        if colourtext =~ /^(\d+) (\S+)$/
          bag[$2] = {bag[$2], $1.to_i}.max
        else
          raise "bad colour text: #{colourtext}"
        end
      end
    end
    power_sum + bag["red"]*bag["green"]*bag["blue"]
  else
    raise "bad input line: #{gameline}"
  end
}
