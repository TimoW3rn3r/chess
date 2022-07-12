class Player
  attr_reader :name, :color, :score, :pieces

  def initialize(name, color)
    @name = name
    @color = color
    @score = 0
    @pieces = []
  end
end
