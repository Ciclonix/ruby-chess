# frozen_string_literal: true

require_relative "piece"
require_relative "possible_moves"
require_relative "chess_exceptions"
require "yaml"

class Board
  include PossibleMoves
  include ChessExceptions

  attr_reader :last_turn

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @white_king = Piece.new(:white, :king)
    @black_king = Piece.new(:black, :king)
    @last_turn = :black
    @no_capture_count = 0
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
    puts "\n     a   b   c   d   e   f   g   h\n"\
         "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"
    @grid.reverse.each_with_index do |row, idx|
      row_to_print = " #{8 - idx} │"
      row.each do |square|
        piece = square.nil? ? " " : square.getPiece
        row_to_print += " #{piece} │"
      end
      row_to_print += if idx == 7
                        "\n   └───┴───┴───┴───┴───┴───┴───┴───┘"
                      else
                        "\n   ├───┼───┼───┼───┼───┼───┼───┼───┤"
                      end
      puts row_to_print
    end
    puts
  end

  def makeMove(move)
    if move[:castle?]
      raise MoveNotPossible unless isCastlePossible?(move)

      castle(move)
    else
      raise MoveNotPossible unless isSourceCorrect?(move) && isMovePossible?(move)

      move(move[:source], move[:target])
      @no_capture_count = -1 if move[:takes?]
    end
    @no_capture_count += 1
    @last_turn = move[:source_color]
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
    rook_col = move[:side] == :queen ? 0 : 7
    return true if validCastle?(@grid[row][4], @grid[row][rook_col], row, rook_col <=> 4)

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
    source = @grid[move[:source][1]][move[:source][0]]
    target = @grid[move[:target][1]][move[:target][0]]
    return isMoveIncluded?(move, source) &&
           isWrittenCorrectly?(move, target) &&
           isMoveLegal?(source, move[:target])
  end

  def isMoveIncluded?(move, source)
    moves = source.possible_moves
    return moves[1].include?(move[:target]) if move[:takes?]

    return moves[0].include?(move[:target])
  end

  def isWrittenCorrectly?(move, target)
    return move[:takes?] ? target.color != move[:source_color] : target.nil?
  end

  def isMoveLegal?(source, target)
    temp_piece = @grid[target[1]][target[0]]
    temp_position = source.position
    tempMove(source, target)
    check = updateMoves
    tempMove(source, temp_position)
    @grid[target[1]][target[0]] = temp_piece
    updateMoves
    return check != (source.color == :white ? @white_king : @black_king)
  end

  def tempMove(source, target_position)
    movePiece(source.position, target_position)
    source.position = target_position
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
    @grid.flatten.compact.each do |piece|
      piece.possible_moves = [[], []]
      possibleMoves(piece)
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
    @grid.flatten.compact.each do |piece|
      next unless piece.color != color

      attackers << piece if isPieceAttacking?(piece, target_position)
    end
    return attackers
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
      return true unless getAttackersNoKings([x, y], target.color).empty?
    end

    return false
  end

  def getAttackersNoKings(target, color)
    return getAttackers(target, color).filter { |piece| piece.role != :king }
  end

  def canMoveKing?(king)
    return king.possible_moves.flatten(1).any? { |move| isMoveLegal?(king, move) }
  end

  def saveData
    save_data = YAML.dump({
                            grid: @grid,
                            last_turn: @last_turn,
                            no_capture_count: @no_capture_count
                          })
    File.open("save_data.yml", "w") { |file| file.write(save_data) }
  end

  def loadData
    save_data = YAML.load(File.read("save_data.yml"), permitted_classes: [Symbol, Piece])
    @grid = save_data[:grid]
    @last_turn = save_data[:last_turn]
    @no_capture_count = save_data[:no_capture_count]
  rescue Errno::ENOENT
    puts "Save file not found!"
  end

  def isDraw?
    return onlyKingsLeft? || noLegalMoves? || (@no_capture_count == 50)
  end

  def onlyKingsLeft?
    return @grid.flatten.compact.length == 2
  end

  def noLegalMoves?
    return @grid.flatten.compact.none? do |piece|
      piece.possible_moves.flatten(1).any? { |move| piece.color != @last_turn && isMoveLegal?(piece, move) }
    end
  end
end
