# frozen_string_literal: true

require_relative "board"
require_relative "notation_interpreter"
require_relative "chess_exceptions"

class Chess
  include NotationInterpreter
  include ChessExceptions

  def inputMove(color)
    print "#{color.capitalize}, digit your move: "
    move = gets.chomp
    raise SaveLoadData if saveLoadData?(move)

    move = interpret(move)
    raise MoveNotValid unless move

    move[:source_color] = color
    return move
  end

  def turn(color)
    move = inputMove(color)
    @board.makeMove(move)
    @board.printBoard
  rescue MoveNotValid
    puts "Move not valid, retry\n\n"
    retry
  rescue MoveNotPossible
    puts "Move not possible/legal, retry\n\n"
    retry
  rescue SaveLoadData
    @board.printBoard
  end

  def gameLoop
    @board.printBoard
    loop do
      break if endGame?

      color = @board.last_turn == :white ? :black : :white
      turn(color)
    end
  end

  def startGame
    @board = Board.new
    puts "Use long algebraic notation for your moves\n"\
         "You can save anytime by digiting 'save'\n"\
         "If you want to load a previous game digit 'load'"
    gameLoop
  end

  def endGame?
    king = @board.updateMoves
    if @board.isDraw?
      puts "It's a draw!"
      return true
    elsif king.nil?
      return false
    elsif @board.isCheckmate?(king)
      puts "#{king.color.capitalize} loses for checkmate!"
      return true
    else
      puts "Check on #{king.color}'s king"
      return false
    end
  end

  def saveLoadData?(move)
    if move == "save"
      @board.saveData
      return true
    elsif move == "load"
      @board.loadData
      return true
    end

    return false
  end
end

a = Chess.new
a.startGame
