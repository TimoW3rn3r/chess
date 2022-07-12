require './lib/square'
require './lib/piece'

describe Square do
  subject(:square) { described_class.new([1, 5], 'rook') }
  subject(:piece) { double(Piece, position: [1, 2], update_position: nil)}

  describe '.for' do
    it 'returns white square when given position with even sum' do
      expect(Square.for([2, 0])).to be_a(WhiteSquare)
    end
  end

  describe '#insert_piece' do
    it 'updates reference of piece variable to passed piece object' do
      square.insert_piece(piece)
      expect(square.piece).to be(piece)
    end
  end
end

describe WhiteSquare do
  subject(:white_square) { described_class.new([1, 1]) }
  describe '#color_normal' do
    it 'returns rgb value for white square' do
      expect(white_square.color_normal).to eq([240, 217, 181])
    end
  end
end

describe BlackSquare do
  subject(:black_square) { described_class.new([5, 2]) }
  describe '#color_normal' do
    it 'returns rgb value for black square' do
      expect(black_square.color_normal).to eq([181, 136, 99])
    end
  end
end
