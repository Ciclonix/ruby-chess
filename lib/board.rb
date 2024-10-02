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

  def isRole?(pos, role)
    square = @grid[pos[0]][pos[1]]
    return !square.nil? && square.role == role
  end

  def isColor?(pos, color)
    square = @grid[pos[0]][pos[1]]
    return !square.nil? && square.color == color
  end

  def isFree?(pos)
    return @grid[pos[0]][pos[1]].nil?
  end

  def canMoveHere?(row, col, color, is_taking)
    return row.between?(0, 7) && col.between?(0, 7) && (is_taking ? !isColor?([row, col], color) : isFree?([row, col]))
  end

  def possibleMovesInRow(row, col, color, is_taking, result)
    7.times do |idx|
      y = col + idx + 1
      break unless canMoveHere?(row, y, color, is_taking)

      result << [row, y]
    end

    7.times do |idx|
      y = col - idx - 1
      break unless canMoveHere?(row, y, color, is_taking)

      result << [row, y]
    end
  end

  def possibleMovesInCol(row, col, color, is_taking, result)
    7.times do |idx|
      x = row + idx + 1
      break unless canMoveHere?(x, col, color, is_taking)

      result << [x, col]
    end

    7.times do |idx|
      x = row - idx - 1
      break unless canMoveHere?(x, col, color, is_taking)

      result << [x, col]
    end
  end

  def possibleKnightMoves(pos, color, is_taking, result = [])
    moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
    moves.each do |move|
      x = pos[0] + move[0]
      y = pos[1] + move[1]
      result << [x, y] if canMoveHere?(x, y, color, is_taking)
    end
    return result
  end

  def possibleRookMoves(pos, color, is_taking, result = [])
    row, col = pos
    possibleMovesInRow(row, col, color, is_taking, result)
    possibleMovesInCol(row, col, color, is_taking, result)
    return result
  end
end
