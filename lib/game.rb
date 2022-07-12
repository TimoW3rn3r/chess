require_relative 'constants'
require_relative 'board'
require_relative 'player'
require_relative 'piece'

class Game
  include DefaultPositions

  attr_reader :players, :board

  def initialize
    @board = Board.new
    @players = []
    @player_turn_now = nil
    @player_turn_next = nil
  end

  def notation_to_coordinates(notation)
    x, y = String(notation).split('')
    x_coordinate = x.ord - 'a'.ord
    y_coordinate = 7 - (y.to_i - 1)
    [x_coordinate, y_coordinate]
  end

  def coordinates_to_notation(coordinates)
    x_coordinate, y_coordinate = coordinates
    x = (97 + x_coordinate).chr
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
      color = if i.zero?
                :white
              else
                :black
              end
      add_player(name, color)
    end
  end

  def add_pieces(player, pieces)
    pieces.each do |notation, name|
      position = notation_to_coordinates(notation)
      piece = Piece.for(player, name, position)
      board.square_at(position).insert_piece(piece)
    end
  end

  def play_round
    add_players if players.empty?
    add_pieces(players.first, WHITE_PIECES)
    add_pieces(players.last, BLACK_PIECES)
    display
  end

  def display
    system('clear')
    puts players.last.name
    board.draw
    puts players.first.name
  end
end
