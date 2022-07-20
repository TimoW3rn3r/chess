# frozen_string_literal: true

require 'io/console'

require_relative 'constants'
require_relative 'board'
require_relative 'player'
require_relative 'piece'
require_relative 'save'

# GameInput module
module GameInput
  def get_player(color)
    print "Enter player name for #{color}>> "
    name = gets.chomp
    Player.new(name, color)
  end

  def user_input
    input = gets.chomp

    if input.match(/[a-h][1-8]/).nil?
      @commentary = 'Invalid input'
      return user_input
    end

    coordinates = notation_to_coordinates(input)
    board.square_at(coordinates)
  end

  def handle_escaped_input
    case $stdin.getch
    when 'A' then board.change_cursor([0, -1])
    when 'B' then board.change_cursor([0, 1])
    when 'C' then board.change_cursor([1, 0])
    when 'D' then board.change_cursor([-1, 0])
    end
    display
    false
  end

  def handle_command_input
    case $stdin.getch
    when 'q' then exit
    when 's' then save_game
    end
    false
  end

  def handle_input
    @commentary = ''
    case $stdin.getch
    when "\r" then return board.cursor
    when '[' then handle_escaped_input
    when '/' then handle_command_input
    end

    handle_input
  end

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
      puts 'CHECK!' if king_in_check
      return false
    end

    last_moved = current_player.opponent
    king_in_check ? declare_winner(last_moved) : declare_draw
    true
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

  attr_reader :board, :white, :black

  def initialize
    @board = Board.new
    @current_player = nil
    @white = nil
    @black = nil
  end

  def add_players
    @white = get_player(:white)
    @black = get_player(:black)
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

  def select_piece
    square = handle_input
    if square.piece.nil?
      @commentary = 'No piece found'
    elsif square.piece.owner != current_player
      @commentary = 'Not your piece'
    else
      return board.select(square)
    end

    display
    select_piece
  end

  def find_the_move(square)
    selected_piece = board.selected.piece
    selected_piece.valid_moves.each do |move|
      return move if move.destination == square
    end

    nil
  end

  def move_piece
    square = handle_input
    move = find_the_move(square)
    board.unselect_square
    if move.nil?
      @commentary = 'Illegal move!'
      return false
    end

    move.apply
    true
  end

  def make_a_move
    if board.selected.nil?
      select_piece
      false
    else
      move_piece
    end
  end

  def change_turn
    board.change_turn
  end

  def play_round
    if players.empty?
      add_players
      board_setup
    end

    loop do
      display
      next unless make_a_move

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
end
