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

  def isRole?(position, role)
    return @grid[position[0]][position[1]].role == role
  end

  def isColor?(position, color)
    return @grid[position[0]][position[1]].color == color
  end

  def possibleKnightMoves(position)
    moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
    result = []
    moves.each do |move|
      x = position[0] + move[0]
      y = position[1] + move[1]
      result << [x, y] if x.between?(0, 7) && y.between?(0, 7)
    end
    return result
  end
end
