require 'io/console'

require_relative 'constants'
require_relative 'board'
require_relative 'player'
require_relative 'piece'

class Game
  include DefaultPositions

  attr_reader :players, :board, :current_player, :white, :black

  def initialize
    @board = Board.new
    @players = {}
    @current_player = nil
    @white = nil
    @black = nil
  end

  def get_player(color)
    print "Enter player name for #{color}>> "
    name = gets.chomp
    Player.new(name, color)
  end

  def add_players
    @white = get_player(:white)
    @black = get_player(:black)
  end

  def add_pieces
    white.add_pieces(WHITE_PIECES, board)
    black.add_pieces(BLACK_PIECES, board)
  end

  def setup
    add_players if players.empty?
    add_pieces

    white.opponent = black
    black.opponent = white
    board.current_player = white
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
    when 's' then exit # save_game
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

  def select_piece
    square = handle_input
    if square.piece.nil?
      @commentary = 'No piece found'
    elsif square.piece.owner != board.current_player
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

  def game_over?
    king_in_check = board.current_player.king_in_check?
    if board.current_player.valid_moves.empty?
      display
      puts(king_in_check ? 'CHECKMATE!' : 'STALEMATE!')
      return true
    end

    @commentary = 'CHECK!' if king_in_check
    false
  end

  def play_round
    setup
    loop do
      display
      next unless make_a_move

      change_turn
      break if game_over?
    end
  end

  def above_board
    help
    puts black.name
    puts black.captured_pieces
  end

  def below_board
    puts white.captured_pieces
    puts white.name
    puts "\n#{board.current_player.color.capitalize} to move"
    puts "\n#{@commentary}"
  end

  def display
    system('clear')
    above_board
    board.draw
    below_board
  end

  def help
    puts 'C H E S S',
         '  Move:  ← → ↑ ↓',
         '  Select: ↵',
         '  Quit: /q'
  end
end
