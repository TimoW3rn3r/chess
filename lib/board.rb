require_relative 'square'

class Board
  attr_reader :squares, :selected, :last_move, :cursor
  attr_accessor :current_player

  def initialize
    @selected = nil
    @last_move = nil
    @current_player = nil
    create_squares
    @cursor = square_at([4, 4])
  end

  def change_turn
    self.current_player = current_player.opponent
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
    move.piece.capture(move.takes) if move.takes
    insert(move.piece, move.destination)
    @last_move = move
  end

  def promote_to
    available_pieces = %i[queen rook bishop knight]
    available_pieces.each_with_index do |piece, index|
      puts "#{index + 1} => #{piece}"
    end
    print "Choose piece(1-#{available_pieces.length})>> "
    choice = gets.chomp.to_i
    piece_chosen = available_pieces[choice - 1]
    return piece_chosen unless piece_chosen.nil?

    puts 'Invalid choice!'
    promote_to
  end

  def promote(piece)
    owner = piece.owner
    promoted_piece_name = promote_to
    promoted_piece = Piece.for(owner, promoted_piece_name, piece.position, self)
    owner.pieces.delete(piece)
    square_at(piece.position).insert_piece(promoted_piece)
  end

  def find_move(test_move)
    current_player.all_moves.each do |move|
      next if move.source.position != test_move.source.position
      return move if move.destination.position == test_move.destination.position
    end
  end

  def king_in_check?
    current_player.king_in_check?
  end

  def change_cursor(delta)
    x, y = cursor.position
    x_delta, y_delta = delta
    x_new = [[0, x + x_delta].max, 7].min
    y_new = [[0, y + y_delta].max, 7].min
    @cursor = square_at([x_new, y_new])
  end

  def possible_move?(square)
    @selected.piece.valid_moves.each do |move|
      return true if move.destination.equal?(square)
    end
    false
  end

  def last_move?(square)
    return true if [last_move&.source, last_move&.destination].include?(square)
  end

  def square_color(square)
    return square.color_cursor if @cursor.equal?(square)
    return square.color_selection if @selected.equal?(square)
    return square.color_possible_move if @selected && possible_move?(square)
    return square.color_last_move if last_move?(square)

    square.color_normal
  end

  def printable_square(square)
    bg_color = square_color(square).join(';')
    piece = square.piece
    return "\e[48;2;#{bg_color}m   \e[m" unless piece

    fg_color = piece.color == :white ? '1;1' : '0;30'
    "\e[#{fg_color};48;2;#{bg_color}m #{piece} \e[m"
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
