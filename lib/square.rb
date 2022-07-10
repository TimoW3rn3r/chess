require_relative 'constants'

class Square
  include Colors

  attr_reader :position, :piece, :squares

  @@squares = Array.new(8) { [] }

  def self.at(position)
    square = @@squares.dig(position[0], position[1])
    unless square
      if position.sum.even?
        return BlackSquare.new(position)
      else
        return WhiteSquare.new(position)
      end
    end
    square
  end

  def initialize(position, piece = nil)
    @position = position
    @piece = piece
    @@squares[position[0]][position[1]] = self
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
end
