require './lib/square'

describe Square do
  
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
  subject(:black_square) { described_class.new([-1, -5]) }
  describe '#color_normal' do
    it 'returns rgb value for black square' do
      expect(black_square.color_normal).to eq([181, 136, 99])
    end
  end
end
