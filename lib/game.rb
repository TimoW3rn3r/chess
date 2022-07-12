require_relative 'board'
require_relative 'player'

class Game
  attr_reader :players, :board

  def initialize
    @board = Board.new
    @players = []
    @player_turn_now = nil
    @player_turn_next = nil
  end

  def add_player(name, color)
    players.push(Player.new(name, color))
  end

  def player_name(player_number)
    puts "Player##{player_number}"
    print '  Enter player name>> '
    gets.chomp
  end
  
  def add_players
    2.times do |i|
      name = player_name(i + 1)
      color = if i.zero?
                :white
              else
                :black
              end
      add_player(name, color)
    end
  end

  def play_round
    add_players if players.empty?
    display
  end

  def display
    system('clear')
    puts players.last.name
    board.draw
    puts players.first.name
  end
end
