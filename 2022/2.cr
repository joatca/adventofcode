input = STDIN.each_line(chomp: true).to_a

enum Play : UInt8
  Rock
  Paper
  Scissors
end

PART1_PLAYS = ["A", "B", "C", "X", "Y", "Z"].zip(Play.values + Play.values).to_h

SCORE = {
  { Play::Rock, Play::Rock } => 3 + 1,
  { Play::Paper, Play::Rock } => 0 + 1,
  { Play::Scissors, Play::Rock } => 6 + 1,
  { Play::Rock, Play::Paper } => 6 + 2,
  { Play::Paper, Play::Paper } => 3 + 2,
  { Play::Scissors, Play::Paper } => 0 + 2,
  { Play::Rock, Play::Scissors } => 0 + 3,
  { Play::Paper, Play::Scissors } => 6 + 3,
  { Play::Scissors, Play::Scissors } => 3 + 3,
}

score = 0
input.each do |line|
  challenge, response = line.split.map { |letter| PART1_PLAYS[letter] }
  score += SCORE[{challenge, response}]
end

puts "Part 1:"
puts score

PART2_PLAYS = ["A", "B", "C"].zip(Play.values).to_h
PLAY_SCORES = Play.values.zip(1..3).to_h

enum Strategy
  Lose
  Draw
  Win
end

STRATEGIES = ["X", "Y", "Z"].zip(Strategy.values).to_h
STRATEGY_SCORES = Strategy.values.zip([0, 3, 6]).to_h

PLAY_FROM_CHALLENGE = {
  { Play::Rock, Strategy::Lose } => Play::Scissors,
  { Play::Rock, Strategy::Draw } => Play::Rock,
  { Play::Rock, Strategy::Win } => Play::Paper,
  { Play::Paper, Strategy::Lose } => Play::Rock,
  { Play::Paper, Strategy::Draw } => Play::Paper,
  { Play::Paper, Strategy::Win } => Play::Scissors,
  { Play::Scissors, Strategy::Lose } => Play::Paper,
  { Play::Scissors, Strategy::Draw } => Play::Scissors,
  { Play::Scissors, Strategy::Win } => Play::Rock,
}

score = 0
input.each do |line|
  challenge_ch, strategy_ch = line.split
  challenge, strategy = PART2_PLAYS[challenge_ch], STRATEGIES[strategy_ch]
  response = PLAY_FROM_CHALLENGE[{challenge, strategy}]
  score += STRATEGY_SCORES[strategy] + PLAY_SCORES[response]
end

puts "Part 2:"
puts score
