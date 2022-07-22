# frozen_string_literal: true

require 'io/console'

require_relative 'constants'
require_relative 'board'
require_relative 'player'
require_relative 'piece'
require_relative 'save'

# GameInput module
module GameInput
  def play_again?
    print 'Play again(y/n): '
    gets.chomp.downcase == 'y'
  end

  def save_game
    print 'Enter save name: '
    name = gets.chomp
    save_to_file(self, name)
    puts 'Saved'
    $stdin.getch
  end
end

# GameLogic module
module GameLogic
  def declare_winner(player)
    player.add_score(1)
    display
    puts "#{player.name} wins with #{player.color} by CHECKMATE!"
  end

  def declare_draw
    puts "It's a STALEMATE!"
    players.each { |player| player.add_score(0.5) }
  end

  def game_over?
    king_in_check = current_player.king_in_check?
    unless current_player.valid_moves.empty?
      @commentary = 'CHECK!' if king_in_check
      return false
    end

    last_moved = current_player.opponent
    king_in_check ? declare_winner(last_moved) : declare_draw
    true
  end

  def handle_message(message)
    case message[:message]
    when :save_game then save_game
    when :quit then quit
    when :cursor_move then board.change_cursor(message[:value])
    when :confirm then make_a_move
    when :move
      move = message[:value]
      move.apply
      @turn_complete = true
    end
  end
end

# GameDisplay module
module GameDisplay
  def info(player)
    "#{player.name}(#{player.score})"
  end

  def above_board
    puts help
    puts info(black)
    puts black.captured_pieces
  end

  def below_board
    puts white.captured_pieces
    puts info(white)
    puts "\n#{current_player.color.capitalize} to move"
    puts "\n#{@commentary}"
  end

  def display
    system('clear')
    above_board
    board.draw
    below_board
  end

  def help
    "C H E S S\n" \
    "  Move: ← → ↑ ↓\n" \
    "  Select: ↵\n" \
    "  Save: /s\n" \
    "  Quit: /q\n\n"
  end
end

# Game class
class Game
  include GameInput
  include GameDisplay
  include GameLogic
  include DefaultPositions
  include Save

  attr_reader :board, :white, :black, :turn_complete

  def initialize
    @board = Board.new
    @current_player = nil
    @white = nil
    @black = nil
    @turn_complete = false
  end

  def add_players
    @white = Player.for(:white)
    @black = Player.for(:black)
  end

  def add_pieces
    white.add_pieces(WHITE_PIECES, board)
    black.add_pieces(BLACK_PIECES, board)
  end

  def players
    [white, black].compact
  end

  def current_player
    board.current_player
  end

  def board_setup
    board.reset
    add_pieces

    white.opponent = black
    black.opponent = white
    board.current_player = white
  end

  def game_setup
    return unless players.empty?

    add_players
    board_setup
  end

  def select_piece
    square = board.cursor
    if square.piece.nil?
      @commentary = 'No piece found'
    elsif square.piece.owner != current_player
      @commentary = 'Not your piece'
    else
      return board.select(square)
    end

    display
    # select_piece
  end

  def find_the_move(square)
    selected_piece = board.selected.piece
    selected_piece.valid_moves.each do |move|
      return move if move.destination == square
    end

    nil
  end

  def move_piece
    square = board.cursor
    move = find_the_move(square)
    board.unselect_square
    if move.nil?
      @commentary = 'Illegal move!'
      return
    end

    move.apply
    @turn_complete = true
  end

  def make_a_move
    if board.selected.nil?
      select_piece
    else
      move_piece
    end
  end

  def change_turn
    board.change_turn
    @turn_complete = false
  end

  def play_round
    game_setup
    loop do
      display
      handle_message(current_player.input)
      redo unless turn_complete

      change_turn
      break if game_over?
    end
  end

  def start
    play_round
    reset

    start if play_again?
  end

  def reset
    players.each(&:reset)
    board_setup
  end

  def quit
    puts 'Thanks for playing!'
    exit
  end
end
