class Player
  attr_reader :name, :color, :score, :pieces, :captured
  attr_accessor :opponent

  def initialize(name, color)
    @name = name
    @color = color
    @score = 0
    @pieces = []
    @captured = []
    @opponent = nil
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
end
