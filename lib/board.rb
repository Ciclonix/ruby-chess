# frozen_string_literal: true

class Board
  BLACK_PIECES = { Knight: '♘', Queen: '♕', King: '♔', Rook: '♖', Bishop: '♗', Pawn: '♙' }.freeze
  WHITE_PIECES = { Knight: '♞', Queen: '♛', King: '♚', Rook: '♜', Bishop: '♝', Pawn: '♟' }.freeze

  def initialize
    @board = Array.new(8) { Array.new(8) }
    setBlackPieces
    setWhitePieces
  end

  def setBlackPieces
    @board[0] = [BLACK_PIECES[:Rook], BLACK_PIECES[:Knight], BLACK_PIECES[:Bishop], BLACK_PIECES[:Queen],
                 BLACK_PIECES[:King], BLACK_PIECES[:Bishop], BLACK_PIECES[:Knight], BLACK_PIECES[:Rook]]
    @board[1] = Array.new(8) { BLACK_PIECES[:Pawn] }
  end

  def setWhitePieces
    @board[7] = [WHITE_PIECES[:Rook], WHITE_PIECES[:Knight], WHITE_PIECES[:Bishop], WHITE_PIECES[:Queen],
                 WHITE_PIECES[:King], WHITE_PIECES[:Bishop], WHITE_PIECES[:Knight], WHITE_PIECES[:Rook]]
    @board[6] = Array.new(8) { WHITE_PIECES[:Pawn] }
  end

  def printBoard
    puts "    a   b   c   d   e   f   g   h"
    puts "  -#{'----' * 8}"
    @board.each_with_index do |row, idx|
      row_to_print = "#{8 - idx} |"
      row.each do |square|
        piece = square.nil? ? " " : square
        row_to_print += " #{piece} |"
      end
      row_to_print += "\n  -#{'----' * 8}"
      puts row_to_print
    end
  end
end
