require_relative 'constants'

class Square
  include Colors

  attr_reader :position, :piece

  def initialize(position, piece=nil)
    @position = position
    @piece = piece
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
