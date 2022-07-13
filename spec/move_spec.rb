require './lib/move'
require './lib/board'
require './lib/player'
require './lib/piece'

describe RookMoves do
  let(:board) { Board.new }
  let(:player1) { double(Player, color: :white) }
  let(:player2) { double(Player, color: :black) }
  let(:piece) { double(Piece, position: [5, 2], owner: player1) }
  let(:second_piece) { double(Piece, position: [5, 4], owner: player1)}
  subject(:rook_moves) { described_class.new(board, piece)}
  
  describe '#moves' do
    before do
      allow(piece).to receive(:update_position)
      allow(second_piece).to receive(:update_position)
      board.square_at([5, 2]).insert_piece(piece)
      board.square_at([5, 4]).insert_piece(second_piece)
    end

    it 'returns correct number of valid rook moves' do
      expect(rook_moves.moves.length).to eq(10)
    end

    # it 'includes valid rook moves' do
    #   source = board.square_at([5, 2])
    #   destination = board.square_at([6, 2])
    #   expect(Move).to receive(:new).with(piece, source, destination, destination.piece).once
    #   rook_moves.moves
    # end
  end
end
