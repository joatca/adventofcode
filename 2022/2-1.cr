enum Game : UInt8
  Rock
  Paper
  Scissors
end

PLAYS = ["A", "B", "C", "X", "Y", "Z"].zip(Game.values + Game.values).to_h

SCORE = {
  { Game::Rock, Game::Rock } => 3 + 1,
  { Game::Paper, Game::Rock } => 0 + 1,
  { Game::Scissors, Game::Rock } => 6 + 1,
  { Game::Rock, Game::Paper } => 6 + 2,
  { Game::Paper, Game::Paper } => 3 + 2,
  { Game::Scissors, Game::Paper } => 0 + 2,
  { Game::Rock, Game::Scissors } => 0 + 3,
  { Game::Paper, Game::Scissors } => 6 + 3,
  { Game::Scissors, Game::Scissors } => 3 + 3,
}

score = 0
STDIN.each_line(chomp: true) do |line|
  challenge, response = line.split.map { |letter| PLAYS[letter] }
  score += SCORE[{challenge, response}]
end

puts score
