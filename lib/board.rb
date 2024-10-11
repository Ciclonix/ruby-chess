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
  end

  # prepares the starting position of each piece
  def setPieces
    roles_order = %i[rook knight bishop queen king bishop knight rook]
    @grid[7] = roles_order.map { |role| role == :king ? @black_king : Piece.new(:black, role) }
    @grid[6] = Array.new(8) { Piece.new(:black, :pawn) }
    @grid[1] = Array.new(8) { Piece.new(:white, :pawn) }
    @grid[0] = roles_order.map { |role| role == :king ? @white_king : Piece.new(:white, role) }
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
    puts
  end

  def makeMove(piece)
    raise ArgumentError unless isPieceCorrect?(piece) && isMovePossible?(piece)

    movePiece(piece[:from], piece[:to])
    @grid[piece[:to][1]][piece[:to][0]].move
  end

  def isPieceCorrect?(piece)
    source = @grid[piece[:from][1]][piece[:from][0]]
    return false if source.nil?

    return source.role == piece[:role] && source.color == piece[:color]
  end

  def isMovePossible?(piece)
    return isMoveIncluded?(piece, @grid[piece[:from][1]][piece[:from][0]]) &&
           isWrittenCorrectly?(piece, @grid[piece[:to][1]][piece[:to][0]])
  end

  def isMoveIncluded?(piece, source)
    moves = source.possible_moves
    if source.role == :pawn
      moves = if piece[:takes?]
                moves.filter { |move| move[0] != piece[:from][0] }
              else
                moves.filter { |move| move[0] == piece[:from][0] }
              end
    end
    return moves.include?(piece[:to])
  end

  def isWrittenCorrectly?(piece, target)
    return piece[:takes?] ? target.color != piece[:color] : target.nil?
  end

  def movePiece(from, to)
    @grid[to[1]][to[0]] = @grid[from[1]][from[0]]
    @grid[from[1]][from[0]] = nil
  end

  def updateMoves
    check = false

    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        next unless square.instance_of?(Piece)

        piece = {
          from: [col_idx, row_idx],
          color: square.color,
          role: square.role,
          moves: []
        }
        possibleMoves(piece)
        square.possible_moves = piece[:moves]
        check = true if isCheck?(square)
      end
    end

    return check
  end

  def isCheck?(source)
    king = source.color == :white ? @black_king : @white_king
    source.possible_moves.each do |target|
      return true if @grid[target[1]][target[0]] == king
    end

    return false
  end
end
