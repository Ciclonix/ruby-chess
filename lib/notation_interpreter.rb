# frozen_string_literal: true

module NotationInterpreter
  PIECES = { "R" => :rook, "N" => :knight, "B" => :bishop, "Q" => :queen, "K" => :king, "P" => :pawn }.freeze
  COLS = "abcdefgh"
  ROWS = "12345678"

  def interpret(move)
    @move = move
    specifyPiece
    return false unless isMoveValid?

    return {
      from: [COLS.index(move[1]), move[2].to_i - 1],
      to: [COLS.index(move[-2]), move[-1].to_i - 1],
      role: PIECES[move[0]],
      takes?: isTaking?,
      moves: []
    }
  end

  def specifyPiece
    return if PIECES.include?(@move[0])

    @move.prepend("P")
  end

  def isMoveValid?
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
    return @move.length == isTaking? ? 6 : 5
  end
end
