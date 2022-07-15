require_relative 'constants'
require_relative 'square'
require_relative 'move'

class Piece
  include PieceUnicodes

  attr_reader :owner, :position, :color, :board, :move_types
  attr_accessor :moved

  def self.for(owner, name, position, board)
    case name
    when :king then King
    when :queen then Queen
    when :rook then Rook
    when :bishop then Bishop
    when :knight then Knight
    when :pawn then Pawn
    end
      .new(owner, position, board)
  end

  def initialize(owner, position, board)
    @owner = owner
    @position = position
    @board = board
    @color = owner.color
    @available_moves = []
    @moves_calculated = false
    owner.pieces.push(self)
    @moved = false
  end

  def moved?
    @moved
  end

  def update_position(new_position)
    @position = new_position
  end

  def captured
    owner.pieces.delete(self)
  end

  def capture(piece)
    piece.captured
    owner.capture(piece)
    capture_square = board.square_at(piece.position)
    @board.empty(capture_square)
  end

  def reset_moves
    @moves_calculated = false
    @available_moves = []
  end

  def moves
    return @available_moves if @moves_calculated

    @available_moves = move_types.reduce([]) do |all_moves, move_type|
      all_moves + move_type.moves
    end
    @moves_calculated = true
    @available_moves
  end

  def to_s
    symbol
  end
end

class King < Piece
  def initialize(owner, position, board)
    super
    @move_types = [RookMoves.new(self, 1), BishopMoves.new(self, 1), CastleMoves.new(self)]
  end

  def symbol
    KING
  end
end

class Queen < Piece
  def initialize(owner, position, board)
    super
    @move_types = [RookMoves.new(self), BishopMoves.new(self)]
  end

  def symbol
    QUEEN
  end
end

class Rook < Piece
  def initialize(owner, position, board)
    super
    @move_types = [RookMoves.new(self)]
  end

  def symbol
    ROOK
  end
end

class Bishop < Piece
  def initialize(owner, position, board)
    super
    @move_types = [BishopMoves.new(self)]
  end

  def symbol
    BISHOP
  end
end

class Knight < Piece
  def initialize(owner, position, board)
    super
    @move_types = [KnightMoves.new(self, 1)]
  end

  def symbol
    KNIGHT
  end
end

class Pawn < Piece
  attr_reader :rank

  def initialize(owner, position, board)
    super
    @move_types = [PawnPush.new(self, 2), PawnTakes.new(self)]
    @rank = 2
  end

  def symbol
    PAWN
  end

  def promote
    board.promote(self)
  end

  def increase_rank(value)
    @rank += value
    promote if rank == 8
  end
end
