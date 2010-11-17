$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

describe MediocreChess::Board do
  # The purpose of these tests are not to test Mediocre methods,
  # but rather the JRuby wrapper.

  before(:each) do
    @board = MediocreChess::Board.new
  end

  context "fen boards" do
    it "should be created with the default board" do
      @board.fen.should == 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
    end

    it "should be properly received and generated" do
      @board.fen = '8/3K4/2p5/p2b2r1/5k2/8/8/1q6 b - - 1 67'
      @board.fen.should == '8/3K4/2p5/p2b2r1/5k2/8/8/1q6 b - - 1 67'
    end
  end

  context "move generation" do
    it "should generate moves of the correct format" do
      moves = @board.moves
      moves.count.should == 20 # verifying the moves work
      moves.each { |move| move.should match /[a-h][1-8][a-h][1-8]/ }
    end
  end

  context "move addition" do
    it "should add legal moves" do
      @board.add!('e2e4')
      @board.fen.should == 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
    end

    it "should only add legal moves" do
      lambda { @board.add!('e7e5') }.should raise_error(MediocreChess::IllegalMoveException)
    end
  end

  context "game state" do
    it "should be normal at the initial position" do
      @board.checkmate?.should be false
      @board.stalemate?.should be false
      @board.winner.should be nil
    end

    it "should find checkmate" do
      @board.fen = '2Q5/p4pkp/3p2p1/3P4/3b4/2P5/PP6/6qK w - - 0 37'
      @board.checkmate?.should be true
      @board.stalemate?.should be false
      @board.winner.should be MediocreChess::BLACK
    end

    it "should find stalemate" do
      @board.fen = '8/8/8/8/8/1K6/2Q5/k7 b - - 0 1'
      @board.fen.should == '8/8/8/8/8/1K6/2Q5/k7 b - - 0 1'
      @board.checkmate?.should be false
      @board.stalemate?.should be true
      @board.winner.should be nil 
    end
  end
end
