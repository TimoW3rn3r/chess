require_relative 'square'

class Board
  attr_reader :squares, :selected, :last_move

  def initialize
    @selected = nil
    @last_move = nil
    create_squares
  end

  def select(square)
    @selected = square
  end

  def unselect_square
    @selected = nil
  end

  def create_squares
    @squares = Array.new(8) do |row|
      Array.new(8) do |column|
        Square.for([column, row])
      end
    end
  end

  def square_at(position)
    return nil if position.any?(&:negative?)

    squares.dig(position[1], position[0])
  end

  def empty(square)
    square.empty
  end

  def insert(piece, square)
    square.insert_piece(piece)
  end
  
  def apply_move(move)
    empty(move.source)
    move.piece.capture(move.takes)
    insert(move.piece, move.destination)
    @last_move = move
  end

  def possible_move?(square)
    @selected.piece.moves.each do |move|
      return true if move.destination.equal?(square)
    end
    false
  end

  def last_move?(square)
    return true if [last_move&.source, last_move&.destination].include?(square)
  end

  def square_color(square)
    if @selected
      return square.color_selection if @selected.equal?(square)
      return square.color_possible_move if possible_move?(square)
    elsif last_move?(square)
      square.color_last_move
    end
    square.color_normal
  end

  def printable_square(square)
    rgb = square_color(square).join(';')
    piece = square.piece
    return "\e[48;2;#{rgb}m   \e[m" unless piece
    
    case piece.color
    when :white
      "\e[1;1;48;2;#{rgb}m #{piece} \e[m"
    when :black
      "\e[0;30;48;2;#{rgb}m #{piece} \e[m"
    end
  end

  def draw
    squares.each do |square_row|
      square_row.each do |square|
        print printable_square(square)
      end
      print("\n")
    end
  end
end
