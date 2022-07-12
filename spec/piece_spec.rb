require './lib/piece'
require './lib/player'

describe Piece do
  let(:player) { double(Player, color: :white, pieces: []) }
  subject(:piece) { described_class.new(player, [3, 4]) }

  describe '.for' do
    it 'returns correct Piece object for given piece name' do
      king = described_class.for(player, :king, [1, 5])
      expect(king).to be_a(King)
    end
  end
  
  describe '#update_position' do
    it 'changes its position to given coordinates' do
      new_position = [1, 1]
      expect { piece.update_position(new_position) }.to change { piece.position }.to(new_position)
    end
  end
end
