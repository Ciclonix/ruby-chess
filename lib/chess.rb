# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"

class Chess
  include NotationInterpreter

  def inputMove(color)
    print "#{color.capitalize}, digit your move: "
    piece = interpret(gets.chomp)
    raise TypeError unless piece

    piece[:source_color] = color
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
      break if isWin?

      turn(:white)
      break if isWin?

      turn(:black)
    end
  end

  def startGame
    @board = Board.new
    puts "Use long algebraic notation for your moves"
    gameLoop
  end

  def isWin?
    king = @board.updateMoves
    return if king.nil?

    if @board.isCheckmate?(king)
      puts "#{king.color.capitalize} loses for checkmate!"
      return true
    else
      puts "Check on #{king.color}'s king"
      return false
    end
  end
end

a = Chess.new
a.startGame
