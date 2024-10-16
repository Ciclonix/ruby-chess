# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"

class Chess
  include NotationInterpreter

  def inputMove(color)
    print "#{color}, digit your move: "
    piece = interpret(gets.chomp)
    raise TypeError unless piece

    piece[:source_color] = (color == "White" ? :white : :black)
    return piece
  end

  def turn(color)
    move = inputMove(color)
    @board.makeMove(move)
    @board.printBoard
  rescue TypeError
    puts "Invalid move, retry"
    retry
  end

  def gameLoop
    @board.printBoard
    loop do
      checkWin("Black") if @board.updateMoves
      turn("White")
      checkWin("White") if @board.updateMoves
      turn("Black")
    end
  end

  def startGame
    @board = Board.new
    gameLoop
  end

  def checkWin(color)
    if @board.isCheckmate?(color)
      puts "#{color} checkmates his opponent!"
    else
      puts "Check"
    end
  end
end

a = Chess.new
a.startGame
