# frozen_string_literal: true

# Save module
module Save
  SAVE_DIR = './saved_games'
  EXTENSION = 'bin'

  def saved_list
    files = Dir.glob("saved_games/*.#{EXTENSION}")
    files.map do |file|
      file.split('/').last
          .split('.').first
    end
  end

  def save_to_file(object, game_name)
    save_file = "./saved_games/#{game_name}.#{EXTENSION}"
    binary = Marshal.dump(object)
    # write to file
    File.open(save_file, 'w') do |file|
      file.puts binary
    end
  end

  def load_from_file(game_name)
    save_file = "./saved_games/#{game_name}.#{EXTENSION}"
    # read from file
    binary = File.read(save_file)
    Marshal.load(binary)
  end
end
