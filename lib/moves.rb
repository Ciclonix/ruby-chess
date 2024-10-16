# frozen_string_literal: true

module Moves
  def isFree?(col, row)
    return @grid[row][col].nil?
  end

  def canEat?(col, row, color)
    target = @grid[row][col]
    return false if target.nil?

    return target.color != color
  end

  def betweenLimits?(col, row)
    return row.between?(0, 7) && col.between?(0, 7)
  end

  def addMove(x, y, piece)
    return unless betweenLimits?(x, y)

    if isFree?(x, y)
      piece.possible_moves[0] << [x, y]
      return true
    elsif canEat?(x, y, piece.color)
      piece.possible_moves[1] << [x, y]
    end

    return false
  end

  def possibleMovesInRow(piece)
    x = piece.position[0]

    7.times do |idx|
      y = piece.position[1] + idx + 1
      break unless addMove(x, y, piece)
    end

    7.times do |idx|
      y = piece.position[1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def possibleMovesInCol(piece)
    y = piece.position[1]

    7.times do |idx|
      x = piece.position[0] + idx + 1
      break unless addMove(x, y, piece)
    end

    7.times do |idx|
      x = piece.position[0] - idx - 1
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
      x = piece.position[0] - idx - 1
      y = piece.position[1] + idx + 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalUpRight(piece)
    7.times do |idx|
      x = piece.position[0] + idx + 1
      y = piece.position[1] + idx + 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalDownLeft(piece)
    7.times do |idx|
      x = piece.position[0] - idx - 1
      y = piece.position[1] - idx - 1
      break unless addMove(x, y, piece)
    end
  end

  def checkDiagonalDownRight(piece)
    7.times do |idx|
      x = piece.position[0] + idx + 1
      y = piece.position[1] - idx - 1
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

  def possibleMovesFromList(piece, moves)
    moves.each do |move|
      x = piece.position[0] + move[0]
      y = piece.position[1] + move[1]
      addMove(x, y, piece)
    end
  end

  def possiblePawnMoves(piece)
    factor = piece.color == :white ? 1 : -1
    pawnMoves(piece, factor)
    pawnTakingMoves(piece, factor)
  end

  def pawnTakingMoves(piece, factor)
    y = piece.position[1] + factor
    [1, -1].each do |x_change|
      x = piece.position[0] + x_change
      piece.possible_moves[1] << [x, y] if betweenLimits?(x, y) && isFree?(x, y)
    end
  end

  def pawnMoves(piece, factor)
    x = piece.position[0]
    moves = piece.first_move ? [1, 2] : [1]
    moves.each do |y_change|
      y = piece.position[1] + (y_change * factor)
      piece.possible_moves[0] << [x, y] if betweenLimits?(x, y) && isFree?(x, y)
    end
  end

  def possibleMoves(piece)
    case piece.role
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
end
