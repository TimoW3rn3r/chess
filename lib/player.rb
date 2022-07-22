# frozen_string_literal: true

require_relative 'constants'
require_relative 'piece'

# Player class
class Player
  include Converter

  attr_reader :name, :color, :score, :pieces, :captured
  attr_accessor :opponent, :king

  def self.for(color)
    print "Enter player name for #{color}>> "
    name = gets.chomp
    return Bot.new('Bot', color) if name.downcase == 'bot'
    
    Player.new(name, color)
  end

  def initialize(name, color)
    @name = name
    @color = color
    @score = 0
    reset
  end

  def reset
    @pieces = []
    @captured = []
    @king = nil
    @opponent = nil
  end

  def add_pieces(pieces, board)
    pieces.each do |notation, name|
      position = notation_to_coordinates(notation)
      piece = Piece.for(self, name, position, board)
      board.square_at(position).insert_piece(piece)
    end
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

  def valid_moves
    pieces.reduce([]) { |moves, piece| moves + piece.valid_moves }
  end

  def king_in_check?
    king.in_check?
  end

  def captured_pieces
    return if captured.empty?

    fg_color = opponent.color == :white ? '1;1' : '0;30'
    bg_color = '128;128;128'

    captured_string = captured
                      .sort { |piece1, piece2| piece1.value > piece2.value ? 1 : -1 }
                      .join('')

    "\e[#{fg_color};48;2;#{bg_color}m#{captured_string} \e[m"
  end

  def add_score(value)
    @score += value
  end

  def input
    case $stdin.getch
    when "\r" then { message: :confirm }
    when '[' then handle_escaped_input
    when '/' then handle_command_input
    else input
    end
  end

  def handle_escaped_input
    {
      'A' => { message: :cursor_move, value: [0, -1] },
      'B' => { message: :cursor_move, value: [0, 1] },
      'C' => { message: :cursor_move, value: [1, 0] },
      'D' => { message: :cursor_move, value: [-1, 0] }
    }[$stdin.getch]
  end

  def handle_command_input
    {
      'q' => { message: :quit },
      's' => { message: :save_game }
    }[$stdin.getch]
  end
end

# Bot class
class Bot < Player
  def input
    { message: :move, value: valid_moves.sample }
  end
end
