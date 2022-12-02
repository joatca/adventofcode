enum Play : UInt8
  Rock
  Paper
  Scissors
end

PLAYS = ["A", "B", "C"].zip(Play.values).to_h
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
STDIN.each_line(chomp: true) do |line|
  challenge_ch, strategy_ch = line.split
  challenge, strategy = PLAYS[challenge_ch], STRATEGIES[strategy_ch]
  response = PLAY_FROM_CHALLENGE[{challenge, strategy}]
  score += STRATEGY_SCORES[strategy] + PLAY_SCORES[response]
end

puts score
