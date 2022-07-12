require_relative 'constants'
require_relative 'square'

class Piece
  include PieceUnicodes

  attr_reader :owner, :position
  
  def initialize(owner, position)
    @owner = owner
    @position = position
  end

  def update_position(new_position)
    @position = new_position
  end

  def to_s
    symbol
  end
end


class King < Piece
  def self.for(owner, position)
    case owner.color
    when :white
      WhiteKing.new(owner, position)
    else
      BlackKing.new(owner, position)
    end
  end
end

class Queen < Piece
  def self.for(owner, position)
    case owner.color
    when :white
      WhiteQueen.new(owner, position)
    else
      BlackQueen.new(owner, position)
    end
  end
end

class Rook < Piece
  def self.for(owner, position)
    case owner.color
    when :white
      WhiteRook.new(owner, position)
    else
      BlackRook.new(owner, position)
    end
  end
end

class Bishop < Piece
  def self.for(owner, position)
    case owner.color
    when :white
      WhiteBishop.new(owner, position)
    else
      BlackBishop.new(owner, position)
    end
  end
end

class Knight < Piece
  def self.for(owner, position)
    case owner.color
    when :white
      WhiteKnight.new(owner, position)
    else
      BlackKnight.new(owner, position)
    end
  end
end

class Pawn < Piece
  def self.for(owner, position)
    case owner.color
    when :white
      WhitePawn.new(owner, position)
    else
      BlackPawn.new(owner, position)
    end
  end
end


class WhiteKing < King
  def symbol
    WHITE_KING
  end
end

class BlackKing < King
  def symbol
    BLACK_KING
  end
end

class WhiteQueen < Queen
  def symbol
    WHITE_QUEEN
  end
end

class BlackQueen < Queen
  def symbol
    BLACK_QUEEN
  end
end

class WhiteRook < Rook
  def symbol
    WHITE_ROOK
  end
end

class BlackRook < Rook
  def symbol
    BLACK_ROOK
  end
end

class WhiteBishop < Bishop
  def symbol
    WHITE_BISHOP
  end
end

class BlackBishop < Bishop
  def symbol
    BLACK_BISHOP
  end
end

class WhiteKnight < Knight
  def symbol
    WHITE_KNIGHT
  end
end

class BlackKnight < Knight
  def symbol
    BLACK_KNIGHT
  end
end

class WhitePawn < Pawn
  def symbol
    WHITE_PAWN
  end
end

class BlackPawn < Pawn
  def symbol
    BLACK_PAWN
  end
end
