class Board
  attr_reader :grid
  def initialize(input = {})
    @x_dime = input.fetch(:x_dime)
    @y_dime = input.fetch(:y_dime)
    @grid = input.fetch(:grid, default_grid(@x_dime, @y_dime))
  end

  def set_cell(x, y, value)
    @grid[x][y].value = value
  end

  def game_over
    return false if cell_remaining?(@grid)
    return :winner if winner?
  end

  def winner?
    value_groups = group_by_value(@grid)
    max_cell = 0
    winning_value = 0
    value_groups.each do |group, cell_array|
      cell_length = cell_array.length
      if cell_length > max_cell
        max_cell = cell_length
        winning_value = cell_array[0].value
      end
    end
    true
  end

  private

  def cell_remaining?(grid)
    grid.each do |g_array|
      return true if g_array.any_empty?
    end
    false
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

  def default_grid(x_dime, y_dime)
    Array.new(x_dime) { Array.new(y_dime) {Cell.new} }
  end
end