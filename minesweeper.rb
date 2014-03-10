
# Minesweeper game
# March 10
# Kevin & Buddy
MINE_COUNT = 15
BOARD_SIZE = 9
SYMBOLS = {hidden: '*', revealed: '_', flagged: 'F'}


require 'debugger'

class Tile

  attr_accessor :content, :state, :bomb_count, :i, :j, :board
  attr_reader   :neighbors

  def initialize
    @state = :hidden
    @bomb_count = 0
  end

  def reveal
    #call neighbors
    @state = :revealed
  end

  def neighbors
    @neighbors = []

     [-1, 1, 0].each do |mod1|
       [-1, 1, 0].each do |mod2|
        next if mod1 == 0 && mod2 == 0
        i_coord, j_coord = @i + mod1, @j + mod2

        if on_board?(i_coord,j_coord)
          @neighbors << @board.tiles[i_coord][j_coord]
        end

      end
    end
    #puts "I am at #{@i}, #{j}, my neighbors are #{@neighbors.map(&:i)}, #{@neighbors.map(&:j)} "
  end

  def on_board?(i_coord,j_coord)
    return true if ( i_coord.between?(0,BOARD_SIZE-1) &&
                     j_coord.between?(0,BOARD_SIZE-1) )
    false
  end

  def neighbor_bomb_count
    #determine if it's fringe and how many
    @neighbors.each do |neighbor|
      @bomb_count += 1 if neighbor.content == :mine
    end

  end


end

class Board

  attr_reader :tiles, :game_over

  def initialize(num_mines=MINE_COUNT)
    initial_board(num_mines)

  end

  def initial_board(num_mines)

    @tiles = Array.new(BOARD_SIZE) { Array.new (BOARD_SIZE) {Tile.new}}

    @tiles.each_with_index do |row,i|
      row.each_with_index do |tile,j|
        tile.i, tile.j = i, j
        tile.board = self
      end
    end

    mine_count = 0
    while mine_count < num_mines
      i,j = rand(BOARD_SIZE), rand(BOARD_SIZE)
      if @tiles[i][j].content.nil?
        @tiles[i][j].content = :mine
        mine_count += 1
      end
    end

    @tiles.map{|row| row.map{|tile| tile.neighbors}}
    @tiles.map{|row| row.map{|tile| tile.neighbor_bomb_count}}

  end

  def act(action, i, j)

    tile = @tiles[i][j]

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


    @tiles.each_with_index do |row, i|
      row.each_with_index do |tile, j|
         if SYMBOLS.has_key?(tile.state)
           mark = SYMBOLS[tile.state]
         else
           mark = tile.bomb_count
         end
        print " #{mark} "
        # print " #{tile.content==:mine ? 'm' : '*'} "
      end
      puts
    end

  end

end

class Game

  def initialize
    @board = Board.new(MINE_COUNT)
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