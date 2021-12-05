require "bit_array"
require "set"

class Board
  SIZE = 5

  def initialize
    @board = Array(Array(Int32)).new(SIZE) # don't initialize all elements yet
    @marked = Array(BitArray).new(SIZE) { |i| BitArray.new(SIZE, false) } # but initialize these
  end

  def add_row(row : Array(Int32))
    raise "too many rows" unless @board.size < SIZE
    raise "row too big" unless row.size == SIZE
    @board << row
  end

  # mark the board and return true if it has just won; we assume each number appears at most once per board
  def mark(target : Int32)
    @board.each_with_index do |row, y|
      row.each_with_index do |num, x|
        if num == target
          @marked[y][x] = true # found it!
          # check if the entire row or entire column is marked, if so this board wins
          if @marked[y].all?(true) || @marked.all? { |row| row[x] }
            return true
          end
        end
      end
    end
    return false
  end

  # sum of all unmarked squares
  def score
    @board.map_with_index { |row, y|
      row.each_with_index.reject { |val, x| @marked[y][x] }.map { |val, x| val }.sum
    }.sum
  end

  def to_s(io : IO)
    @board.each_with_index do |row, y|
      row.each_with_index do |val, x|
        io.printf("%3d%c", val, @marked[y][x] ? '*' : ' ')
      end
      io.puts ""
    end
  end
end

boards = Set(Board).new
current_board : Board? = nil

# first read the input numbers
numstr = STDIN.gets(chomp: true)

if numstr # checks if file was empty
  # assume the first line contains the called numbers; no error checking ;-)
  numbers = numstr.split(',').map { |s| s.to_i }

  # read the remaining lines and build boards from them
  STDIN.each_line(chomp: true) do |line|
    if line.size == 0 # new board
      unless current_board.nil?
        boards << current_board
        current_board = nil
      end
    else
      current_board ||= Board.new
      current_board.add_row(line.split.map { |s| s.to_i })
    end
  end
  boards << current_board unless current_board.nil? # add the final one if necessary

  first_winner : Board? = nil
  last_winner : Board? = nil
  first_num = last_num = 0 # initial value doesn't matter
  numbers.each do |num|
    # find all winning boards this turn - note we also delete them from boards so they never win again
    winners = boards.
              select { |board| board.mark(num) }.
              tap { |winners| winners.each { |board| boards.delete(board) } }
    if winners.size > 0 && first_winner.nil? # we found a winner and haven't yet found the first winning board,
                                             # set it now
      first_winner = winners.shift # pop off the first value
      first_num = num
    end
    # record all subsequent winners, if any, as the last winner
    if winners.size > 0
      last_winner = winners.last
      last_num = num
    end
  end
  if first_winner
    puts "Winning board:\n#{first_winner}"
    puts "Final number #{first_num} board score #{first_winner.score} score #{first_num * first_winner.score}"
    if last_winner
      puts "Guaranteed losing board:\n#{last_winner}"
      puts "Final number #{last_num} board score #{last_winner.score} score #{last_num * last_winner.score}"
    else
      puts "No last winner"
    end
  else
    puts "No first_winner"
  end
else
  puts "No input"
end
