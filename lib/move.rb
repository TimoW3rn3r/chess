class Move
  attr_reader :piece, :source, :destination, :takes

  def initialize(piece, source, destination, takes = nil)
    @piece = piece
    @source = source
    @destination = destination
    @takes = takes
  end

  def apply
    board = piece.board
    board.apply_move(self)
    piece.reset_moves
  end
end

class PawnMove < Move
  def initialize(piece, source, destination, takes = nil, rank_up = 1)
    super(piece, source, destination, takes)
    @rank_up = rank_up
  end

  def apply
    super
    piece.increase_rank(@rank_up)
  end
end

class Moves
  attr_reader :piece, :max_step

  def initialize(piece, max_step = 8)
    @piece = piece
    @max_step = max_step
    @board = piece.board
    @calculated = false
    @available_moves = []
  end

  def add
    @available_moves.push(
      Move.new(piece, @source, @target, @target.piece)
    )
  end

  def reached_end?
    if @target.nil?
      # square out of board
      return true
    elsif @target.piece.nil?
      # empty square
      add
      return false
    end

    add if @target.piece.owner != piece.owner
    true
  end

  def find_moves(direction)
    @step = 1
    position = piece.position
    while @step <= max_step
      position = position.zip(direction).map(&:sum)
      @target = @board.square_at(position)
      break if reached_end?

      @step += 1
    end
  end

  def moves
    return @available_moves if @calculated

    @source = @board.square_at(piece.position)
    directions.each { |direction| find_moves(direction) }
    @calculated = true
    # @available_moves.each { |move| p move.destination.position }
    # require 'pry-byebug'
    # binding.pry
    @available_moves
  end

  def reset
    @calculated = false
    @available_moves = []
  end
end

class RookMoves < Moves
  def directions
    [[-1, 0], [1, 0], [0, -1], [0, 1]]
  end
end

class BishopMoves < Moves
  def directions
    [[1, 1], [1, -1], [-1, -1], [-1, 1]]
  end
end

class KnightMoves < Moves
  def directions
    [
      [1, 2], [2, 1],
      [-1, 2], [-2, 1],
      [-1, -2], [-2, -1],
      [1, -2], [2, -1]
    ]
  end
end

class PawnPush < Moves
  def directions
    piece.owner.color == :white ? [[0, -1]] : [[0, 1]]
  end

  def reached_end?
    return true if @target.nil? || @target.piece

    add
    return false if piece.rank == 2 && @step == 1

    true
  end

  def add
    @available_moves.push(
      PawnMove.new(piece, @source, @target, @target.piece, @step)
    )
  end
end

class PawnTakes < Moves
  def directions
    piece.owner.color == :white ? [[1, -1], [-1, -1]] : [[1, 1], [-1, 1]]
  end

  def reached_end?
    return true if @target.nil? || @target.piece.nil? || @target.piece.owner == piece.owner

    add
    true
  end

  def add
    @available_moves.push(
      PawnMove.new(piece, @source, @target, @target.piece)
    )
  end
end
