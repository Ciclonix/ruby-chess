# frozen_string_literal: true

require_relative "piece"

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setPieces
  end

  # prepares the starting position of each piece
  def setPieces
    roles_order = %i[rook knight bishop queen king bishop knight rook]
    @grid[0] = roles_order.map { |role| Piece.new(:black, role) }
    @grid[1] = Array.new(8) { Piece.new(:black, :pawn) }
    @grid[6] = Array.new(8) { Piece.new(:white, :pawn) }
    @grid[7] = roles_order.map { |role| Piece.new(:white, role) }
  end

  def printBoard
    puts "    a   b   c   d   e   f   g   h\n  -#{'----' * 8}"
    @grid.each_with_index do |row, idx|
      row_to_print = "#{8 - idx} |"
      row.each do |square|
        piece = square.nil? ? " " : square.getPiece
        row_to_print += " #{piece} |"
      end
      row_to_print += "\n  -#{'----' * 8}"
      puts row_to_print
    end
  end

  def isPiece?(position, piece)
    return @grid[position[1]][position[0]].role == piece
  end
end
