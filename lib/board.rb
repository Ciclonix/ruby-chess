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

  def canMoveHere?(row, col, color, is_taking = false)
    return row.between?(0, 7) && col.between?(0, 7) && (is_taking ? !isColor?([row, col], color) : isFree?([row, col]))
  end

  def addMove(x, y, piece)
    if canMoveHere?(x, y, piece[:color])
      piece[:moves] << [x, y]
      return true
    elsif canMoveHere?(x, y, piece[:color], piece[:takes?])
      piece[:moves] << [x, y]
    end
    return false
  end

  def possibleMovesInRow(piece)
    x = piece[:pos][0]

    7.times do |idx|
      y = piece[:pos][1] + idx + 1
      break unless addMove(x, y, piece)
    end

    7.times do |idx|
      y = piece[:pos][1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def possibleMovesInCol(piece)
    y = piece[:pos][1]

    7.times do |idx|
      x = piece[:pos][0] + idx + 1
      break unless addMove(x, y, piece)
    end

    7.times do |idx|
      x = piece[:pos][0] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def possibleMovesInDiag(piece)
    checkDiagonalUpLeft(piece)
    checkDiagonalUpRight(piece)
    checkDiagonalDownLeft(piece)
    checkDiagonalDownRight(piece)
  end

  def checkDiagonalUpLeft(piece)
    7.times do |idx|
      x = piece[:pos][0] + idx + 1
      y = piece[:pos][1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalUpRight(piece)
    7.times do |idx|
      x = piece[:pos][0] + idx + 1
      y = piece[:pos][1] + idx + 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalDownLeft(piece)
    7.times do |idx|
      x = piece[:pos][0] - idx - 1
      y = piece[:pos][1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalDownRight(piece)
    7.times do |idx|
      x = piece[:pos][0] - idx - 1
      y = piece[:pos][1] + idx + 1
      break unless addMove(x, y, piece)
    end
  end

  def possibleKnightMoves(piece)
    moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
    moves.each do |move|
      x = piece[:pos][0] + move[0]
      y = piece[:pos][1] + move[1]
      piece[:moves] << [x, y] if canMoveHere?(x, y, piece[:color], piece[:takes?])
    end
  end

  def possibleRookMoves(piece)
    possibleMovesInRow(piece)
    possibleMovesInCol(piece)
  end

  def possibleBishopMoves(piece)
    possibleMovesInDiag(piece)
  end

  def possibleQueenMoves(piece)
    possibleMovesInRow(piece)
    possibleMovesInCol(piece)
    possibleMovesInDiag(piece)
  end

  def possibleKingMoves(piece)
    moves = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]
    moves.each do |move|
      x = piece[:pos][0] + move[0]
      y = piece[:pos][1] + move[1]
      piece[:moves] << [x, y] if canMoveHere?(x, y, piece[:color], piece[:takes?])
    end
  end
end
