# frozen_string_literal: true

# This class is used to make each piece on the board
# It contains it's personal information (color, role, ecc.), giving external access to some of it
# It contains an hash with each possible piece in string form, which can be accessed with a method

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
