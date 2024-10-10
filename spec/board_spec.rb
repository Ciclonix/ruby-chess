# frozen_string_literal: true

require_relative "../lib/board"

# rubocop:disable Metrics/BlockLength

describe Board do
  subject(:board) { described_class.new }
  let(:piece) { { from: [4, 4], color: :black, takes?: false, moves: [] } }

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
  end

  describe "#canTake?" do
    context "when the target square is free" do
      it "returns [true, true]" do
        row = 5
        col = 5
        expect(board.canTake?(col, row, piece[:color])).to eql([true, true])
      end
    end

    context "when the target square color is the same" do
      it "returns [false, false]" do
        row = 7
        col = 7
        expect(board.canTake?(col, row, piece[:color])).to eql([false, false])
      end
    end

    context "when the target square color is different" do
      it "returns [true, false]" do
        row = 0
        col = 0
        expect(board.canTake?(col, row, piece[:color])).to eql([true, false])
      end
    end
  end

  describe "#possibleRookMoves" do
    context "when the rook is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[4, 5], [4, 3], [4, 2], [4, 1], [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4]]
        expect { board.possibleRookMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleKnightMoves" do
    context "when the knight is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[3, 2], [5, 2], [2, 3], [6, 5], [2, 5], [6, 3]]
        expect { board.possibleKnightMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleBishopMoves" do
    context "when the bishop is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[3, 5], [5, 5], [3, 3], [2, 2], [1, 1], [5, 3], [6, 2], [7, 1]]
        expect { board.possibleBishopMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleQueenMoves" do
    context "when the queen is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[4, 5], [4, 3], [4, 2], [4, 1], [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4],
                 [0, 4], [3, 5], [5, 5], [3, 3], [2, 2], [1, 1], [5, 3], [6, 2], [7, 1]]
        expect { board.possibleQueenMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleKingMoves" do
    context "when the king is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[5, 5], [5, 4], [5, 3], [4, 5], [4, 3], [3, 5], [3, 4], [3, 3]]
        expect { board.possibleKingMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
