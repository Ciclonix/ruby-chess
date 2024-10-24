# frozen_string_literal: true

module ChessExceptions
  class ChessException < StandardError; end

  class MoveNotPossible < ChessException; end

  class MoveNotValid < ChessException; end

  class SaveLoadData < ChessException; end
end
