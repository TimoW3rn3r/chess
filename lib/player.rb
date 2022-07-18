require_relative 'constants'
require_relative 'piece'

class Player
  include Converter

  attr_reader :name, :color, :score, :pieces, :captured
  attr_accessor :opponent, :king

  def initialize(name, color)
    @name = name
    @color = color
    @score = 0
    @pieces = []
    @captured = []
    @king = nil
    @opponent = nil
  end

  def add_pieces(pieces, board)
    pieces.each do |notation, name|
      position = notation_to_coordinates(notation)
      piece = Piece.for(self, name, position, board)
      board.square_at(position).insert_piece(piece)
    end
  end

  def capture(piece)
    captured.push(piece)
  end

  def all_moves
    pieces.reduce([]) { |moves, piece| moves + piece.moves }
  end

  def reset_moves
    pieces.each(&:reset_moves)
  end

  def valid_moves
    pieces.reduce([]) { |moves, piece| moves + piece.valid_moves }
  end

  def king_in_check?
    king.in_check?
  end

  def captured_pieces
    return if captured.empty?

    fg_color = opponent.color == :white ? '1;1' : '0;30'
    bg_color = '128;128;128'

    captured_string = captured
                      .sort { |piece1, piece2| piece1.value > piece2.value ? 1 : -1 }
                      .join('')

    "\e[#{fg_color};48;2;#{bg_color}m" << captured_string << " \e[m"
  end
end
