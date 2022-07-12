require './lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#notation_to_coordinates' do
    it 'converts chess notation to board coordinates' do
      expect(game.notation_to_coordinates('d3')).to eq([3, 5])
      expect(game.notation_to_coordinates('a8')).to eq([0, 0])
      expect(game.notation_to_coordinates('h1')).to eq([7, 7])
      expect(game.notation_to_coordinates('b4')).to eq([1, 4])
    end
  end
end
