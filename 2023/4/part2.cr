require "set"

class Card
  property :matches, :copies
  def initialize(@matches : Int32, @copies : Int32 = 1) end
end

cards = [] of Card

ARGF.each_line(chomp: true) do |line|
  raise "invalid input line: #{line}" unless line =~ /^Card\s+\d+:(.+)\|(.+)$/
  winning, have = $1.split.to_set, $2.split
  cards << Card.new have.count { |num| winning.includes?(num) }
end

cards.each_with_index do |card, i|
  ((i+1)...(i+1+card.matches)).each do |win|
    cards[win].copies += card.copies
  end
end

puts cards.map(&.copies).sum
