# frozen_string_literal: true

# This module function is to transform a string written using long algebraic notation to
# an hash containing values which will be used to check it's validity and execute it after

module NotationInterpreter
  PIECES = { "R" => :rook, "N" => :knight, "B" => :bishop, "Q" => :queen, "K" => :king, "P" => :pawn }.freeze
  COLS = "abcdefgh"
  ROWS = "12345678"

  # Main method of the module
  # Checks if the argument string is written in the standard long algebraic notation and
  # returns an hash containing the interpreted move
  def interpret(move)
    @move = move
    return @castle if isCastle? # if it's a castle it returns a different hash
    return nil unless isMoveValid?

    return {
      source: [COLS.index(move[1]), ROWS.index(move[2])],
      target: [COLS.index(move[-2]), ROWS.index(move[-1])],
      source_role: PIECES[move[0]],
      takes?: isTaking?,
      castle?: false
    }
  end

  def specifyPiece
    return if PIECES.include?(@move[0])

    @move.prepend("P")
  end

  def isMoveValid?
    specifyPiece
    return isLengthValid? &&
           COLS.include?(@move[1]) &&
           ROWS.include?(@move[2]) &&
           COLS.include?(@move[-2]) &&
           ROWS.include?(@move[-1])
  end

  def isTaking?
    return @move[-3] == "x"
  end

  def isLengthValid?
    return @move.length == (isTaking? ? 6 : 5)
  end

  # Checks if the move is a castle
  # If it is, it sets the value of @castle to an hash which will be returned as the interpreted move
  def isCastle?
    if %w[O-O 0-0].include?(@move)
      @castle = {
        castle?: true,
        side: :king
      }
      return true
    elsif %w[O-O-O 0-0-0].include?(@move)
      @castle = {
        castle?: true,
        side: :queen
      }
      return true
    end

    return false
  end
end
