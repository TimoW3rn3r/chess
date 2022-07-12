require './lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#square_at' do
    it 'returns square object at given position' do
      expect(board.square_at([5, 6]).position).to eq([5, 6])
    end
  end
end
