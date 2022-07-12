require_relative 'constants'
require_relative 'square'

class Piece
  include PieceUnicodes

  attr_reader :owner, :position, :color
  
  def self.for(owner, name, position)
    case name
    when :king then King
    when :queen then Queen
    when :rook then Rook
    when :bishop then Bishop
    when :knight then Knight
    when :pawn then Pawn
    end
      .new(owner, position)
  end

  def initialize(owner, position)
    @owner = owner
    @position = position
    @color = owner.color
    owner.pieces.push(self)
  end

  def update_position(new_position)
    @position = new_position
  end

  def to_s
    symbol
  end
end


class King < Piece
  def symbol
    KING
  end
end

class Queen < Piece
  def symbol
    QUEEN
  end
end

class Rook < Piece
  def symbol
    ROOK
  end
end

class Bishop < Piece
  def symbol
    BISHOP
  end
end

class Knight < Piece
  def symbol
    KNIGHT
  end
end

class Pawn < Piece
  def symbol
    PAWN
  end
end
