# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"

class Chess
  include NotationInterpreter

  def newGame
    @board = Board.new
  end
end
