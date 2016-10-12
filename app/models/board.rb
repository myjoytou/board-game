class Board < ActiveRecord::Base
  belongs_to :game
  has_many :cells

  # def set_cell(x, y, value)
  #   @grid[x][y].value = value
  # end

  def self.create_board(params, game)
    board = Board.new
    board.game_id = game.id
    board.x_dime = params["x_dimension"]
    board.y_dime = params["y_dimension"]
    board.save!
    board.create_cells(params, board)
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

  def game_over
    return false if cell_remaining?
    return :winner if winner?
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

  def group_by_value(grid)
    value_groups = {}
    grid.each do |g_array|
      g_array.each do |g_elem|
        if value_groups[g_elem.value]
          value_groups[g_elem.value] << g_elem
        else
          value_groups[g_elem.value] = [g_elem]
        end
      end
    end
    value_groups
  end

  def default_grid(params)
    Array.new(params["x_dimension"].to_i) { Array.new(params["y_dimension"].to_i) {Cell.new} }
  end
end