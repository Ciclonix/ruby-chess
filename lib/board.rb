# frozen_string_literal: true

require_relative "piece"
require_relative "possible_moves"

class Board
  include PossibleMoves

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @white_king = Piece.new(:white, :king)
    @black_king = Piece.new(:black, :king)
    setPieces
    setPiecesPosition
  end

  # prepares the starting position of each piece
  def setPieces
    roles_order = %i[rook knight bishop queen king bishop knight rook]
    @grid[7] = roles_order.map { |role| role == :king ? @black_king : Piece.new(:black, role) }
    @grid[6] = Array.new(8) { Piece.new(:black, :pawn) }
    @grid[1] = Array.new(8) { Piece.new(:white, :pawn) }
    @grid[0] = roles_order.map { |role| role == :king ? @white_king : Piece.new(:white, role) }
  end

  def setPiecesPosition
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        next unless square.instance_of?(Piece)

        square.position = [col_idx, row_idx]
      end
    end
  end

  def printBoard
    puts "\n    a   b   c   d   e   f   g   h\n  -#{'----' * 8}"
    @grid.reverse.each_with_index do |row, idx|
      row_to_print = "#{8 - idx} |"
      row.each do |square|
        piece = square.nil? ? " " : square.getPiece
        row_to_print += " #{piece} |"
      end
      row_to_print += "\n  -#{'----' * 8}"
      puts row_to_print
    end
    puts
  end

  def makeMove(move)
    if move[:castle?]
      raise TypeError unless isCastlePossible?(move)

      castle(move)
    else
      raise TypeError unless isSourceCorrect?(move) && isMovePossible?(move)

      move(move[:source], move[:target])
    end
  end

  def castle(move)
    row = move[:source_color] == :white ? 0 : 7

    if move[:side] == :king
      rook_pos = [7, row]
      new_rook_pos = [5, row]
      new_king_pos = [6, row]
    else
      rook_pos = [0, row]
      new_rook_pos = [3, row]
      new_king_pos = [2, row]
    end

    movePiece([4, row], new_king_pos)
    movePiece(rook_pos, new_rook_pos)
    updatePosition(new_king_pos)
    updatePosition(new_rook_pos)
  end

  def isCastlePossible?(move)
    row = move[:source_color] == :white ? 0 : 7
    if move[:side] == :queen
      rook_col = 0
      idx = -1
    else
      rook_col = 7
      idx = 1
    end
    return true if validCastle?(@grid[row][4], @grid[row][rook_col], row, idx)

    return false
  end

  def validCastle?(king, rook, row, idx)
    return !king.nil? && !rook.nil? && king.first_move && rook.first_move &&
           areBeingAttacked?(king, row, idx) && areFree?(row, idx)
  end

  def areBeingAttacked?(king, row, idx)
    return getAttackers(king).empty? && getAttackers([4 + idx, row], king.color).empty? &&
           getAttackers([4 + idx * 2, row], king.color).empty?
  end

  def areFree?(row, idx)
    return isFree?(4 + idx, row) && isFree?(4 + idx * 2, row) && (idx == 1 || isFree?(1, row))
  end

  def move(source, target)
    movePiece(source, target)
    updatePosition(target)
  end

  def isSourceCorrect?(move)
    source = @grid[move[:source][1]][move[:source][0]]
    return false if source.nil?

    return source.role == move[:source_role] && source.color == move[:source_color]
  end

  def isMovePossible?(move)
    return isMoveIncluded?(move, @grid[move[:source][1]][move[:source][0]]) &&
           isWrittenCorrectly?(move, @grid[move[:target][1]][move[:target][0]])
  end

  def isMoveIncluded?(move, source)
    moves = source.possible_moves
    return moves[1].include?(move[:target]) if move[:takes?]

    return moves[0].include?(move[:target])
  end

  def isWrittenCorrectly?(move, target)
    return move[:takes?] ? target.color != move[:source_color] : target.nil?
  end

  def movePiece(source, target)
    @grid[target[1]][target[0]] = @grid[source[1]][source[0]]
    @grid[source[1]][source[0]] = nil
  end

  def updatePosition(target)
    @grid[target[1]][target[0]].first_move = false
    @grid[target[1]][target[0]].position = target
  end

  def updateMoves
    @grid.each do |row|
      row.each do |piece|
        next unless piece.instance_of?(Piece)

        piece.possible_moves = [[], []]
        possibleMoves(piece)
      end
    end
    return isCheck?
  end

  def isCheck?
    if !getAttackers(@white_king).empty?
      return @white_king
    elsif !getAttackers(@black_king).empty?
      return @black_king
    else
      return nil
    end
  end

  def isCheckmate?(king)
    attackers = getAttackers(king)
    return !(canEatPiece?(attackers) || canBlockAttack?(king, attackers) || canMoveKing?(king))
  end

  def getAttackers(target, color = nil)
    attackers = []
    target_position = target.instance_of?(Array) ? target : target.position
    @grid.each do |row|
      row.each do |piece|
        next unless validAttacker?(piece, target, color)

        attackers << piece if isPieceAttacking?(piece, target_position)
      end
    end
    return attackers
  end

  def validAttacker?(piece, target, color)
    return piece.instance_of?(Piece) && piece != target && piece.color != color
  end

  def isPieceAttacking?(piece, target_position)
    return (piece.role != :pawn && piece.possible_moves.flatten(1).include?(target_position)) ||
           piece.possible_moves[1].include?(target_position)
  end

  def canEatPiece?(target)
    return false if target.length > 1

    return !getAttackers(target[0]).empty?
  end

  def canBlockAttack?(king, attackers)
    target = attackers[0]
    return false if attackers.length > 1 || target.role == :knight

    delta_x = king.position[0] - target.position[0]
    delta_y = king.position[1] - target.position[1]
    return canBeBlocked?(target, delta_x, delta_y)
  end

  def canBeBlocked?(target, delta_x, delta_y)
    base_x, base_y = target.position
    diff = delta_x.zero? ? delta_y : delta_x
    diff.abs.times do |idx|
      next if idx.zero?

      x = base_x + idx * (delta_x <=> 0)
      y = base_y + idx * (delta_y <=> 0)
      return true unless getAttackers([x, y], target.color).empty?
    end

    return false
  end

  def canMoveKing?(king)
    return king.possible_moves.flatten(1).any { |move| canKingMoveHere?(king, move) }
  end

  def canKingMoveHere?(king, move)
    temp_position = king.position
    temp_piece = @grid[move[1]][move[0]]
    moveKing(king, move)
    attackers = getAttackers(king)
    moveKing(king, temp_position)
    @grid[move[1]][move[0]] = temp_piece
    return attackers.empty?
  end

  def moveKing(king, target)
    movePiece(king.position, target)
    king.position = target
  end
end
