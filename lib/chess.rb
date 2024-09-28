# frozen_string_literal: true

require_relative "board"

class Chess
  def newGame
    @board = Board.new
  end
end
