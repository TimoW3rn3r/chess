require './lib/square'

describe Square do
  describe '#initialize' do
    subject(:square) { described_class.new([1, 5], 'rook')}

    it 'creates new Square object with given position and piece value' do
      expect(square).to be_a(Square)
      expect(square.position).to eq([1, 5])
      expect(square.piece).to eq('rook')
    end

    it 'registers itself into class variable' do
      p square
      expect(described_class.at([1, 5])).to be(square)
    end
  end
  
  describe 'Square.at' do
    it 'returns new "BlackSquare" object when coordinates with even sum is passed' do
      expect(described_class.at([1, 1])).to be_a(BlackSquare)
    end

    it 'returns new "WhiteSquare" object when coordinates with odd sum is passed' do
      expect(described_class.at([7, 0])).to be_a(WhiteSquare)
    end
  end
end

describe WhiteSquare do
  subject(:white_square) { described_class.new([1, 1])  }
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
