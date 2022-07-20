# frozen_string_literal: true

require './lib/game'
require './lib/save'

# Menu class
class Menu
  include Save

  attr_reader :saved_games

  def initialize
    @saved_games = saved_list
  end

  def choose_saved_game
    print "Choose game(1-#{saved_games.length})>> "
    choice = gets.chomp.to_i
    game_chosen = saved_games[choice - 1]
    return load_from_file(game_chosen) unless choice.zero? || game_chosen.nil?

    puts 'Invalid Input'
    choose_saved_game
  end

  def load_saved_game
    puts 'Games Found:'
    saved_games.each_with_index do |name, index|
      puts "#{index + 1}. #{name}"
    end
    choose_saved_game
  end

  def game_choice
    choice = $stdin.getch
    case choice
    when '1'
      Game.new
    when '2'
      load_saved_game
    else
      puts 'Invalid Input'
      game_choice
    end
  end

  def start
    if saved_games.empty?
      game = Game.new
    else
      puts '1. Start new game'
      puts '2. Load saved game'
      game = game_choice
    end

    game.start
  end
end

menu = Menu.new
menu.start
