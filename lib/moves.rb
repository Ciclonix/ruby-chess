# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

module Moves
  def canTake?(row, col, color)
    square = @grid[row][col]
    return false if square.nil?

    return square.color != color
  end

  def isFree?(row, col)
    return @grid[row][col].nil?
  end

  def canMoveHere?(row, col, color, is_taking)
    return is_taking ? canTake?(row, col, color) : isFree?(row, col)
  end

  def validMove?(row, col, color, is_taking)
    row.between?(0, 7) && col.between?(0, 7) && canMoveHere?(row, col, color, is_taking)
  end

  def addMove(x, y, piece)
    if canMoveHere?(x, y, piece[:color])
      piece[:moves] << [x, y]
      return true
    elsif canMoveHere?(x, y, piece[:color], true)
      piece[:moves] << [x, y]
    end
    return false
  end

  def possibleMovesInRow(piece)
    x = piece[:from][0]

    7.times do |idx|
      y = piece[:from][1] + idx + 1
      break unless addMove(x, y, piece)
    end

    7.times do |idx|
      y = piece[:from][1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def possibleMovesInCol(piece)
    y = piece[:from][1]

    7.times do |idx|
      x = piece[:from][0] + idx + 1
      break unless addMove(x, y, piece)
    end

    7.times do |idx|
      x = piece[:from][0] - idx - 1
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
      x = piece[:from][0] + idx + 1
      y = piece[:from][1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalUpRight(piece)
    7.times do |idx|
      x = piece[:from][0] + idx + 1
      y = piece[:from][1] + idx + 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalDownLeft(piece)
    7.times do |idx|
      x = piece[:from][0] - idx - 1
      y = piece[:from][1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalDownRight(piece)
    7.times do |idx|
      x = piece[:from][0] - idx - 1
      y = piece[:from][1] + idx + 1
      break unless addMove(x, y, piece)
    end
  end

  def possibleKnightMoves(piece)
    moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
    moves.each do |move|
      x = piece[:from][0] + move[0]
      y = piece[:from][1] + move[1]
      piece[:moves] << [x, y] if validMove?(x, y, piece[:color], piece[:takes?])
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
      x = piece[:from][0] + move[0]
      y = piece[:from][1] + move[1]
      piece[:moves] << [x, y] if validMove?(x, y, piece[:color], piece[:takes?])
    end
  end

  def possibleMoves(piece)
    case piece[:role]
    when :rook
      possibleRookMoves(piece)
    when :knight
      possibleKnightMoves(piece)
    when :bishop
      possibleBishopMoves(piece)
    when :queen
      possibleQueenMoves(piece)
    when :king
      possibleKingMoves(piece)
    end
  end
end

# rubocop:enable Metrics/ModuleLength
