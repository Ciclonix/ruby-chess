# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"

class Chess
  include NotationInterpreter

  def newGame
    @board = Board.new
  end

  def inputMove(color)
    print "#{color}, digit your move: "
    piece = interpret(gets.chomp)
    raise ArgumentError unless piece

    piece[:color] = (color == "White" ? :white : :black)
    return piece
  rescue ArgumentError
    puts "Invalid move, retry"
    retry
  end
end
