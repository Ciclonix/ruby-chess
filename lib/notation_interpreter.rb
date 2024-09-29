# frozen_string_literal: true

module NotationInterpreter
  PIECES = "RNBQK"
  ROWS = "abcdefgh"
  COLS = "12345678"

  # ex. Nf3xe5 Bb5xc6 d7xc6
  def interpret(move)
    @move = move
    p moveValid?
  end

  def moveValid?
    idx = isPieceSpecified? ? 1 : 0
    return isLengthValid? &&
           ROWS.include?(@move[idx]) &&
           COLS.include?(@move[idx + 1]) &&
           ROWS.include?(@move[-2]) &&
           COLS.include?(@move[-1])
  end

  def isPieceSpecified?
    return PIECES.include?(@move[0])
  end

  def isLengthValid?
    length = 4
    length += 1 if @move[-3] == "x"
    length += 1 if isPieceSpecified?
    return @move.length == length
  end
end
