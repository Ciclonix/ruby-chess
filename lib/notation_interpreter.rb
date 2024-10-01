# frozen_string_literal: true

module NotationInterpreter
  PIECES = { "R" => :rook, "N" => :knight, "B" => :bishop, "Q" => :queen, "K" => :king, "P" => :pawn }.freeze
  ROWS = "abcdefgh"
  COLS = "12345678"

  def interpret(move)
    @move = move
    specifyPiece
    return false unless moveValid?

    @move[1] = ROWS.index(@move[1])
    @move[-2] = ROWS.index(@move[-2])
    return { start: move[2..1], end: move[-1..-2], piece: PIECES[move[0]], takes?: isTaking? }
  end

  def specifyPiece
    return if PIECES.include?(@move[0])

    @move.prepend("P")
  end

  def isMoveValid?
    return isLengthValid? &&
           ROWS.include?(@move[1]) &&
           COLS.include?(@move[2]) &&
           ROWS.include?(@move[-2]) &&
           COLS.include?(@move[-1])
  end

  def isTaking?
    return @move[-3] == "x"
  end

  def isLengthValid?
    return @move.length == isTaking? ? 6 : 5
  end
end
