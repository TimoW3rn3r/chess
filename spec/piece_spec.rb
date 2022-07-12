require './lib/piece'
require './lib/player'

describe Piece do
  subject(:piece) { described_class.new('Player2', [3, 4]) }
  let(:square) { double(Square, insert_piece: nil) }

  describe '#update_position' do
    it 'changes its position to given coordinates' do
      new_position = [1, 1]
      expect { piece.update_position(new_position) }.to change { piece.position }.to(new_position)
    end
  end
end

describe King do
  subject(:king) { described_class.new('Player1', [3, 2]) }
  let(:player) { double(Player, color: :white) }

  describe '.for' do
    it 'creates white king piece when owner has white as color attribute' do
      white_king = described_class.for(player, [1, 5])
      expect(white_king).to be_a(WhiteKing)
    end
  end
end

describe WhiteKing do
  subject(:white_king) { described_class.new('Player', [1, 3]) }

  describe '#symbol' do
    it 'returns unicode character for white king' do
      expect(white_king.symbol).to eq("\u2654")
    end
  end
end
