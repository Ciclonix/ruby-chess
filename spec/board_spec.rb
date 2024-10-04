# frozen_string_literal: true

require_relative "../lib/board"

# rubocop:disable Metrics/BlockLength

describe Board do
  subject(:board) { described_class.new }

  describe "#canMoveHere?" do
    context "when the row is invalid" do
      it "returns false" do
        row = -1
        col = 4
        color = :white
        expect(board.canMoveHere?(row, col, color)).to be(false)
      end
    end

    context "when the col is invalid" do
      it "returns false" do
        row = 3
        col = 15
        color = :white
        expect(board.canMoveHere?(row, col, color)).to be(false)
      end
    end

    context "when it's taking and the color is the same" do
      it "returns false" do
        row = 0
        col = 0
        color = :white
        expect(board.canMoveHere?(row, col, color, true)).to be(false)
      end
    end

    context "when it's taking and the color is different" do
      it "returns true" do
        row = 0
        col = 0
        color = :black
        expect(board.canMoveHere?(row, col, color, true)).to be(true)
      end
    end

    context "when it's not taking and the square is free" do
      it "returns true" do
        row = 5
        col = 5
        color = :black
        expect(board.canMoveHere?(row, col, color, false)).to be(true)
      end
    end
  end

  let(:piece) { { pos: [4, 4], color: :black, takes?: true, moves: [] } }

  describe "#possibleRookMoves" do
    context "when the rook is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0], [5, 4], [3, 4], [2, 4], [1, 4]]
        expect { board.possibleRookMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleKnightMoves" do
    context "when the knight is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[3, 2], [5, 6], [3, 6], [5, 2], [2, 3], [2, 5]]
        expect { board.possibleKnightMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleBishopMoves" do
    context "when the bishop is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[5, 3], [5, 5], [3, 3], [2, 2], [1, 1], [3, 5], [2, 6], [1, 7]]
        expect { board.possibleBishopMoves(piece) }.to change { piece[:moves] }.to eql(moves)
      end
    end
  end

  describe "#possibleQueenMoves" do
    context "when the queen is at the center of an already set board" do
      it "returns the correct moves" do
        moves = [[4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0], [5, 4], [3, 4],
                 [2, 4], [1, 4], [5, 3], [5, 5], [3, 3], [2, 2], [1, 1], [3, 5], [2, 6], [1, 7]]
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
