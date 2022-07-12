require_relative 'square'

class Board
  attr_reader :squares

  def initialize
    create_squares
  end

  def create_squares
    @squares = Array.new(8) do |row|
      Array.new(8) do |column|
        Square.for([column, row])
      end
    end
  end

  def square_at(position)
    square = squares.dig(position[0], position[1])
  end

  def draw
    squares.each do |square_row|
      puts square_row.join('')
    end
  end
end
