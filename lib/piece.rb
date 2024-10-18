# frozen_string_literal: true

class Piece
  attr_accessor :possible_moves, :position, :first_move
  attr_reader :color, :role

  PIECES = {black: { knight: '♘', queen: '♕', king: '♔', rook: '♖', bishop: '♗', pawn: '♙' },
            white: { knight: '♞', queen: '♛', king: '♚', rook: '♜', bishop: '♝', pawn: '♟' }}.freeze

  def initialize(color, role)
    @color = color
    @role = role
    @first_move = true
    @possible_moves = [[], []]
    @position = []
  end

  def getPiece
    return PIECES[@color][@role]
  end
end
