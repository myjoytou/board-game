class Board < ActiveRecord::Base
  belongs_to :game
  has_many :cells

  def self.create_board(params, game)
    board = Board.new
    board.game_id = game.id
    board.x_dime = params["x_dimension"]
    board.y_dime = params["y_dimension"]
    board.save!
    board.create_cells(params, board)
  end


  def game_over
    return false if cell_remaining?
    return :winner if winner?
  end

  def create_cells(params, board)
    (board.x_dime.to_i * board.y_dime.to_i).times do |i|
      cell = Cell.new
      cell.board_id = board.id
      cell.cell_no = i
      cell.color = "ffffff"
      cell.save!
    end
  end

  def winner?
    winning_color_count = 0
    winning_color = ""
    self.cells.group_by(&:color).each do |key, value|
      if value.length > winning_color_count
        winning_color_count = value.length
        winning_color = key
      end
    end
    set_winner(winning_color)
    return winning_color
  end


  private

  def set_winner(color)
    game = self.game
    game.winner = color;
    game.save!
  end
  
  def cell_remaining?
    self.cells.where(occupied: false).any?
  end

end
