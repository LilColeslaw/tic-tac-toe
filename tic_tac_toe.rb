# frozen_string_literal: false

require 'pry-byebug'

# used to make a game
class Game
  def initialize
    @turn = [false, false]
    create_board

    puts 'Starting a new tic-tac-toe game...'
    sleep(1.5)
    player1_name = get_name('1')
    player1_symbol = get_symbol(player1_name)
    @player1 = Player.new(player1_name, player1_symbol)
    player2_name = get_name('2')
    player2_symbol = get_symbol(player2_name)
    @player2 = Player.new(player2_name, player2_symbol)
    play
  end

  def play
    pick_first
    until game_end == true
      display_board
      # play the game
      player = @turn[0] ? @player1 : @player2
      play_move(player, get_move(player))
      @turn.reverse!
    end
    display_board
    winner = @turn[0] ? @player2 : @player1 # whoever made the winning move was the last player - find who that is
    puts "#{winner} has won the game!"
  end

  private

  # randomly pick who goes first
  def pick_first
    @turn[rand(2)] = true
  end

  def get_move(player)
    puts "#{player}, what is your move?"
    gets.chomp.to_i
  end

  def create_board
    @board = {}
    1.upto(9) do |num|
      @board[num] = num.to_s
    end
  end

  def play_move(player, square)
    if square.between?(1, 9)
      @board[square] = player.symbol
    else
      puts 'Not a valid square. Re-enter a move.'
      play_move(player, get_move(player))
    end
  end

  def get_name(player_number)
    puts "Player ##{player_number}, enter your name:"
    player_name = gets.chomp
    until player_name.length.positive?
      puts 'You must enter some characters as a name.'
      player_name = gets.chomp
    end
    player_name
  end

  def get_symbol(player_name)
    if @player1
      player_symbol = @player1.symbol == 'x' ? 'o' : 'x'
    else
      puts "#{player_name}, do you want to be 'x's or 'o's?"
      player_symbol = gets.chomp.downcase
      until %w[o x].include? player_symbol
        puts "You must enter either 'x' or 'o'"
        player_symbol = gets.chomp.downcase
      end
    end
    player_symbol
  end

  def display_board
    puts '-------------'
    @board.each do |key, value|
      if (key % 3).zero?
        puts "#{value} |" # put a new line after the 3, 6, and 9th squares and a wall for the right side
        puts '-------------'
      elsif [1, 4, 7].include?(key)
        print "| #{value} | " # make sure there is a left box side
      else
        print "#{value} | "
      end
    end
  end

  # used to emphasize the winning combo
  def upcase(first, second, third)
    @board[first] = @board[first].upcase
    @board[second] = @board[second].upcase
    @board[third] = @board[third].upcase
  end

  def game_end
    unless @board.count { |_key, value| value == @player1.symbol } >= 3 ||
           @board.count { |_key, value| value == @player2.symbol } >= 3
      false
    end
    [1, 4, 7].each do |num|
      if @board[num] == @board[num + 1] && @board[num + 1] == @board[num + 2]
        upcase(num, num + 1, num + 2)
        return true
      end
    end
    [1, 2, 3].each do |num|
      if @board[num] == @board[num + 3] && @board[num + 3] == @board[num + 6]
        upcase(num, num + 3, num + 6)
        return true
      end
    end
    if @board[1] == @board[5] && @board[5] == @board[9]
      upcase(1, 5, 9)
      true
    elsif @board[3] == @board[5] && @board[5] == @board[7]
      upcase(3, 5, 7)
      true
    else
      false
    end
  end
end

# represents a player in the game
class Player
  attr_reader :symbol
  attr_accessor :moves

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def to_s
    @name.to_s
  end
end

Game.new
