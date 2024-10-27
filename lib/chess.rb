# frozen_string_literal: true

# Main class of the project
# Manages turns, custom errors and game ending scenarios

require_relative "board"
require_relative "notation_interpreter"
require_relative "chess_exceptions"

class Chess
  include NotationInterpreter
  include ChessExceptions

  # Gets a move from the user
  # If if it saves of loads the game it does so and raises SaveLoadData
  # Uses the module NotationInterpreter on the move and raises MoveNotValid if it's nil
  def inputMove(color)
    print "#{color.capitalize}, digit your move: "
    move = gets.chomp
    raise SaveLoadData if saveLoadData?(move)

    move = interpret(move)
    raise MoveNotValid if move.nil?

    move[:source_color] = color
    return move
  end

  # Turn of the specified color
  # Gets a move and uses a Board object to check and do it
  # Manages each possible custom error it may be raised during the checks
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

  # Start and main loop of the game
  def gameLoop
    @board = Board.new
    puts "Use long algebraic notation for your moves\n" \
         "You can save anytime by digiting 'save'\n" \
         "If you want to load a previous game digit 'load'"
    @board.printBoard
    loop do
      break if endGame?

      color = @board.last_turn == :white ? :black : :white
      turn(color)
    end
  end

  # Checks for a game ending situation (win or draw)
  def endGame?
    king = @board.kingInCheck
    if king.nil? && @board.isDraw?
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

  # Manages saves and loads of the game
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
a.gameLoop
