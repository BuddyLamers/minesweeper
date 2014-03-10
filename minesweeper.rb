
# Minesweeper game
# March 10
# Kevin & Buddy

require 'debugger'

class Tile

  attr_accessor :content, :state, :fringe, :coord, :board


  def initialize
    @content = content
    @state = :hidden
  end

  def reveal
    #call nbc
    @state = :revealed
  end

  def neighbors

  end

  def neighbor_bomb_count
    #determine if it's fringe and how many
  end


end

class Board

  MINE_COUNT = 15
  BOARD_SIZE = 9
  SYMBOLS = {hidden: '*', revealed: '_', flagged: 'F'}

  attr_reader :board, :game_over

  def initialize(num_mines=MINE_COUNT)
    initial_board(num_mines)

  end

  def initial_board(num_mines)

    @board = Array.new(BOARD_SIZE) { Array.new (BOARD_SIZE) {Tile.new}}

    @board.each_with_index do |row,i|
      @row.each_with_index do |tile,j|
        tile.coord = [i,j]
        tile.board = self
      end
    end

    mine_count = 0
    while mine_count < num_mines
      i,j = rand(BOARD_SIZE), rand(BOARD_SIZE)
      if @board[i][j].content.nil?
        @board[i][j].content = :mine
        mine_count += 1
      end
    end
  end

  def act(action, i, j)

    tile = @board[i][j]

    if action == 'r'
      tile.reveal
      @game_over = true if tile.content == :mine
    elsif action == 'f'
      tile.state = (tile.state == :flagged ? :hidden : :flagged)
    end

  end

  def display
    #loop through board and display based on contents and state
    # * = unexplored, _ = explored, empty
    # F = flagged,  1/2/3 = fringe

    @board.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        print " #{SYMBOLS[tile.state]} "
      end
      puts
    end

  end

end

class Game

  def initialize
    @board = Board.new(15)
  end

  def run

    until @board.game_over
      action, i, j = prompt_user
      @board.act(action, i, j)

    end
  end

  def prompt_user
    @board.display
    puts "Enter your command, r or f, and coordinates"
    puts "Coordinates begin in the upper left and start with 0"
    puts "Example r 1 2"
    action, i, j = gets.chomp.split(' ')

    [action.downcase, i.to_i, j.to_i]

  end

end