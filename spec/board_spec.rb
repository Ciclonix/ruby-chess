# frozen_string_literal: true

require_relative "../lib/board"
require_relative "../lib/piece"

describe Board do
  subject(:board) { described_class.new }
  let(:piece) { instance_double("Piece") }


  describe "#addMove" do
    context "when the row or col are invalid" do
      it "returns nil" do
        row = -1
        col = 4
        expect(board.addMove(col, row, piece)).to be(nil)
      end

      it "returns nil" do
        row = 3
        col = 15
        expect(board.addMove(col, row, piece)).to be(nil)
      end
    end

    context "when the target square is free" do
      before do
        expect(piece).to receive(:possible_moves).and_return([[], []])
      end

      it "returns true" do
        row = 5
        col = 5
        expect(board.addMove(col, row, piece)).to eql(true)
      end
    end

    context "when the target square color is the same" do
      before do
        expect(piece).to receive(:color).and_return(:black)
      end

      it "returns false" do
        row = 7
        col = 7
        expect(board.addMove(col, row, piece)).to eql(false)
      end
    end

    context "when the target square color is different" do
      before do
        expect(piece).to receive(:color).and_return(:black)
        expect(piece).to receive(:possible_moves).and_return([[], []])
      end

      it "returns false" do
        row = 0
        col = 0
        expect(board.addMove(col, row, piece)).to eql(false)
      end
    end
  end

  describe "#possibleRookMoves" do
    context "when the rook is at the center of an already set board" do
      before do
        expect(piece).to receive(:position).exactly(16).times.and_return([4, 4])
        expect(piece).to receive(:color).twice.and_return(:black)
        expect(piece).to receive(:possible_moves).exactly(13).times.and_return([[], []])
      end

      it "returns the correct moves" do
        moves = [[[4, 5], [4, 3], [4, 2], [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4]], [[4, 1]]]
        expect { board.possibleRookMoves(piece) }.to change { piece.possible_moves }.to eql(moves)
      end
    end
  end

  describe "#possibleKnightMoves" do
    context "when the knight is at the center of an already set board" do
      before do
        expect(piece).to receive(:position).exactly(16).times.and_return([4, 4])
        expect(piece).to receive(:color).twice.and_return(:black)
        expect(piece).to receive(:possible_moves).exactly(8).times.and_return([[], []])
      end

      it "returns the correct moves" do
        moves = [[[3, 2], [5, 2], [2, 3], [6, 5], [2, 5], [6, 3]], []]
        expect { board.possibleKnightMoves(piece) }.to change { piece.possible_moves }.to eql(moves)
      end
    end
  end

  describe "#possibleBishopMoves" do
    context "when the bishop is at the center of an already set board" do
      before do
        expect(piece).to receive(:position).exactly(20).times.and_return([4, 4])
        expect(piece).to receive(:color).exactly(4).times.and_return(:black)
        expect(piece).to receive(:possible_moves).exactly(10).times.and_return([[], []])
      end

      it "returns the correct moves" do
        moves = [[[3, 5], [5, 5], [3, 3], [2, 2], [5, 3], [6, 2]], [[1, 1], [7, 1]]]
        expect { board.possibleBishopMoves(piece) }.to change { piece.possible_moves }.to eql(moves)
      end
    end
  end

  describe "#possibleQueenMoves" do
    context "when the queen is at the center of an already set board" do
      before do
        expect(piece).to receive(:position).exactly(36).times.and_return([4, 4])
        expect(piece).to receive(:color).exactly(6).times.and_return(:black)
        expect(piece).to receive(:possible_moves).exactly(21).times.and_return([[], []])
      end

      it "returns the correct moves" do
        moves = [[[4, 5], [4, 3], [4, 2], [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4],
                  [3, 5], [5, 5], [3, 3], [2, 2], [5, 3], [6, 2]], [[4, 1], [1, 1], [7, 1]]]
        expect { board.possibleQueenMoves(piece) }.to change { piece.possible_moves }.to eql(moves)
      end
    end
  end

  describe "#possibleKingMoves" do
    context "when the king is at the center of an already set board" do
      before do
        expect(piece).to receive(:position).exactly(16).times.and_return([4, 4])
        expect(piece).to receive(:possible_moves).exactly(10).times.and_return([[], []])
      end

      it "returns the correct moves" do
        moves = [[[5, 5], [5, 4], [5, 3], [4, 5], [4, 3], [3, 5], [3, 4], [3, 3]], []]
        expect { board.possibleKingMoves(piece) }.to change { piece.possible_moves }.to eql(moves)
      end
    end
  end
end
