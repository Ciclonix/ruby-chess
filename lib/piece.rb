# frozen_string_literal: true

class Piece
  PIECES = {black: { knight: '♘', queen: '♕', king: '♔', rook: '♖', bishop: '♗', pawn: '♙' },
            white: { knight: '♞', queen: '♛', king: '♚', rook: '♜', bishop: '♝', pawn: '♟' }}.freeze

  def initialize(color, role)
    @color = color
    @role = role
  end

  def getPiece
    return PIECES[@color][@role]
  end
end
