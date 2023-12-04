require "set"

class Card
  property :matches, :copies
  def initialize(@matches : Int32)
    @copies = 1
  end
end

cards = Array(Card).new

ARGF.each_line(chomp: true).each do |line|
  if line =~ /^Card\s+(\d+):(.+)\|(.+)$/
    num, winning, have = $1, $2.split.to_set, $3.split
    cards << Card.new have.count { |num| winning.includes?(num) }
  else
    raise "invalid input line: #{line}"
  end
end

cards.each_with_index do |card, i|
  ((i+1)...(i+1+card.matches)).each do |win|
    cards[win].copies += card.copies
  end
end

puts cards.map(&.copies).sum
