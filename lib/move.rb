require_relative 'piece'

class Move
  attr_reader :piece, :source, :destination, :takes

  def initialize(piece, source, destination, takes = nil)
    @piece = piece
    @source = source
    @destination = destination
    @takes = takes
  end

  def apply
    piece.moved = true
    board = piece.board
    board.apply_move(self)
    piece.owner.reset_moves
    piece.owner.opponent.reset_moves
  end

  def double_pawn_push?
    return false unless is_a?(PawnMove)

    push_amount = source.position[1] - destination.position[1]
    push_amount.abs == 2
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

  def jump_to_same_rank?(test_piece)
    test_piece.position[1] == destination.position[1]
  end
end

class Castle < Move
  attr_reader :rook_move

  def initialize(piece, source, destination, rook_move)
    super(piece, source, destination, nil)
    @rook_move = rook_move
  end

  def apply
    rook_move.apply
    super
  end
end

class Moves
  attr_reader :piece, :max_step

  def initialize(piece, max_step = 8)
    @piece = piece
    @max_step = max_step
    @board = piece.board
    @available_moves = []
  end

  def add
    @available_moves.push(
      Move.new(piece, @source, @target, @target.piece)
    )
  end

  def reached_end?
    # square out of board
    return true if @target.nil?

    if @target.piece.nil?
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
    @available_moves = []
    @source = @board.square_at(piece.position)
    directions.each { |direction| find_moves(direction) }
    @available_moves
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
    piece.color == :white ? [[0, -1]] : [[0, 1]]
  end

  def reached_end?
    return true if @target.nil? || @target.piece

    add
    return false if piece.rank == 2 && @step == 1

    true
  end

  def moves
    return [] if piece.owner != @board.current_player

    super
  end

  def add
    @available_moves.push(
      PawnMove.new(piece, @source, @target, @target.piece, @step)
    )
  end
end

class PawnTakes < Moves
  def directions
    piece.color == :white ? [[1, -1], [-1, -1]] : [[1, 1], [-1, 1]]
  end

  def fetch_target(last_move)
    target_coordinates = last_move.source.position.zip(last_move.destination.position).map { |arr| arr.sum / 2 }
    @target = @board.square_at(target_coordinates)
  end

  def check_en_pessant
    last_move = @board.last_move
    return if last_move.nil?
    return unless last_move.double_pawn_push? && last_move.jump_to_same_rank?(piece)

    fetch_target(last_move)
    @takes = last_move.piece
    add
  end

  def reached_end?
    return true if @target.nil? || @target.piece&.owner == piece.owner

    if @target.piece.nil?
      piece.owner == @board.current_player ? check_en_pessant : add
    else
      @takes = @target.piece
      add
    end

    true
  end

  def add
    @available_moves.push(
      PawnMove.new(piece, @source, @target, @takes)
    )
  end
end

class CastleMoves < Moves
  attr_reader :rook, :rook_move

  def initialize(piece, max_step = 8)
    super
    @rook = nil
    @rook_move = nil
    @rook_destination = nil
  end

  def directions
    [[1, 0], [-1, 0]]
  end

  def moves
    return [] if piece.moved? || piece.owner != @board.current_player

    super
  end

  def reached_end?
    target_piece = @target.piece
    return (@target.under_attack_by?(piece.owner.opponent) ? true : false) if target_piece.nil?

    if target_piece.owner == piece.owner && target_piece.is_a?(Rook) && !target_piece.moved?
      @rook = target_piece
      fetch_target
      add
    end

    true
  end

  def fetch_rook_move
    rook_source = @board.square_at(rook.position)
    Move.new(rook, rook_source, @rook_destination, nil)
  end

  def fetch_target
    king_position = piece.position
    rook_position = rook.position

    direction = [(rook_position[0] - king_position[0]).positive? ? 1 : -1, 0]
    target_rook_position = king_position.zip(direction).map(&:sum)
    target_king_position = target_rook_position.zip(direction).map(&:sum)
    @target = @board.square_at(target_king_position)
    @rook_destination = @board.square_at(target_rook_position)
  end

  def add
    @available_moves.push(
      Castle.new(piece, @source, @target, fetch_rook_move)
    )
  end
end
