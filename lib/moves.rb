# frozen_string_literal: true

module Moves
  def canTake?(col, row, color)
    square = @grid[row][col]
    return false if square.nil?

    return square.color != color
  end

  def isFree?(col, row)
    return @grid[row][col].nil?
  end

  def canMoveHere?(col, row, color, is_taking)
    return is_taking ? canTake?(col, row, color) : isFree?(col, row)
  end

  def validMove?(col, row, color, is_taking = false)
    return row.between?(0, 7) && col.between?(0, 7) && canMoveHere?(col, row, color, is_taking)
  end

  def addMove(x, y, piece)
    if validMove?(x, y, piece[:color])
      piece[:moves] << [x, y]
      return true
    elsif validMove?(x, y, piece[:color], true)
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
      x = piece[:from][0] - idx - 1
      y = piece[:from][1] + idx + 1
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
      x = piece[:from][0] + idx + 1
      y = piece[:from][1] - idx - 1
      break unless addMove(x, y, piece)
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
    possibleMovesFromList(piece, moves)
  end

  def possibleKnightMoves(piece)
    moves = [[-1, -2], [1, 2], [-1, 2], [1, -2], [-2, -1], [2, 1], [-2, 1], [2, -1]]
    possibleMovesFromList(piece, moves)
  end

  def possiblePawnMoves(piece)
    factor = piece[:color] == :white ? 1 : -1
    moves = if piece[:takes?]
              [[1, 1], [-1, 1]]
            elsif isFirstMove?(piece[:from][0], piece[:from][1])
              [[0, 1], [0, 2]]
            else
              [[0, 1]]
            end
    possibleMovesFromList(piece, moves, factor)
  end

  def possibleMovesFromList(piece, moves, factor = 1)
    moves.each do |move|
      x = piece[:from][0] + move[0]
      y = piece[:from][1] + move[1] * factor
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
    when :pawn
      possiblePawnMoves(piece)
    end
  end

  def isFirstMove?(col, row)
    return @grid[row][col].first_move
  end
end
