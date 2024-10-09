# frozen_string_literal: true

class Piece
  attr_reader :color, :role, :first_move
  attr_accessor :possible_moves

  PIECES = {black: { knight: '♘', queen: '♕', king: '♔', rook: '♖', bishop: '♗', pawn: '♙' },
            white: { knight: '♞', queen: '♛', king: '♚', rook: '♜', bishop: '♝', pawn: '♟' }}.freeze

  def initialize(color, role)
    @color = color
    @role = role
    @first_move = true
    @possible_moves = []
  end

  def getPiece
    return PIECES[@color][@role]
  end

  def move
    @first_move = false
  end
end
