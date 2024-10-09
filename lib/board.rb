# frozen_string_literal: true

require_relative "piece"
require_relative "moves"

class Board
  include Moves

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setPieces
  end

  # prepares the starting position of each piece
  def setPieces
    roles_order = %i[rook knight bishop queen king bishop knight rook]
    @grid[7] = roles_order.map { |role| Piece.new(:black, role) }
    @grid[6] = Array.new(8) { Piece.new(:black, :pawn) }
    @grid[1] = Array.new(8) { Piece.new(:white, :pawn) }
    @grid[0] = roles_order.map { |role| Piece.new(:white, role) }
  end

  def printBoard
    puts "    a   b   c   d   e   f   g   h\n  -#{'----' * 8}"
    @grid.reverse.each_with_index do |row, idx|
      row_to_print = "#{8 - idx} |"
      row.each do |square|
        piece = square.nil? ? " " : square.getPiece
        row_to_print += " #{piece} |"
      end
      row_to_print += "\n  -#{'----' * 8}"
      puts row_to_print
    end
  end

  def makeMove(piece)
    raise ArgumentError unless isPieceCorrect?(piece) && isMovePossible?(piece)

    movePiece(piece[:from], piece[:to])
  end

  def isPieceCorrect?(piece)
    square = @grid[piece[:from][1]][piece[:from][0]]
    return square.role == piece[:role] && square.color == piece[:color]
  end

  def isMovePossible?(piece)
    possibleMoves(piece)
    return piece[:moves].include?(piece[:to]) &&
           canMoveHere?(piece[:to][0], piece[:to][1], piece[:color], piece[:takes?])
  end

  def movePiece(from, to)
    @grid[to[1]][to[0]] = @grid[from[1]][from[0]]
    @grid[from[1]][from[0]] = nil
  end
end
