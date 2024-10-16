# frozen_string_literal: true

require_relative "piece"
require_relative "moves"

class Board
  include Moves

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
    raise TypeError unless isSourceCorrect?(move) && isMovePossible?(move)

    movePiece(move[:source], move[:target])
    updatePosition(move[:target])
    @grid[move[:target][1]][move[:target][0]].move
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
    @grid[target[1]][target[0]].position = target
  end

  def updateMoves
    check = false
    @grid.each do |row|
      row.each do |piece|
        next unless piece.instance_of?(Piece)

        possibleMoves(piece)
        check = true if isCheck?(piece)
      end
    end
    return check
  end

  def isCheck?(source)
    king = source.color == :white ? @black_king : @white_king
    source.possible_moves[1].each do |target|
      return true if king.position == target
    end

    return false
  end
end
