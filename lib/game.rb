require_relative 'constants'
require_relative 'board'
require_relative 'player'
require_relative 'piece'

class Game
  # include DefaultPositions
  include TemporaryPositions

  attr_reader :players, :board, :current_player

  def initialize
    @board = Board.new
    @players = []
    @current_player = nil
  end

  def notation_to_coordinates(notation)
    x, y = String(notation).split('')
    x_coordinate = x.ord - 'a'.ord
    y_coordinate = 7 - (y.to_i - 1)
    [x_coordinate, y_coordinate]
  end

  def coordinates_to_notation(coordinates)
    x_coordinate, y_coordinate = coordinates
    x = ('a'.ord + x_coordinate).chr
    y = (7 - y_coordinate + 1).to_s
    x + y
  end

  def add_player(name, color)
    players.push(Player.new(name, color))
  end

  def player_name(player_number)
    puts "Player##{player_number}"
    print '  Enter player name>> '
    gets.chomp
  end

  def add_players
    2.times do |i|
      name = player_name(i + 1)
      color = i.zero? ? :white : :black
      add_player(name, color)
    end
  end

  def setup
    add_players if players.empty?
    white = players.first
    black = players.last
    add_pieces(white, WHITE_PIECES)
    add_pieces(black, BLACK_PIECES)
    
    white.opponent = black
    black.opponent = white
    board.current_player = white
  end

  def add_pieces(player, pieces)
    pieces.each do |notation, name|
      position = notation_to_coordinates(notation)
      piece = Piece.for(player, name, position, board)
      board.square_at(position).insert_piece(piece)
    end
  end

  def user_input
    input = gets.chomp

    if input.match(/[a-h][1-8]/).nil?
      puts 'Invalid input'
      return user_input
    end

    coordinates = notation_to_coordinates(input)
    board.square_at(coordinates)
  end

  def select_piece
    print 'Piece to move>> '
    square = user_input
    if square.piece.nil?
      puts 'No piece found'
    elsif square.piece.owner != board.current_player
      puts 'Not your piece'
    else
      return board.select(square)
    end

    select_piece
  end

  def find_the_move(square)
    selected_piece = board.selected.piece
    selected_piece.moves.each do |move|
      return move if move.destination == square
    end

    nil
  end

  def move_piece
    print 'Move to>> '
    square = user_input
    move = find_the_move(square)
    board.unselect_square
    return puts 'Illegal move!' if move.nil?

    move.apply
    true
  end

  def make_a_move
    if board.selected.nil?
      select_piece
      false
    else
      move_piece
    end
  end

  def change_turn
    board.change_turn
  end

  def play_round
    setup

    loop do
      display
      next unless make_a_move

      change_turn
    end
  end

  def display
    # system('clear')
    puts players.last.name
    board.draw
    puts players.first.name
  end
end
