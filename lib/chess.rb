# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"

class Chess
  include NotationInterpreter

  def newGame
    @board = Board.new
  end

  def inputMove
    print "Digit your move: "
    move = interpret(gets.chomp)
    raise ArgumentError unless move

    return move
  rescue ArgumentError
    puts "Invalid move, retry"
    retry
  end
end
