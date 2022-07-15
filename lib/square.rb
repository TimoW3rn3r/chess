require_relative 'constants'

class Square
  include Colors

  attr_reader :piece, :position

  def self.for(position)
    return WhiteSquare.new(position) if position.sum.even?
    
    BlackSquare.new(position)
  end
  
  def initialize(position, piece = nil)
    @position = position
    @piece = piece
  end

  def insert_piece(piece)
    @piece = piece
    piece.update_position(position)
  end

  def empty
    @piece = nil
  end

  def under_attack_by?(player)
    player.all_moves.any? do |move|
      move.destination == self
    end
  end
end


class WhiteSquare < Square
  def color_normal
    WHITE_NORMAL
  end

  def color_selection
    WHITE_SELECTION
  end

  def color_last_move
    WHITE_LAST_MOVE
  end

  def color_cursor
    WHITE_CURSOR
  end

  def color_possible_move
    WHITE_POSSIBLE_MOVE
  end
end


class BlackSquare < Square
  def color_normal
    BLACK_NORMAL
  end

  def color_selection
    BLACK_SELECTION
  end

  def color_last_move
    BLACK_LAST_MOVE
  end

  def color_cursor
    BLACK_CURSOR
  end

  def color_possible_move
    BLACK_POSSIBLE_MOVE
  end
end
