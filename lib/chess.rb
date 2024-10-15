# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"

class Chess
  include NotationInterpreter

  def inputMove(color)
    print "#{color}, digit your move: "
    piece = interpret(gets.chomp)
    raise ArgumentError unless piece

    piece[:color] = (color == "White" ? :white : :black)
    return piece
  end

  def turn(color)
    piece = inputMove(color)
    @board.makeMove(piece)
    @board.printBoard
  rescue ArgumentError
    puts "Invalid move, retry"
    retry
  end

  def gameLoop
    @board.printBoard
    loop do
      puts "Check" if @board.updateMoves
      turn("White")
      puts "Check" if @board.updateMoves
      turn("Black")
    end
  end

  def startGame
    @board = Board.new
    gameLoop
  end
end

a = Chess.new
a.startGame
