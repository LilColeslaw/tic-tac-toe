# represents a board
class Board
  def initialize
    create_board
  end

  def play_move(player, square)
    @board[square] = player.symbol
  end

  # make an empty board with each square labeled by a number
  def create_board
    @board = {}
    1.upto(9) do |num|
      @board[num] = num.to_s
    end
  end
end

# represents a player in the game
class Player
  attr_reader :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
