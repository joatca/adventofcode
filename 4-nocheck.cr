# stripped down version without board display or error checking

require "set"

class Board

  def initialize
    @board = Array(Array(Int32)).new # don't initialize all elements yet
    @marked = Array(Array(Bool)).new
    @winning_number = nil
  end

  def add_row(row : Array(Int32))
    @board << row
    @marked << [ false ] * row.size
  end

  # mark the board and return true if it has just won; we assume each number appears at most once per board
  def mark(target : Int32)
    @board.each_with_index do |row, y|
      row.index(target).try do |x|
        @marked[y][x] = true # found it!
        # if the entire row or entire column is marked then this board wins
        if @marked[y].all?(true) || @marked.all? { |row| row[x] }
          @winning_number = target
          return true
        end
      end
    end
    return false
  end

  # sum of all unmarked squares
  def score
    @board.map_with_index { |row, y|
      row.each_with_index.reject { |val, x| @marked[y][x] }.map { |val, x| val }.sum
    }.sum * @winning_number.as(Int32)
  end

end

boards = Set(Board).new
current_board : Board? = nil

# first read the input numbers
STDIN.gets(chomp: true).try do |numstr| # only runs if file is not empty

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

  winners = numbers.reduce([] of Board) { |so_far, num|
    so_far.concat(boards.
                   select { |board| board.mark(num) }.
                   tap { |winners| winners.each { |board| boards.delete(board) } })
  }

  puts "Winning board score #{winners.first.score}"
  puts "Losing board score #{winners.last.score}"
end
