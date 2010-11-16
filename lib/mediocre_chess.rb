$:.unshift(File.join(File.dirname(__FILE__), 'mediocre'))
require 'java'
require 'mediocre/mediocre_v0.34.jar'
java_import 'mediocre.board.Board'
java_import 'mediocre.board.Move'

module MediocreChess
  # Input: FEN board rep., rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
  # Returns: Array of move strings, ['e2e4', 'd2d4', ...]
  def self.moves_for_fen(fen_board)
    board = Java::Mediocre.board.Board.new
    board.inputFen(fen_board)
    moves = Java::int[128].new
    number_of_moves = board.gen_allLegalMoves(moves, 0)
    results = []
    number_of_moves.times do |i|
      results << Java::mediocre.board.Move.inputNotation(moves[i])
    end
    results
  end
end
