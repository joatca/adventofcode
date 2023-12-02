bag = { "red" => 12, "green" => 13, "blue" => 14 }

puts ARGF.each_line(chomp: true).reduce(0) { |id_sum, gameline|
  if gameline =~ /^Game (\d+): (.*)$/
    id, games = $1.to_i, $2
    if games.split("; ").all? { |gametext|
         gametext.split(", ").all? { |colourtext|
           if colourtext =~ /^(\d+) (\S+)$/
             $1.to_i <= bag[$2]
           else
             raise "bad colour text: #{colourtext}"
           end
         }
       }
      id_sum + id
    else
      id_sum
    end
  else
    raise "bad input line: #{gameline}"
  end
}
