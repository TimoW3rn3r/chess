class Player
  attr_reader :name, :color, :score, :captured

  def initialize(name, color)
    @name = name
    @color = color
    @score = 0
    @captured = []
  end

  def capture(piece)
    captured.push(piece)
  end
end
