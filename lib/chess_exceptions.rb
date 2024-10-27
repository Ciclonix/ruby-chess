# frozen_string_literal: true

# This module contains custom exceptions made to manage each special case that can happen
# if the move the user inputs is not written in algebraic notation

module ChessExceptions
  class ChessException < StandardError; end

  class MoveNotPossible < ChessException; end

  class MoveNotValid < ChessException; end

  class SaveLoadData < ChessException; end
end
