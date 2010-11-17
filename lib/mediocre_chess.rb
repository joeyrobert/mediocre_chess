$:.unshift(File.join(File.dirname(__FILE__), 'mediocre'))
require 'java'
require 'mediocre/mediocre_v0.34.jar'
java_import 'mediocre.board.Board'
java_import 'mediocre.board.Move'
java_import 'mediocre.engine.Engine'

module MediocreChess
  class IllegalMoveException < Exception; end
  class InvalidFenException < Exception; end
  WHITE = 1; BLACK = -1

  class Board
    def initialize(fen_board = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
      @board = Java::Mediocre.board.Board.new
      self.fen = fen_board
    end

    # FEN Methods
    def fen; @board.getFen; end

    def fen=(fen_board)
        @board.inputFen(fen_board)
      rescue
        raise MediocreChess::InvalidFenException.new("'#{fen_board}' is an invalid FEN board. The board may be in a bad state.")
    end

    # Returns: Array of legal move strings, ['e2e4', 'd2d4', ...]
    def moves
      number_of_moves, moves = gen_legal_moves
      results = []
      number_of_moves.times do |i|
        results << Java::mediocre.board.Move.inputNotation(moves[i])
      end
      results
    end

    # Input: move string, "e2e4"
    # Raises: IllegalMoveException
    def add!(move_string)
      number_of_moves, moves = gen_legal_moves
      number_of_moves.times do |i|
        if Java::mediocre.board.Move.inputNotation(moves[i]) == move_string
          @board.makeMove(moves[i])
          return
        end
      end

      raise MediocreChess::IllegalMoveException.new("'#{move_string}' is not a legal chess move.")
    end

    def stalemate?
      number_of_moves, moves = gen_legal_moves
      number_of_moves == 0 && !Java::Mediocre.engine.Engine.isInCheck(@board)
    end

    def checkmate?
      number_of_moves, moves = gen_legal_moves
      number_of_moves == 0 && Java::Mediocre.engine.Engine.isInCheck(@board)
    end

    # Returns: MediocreChess::WHITE if white won
    #          MediocreChess::BLACK if black won
    #          nil if the game isn't checkmated
    def winner
      if checkmate?
        -1 * @board.toMove
      end
    end

    private

    def gen_legal_moves
      moves = Java::int[128].new
      number_of_moves = @board.gen_allLegalMoves(moves, 0)
      [number_of_moves, moves]
    end
  end
end
