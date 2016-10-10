class Game
  @@current_games = []
  attr_reader :name, :channel_name, :board
  attr_accessor :players, :current_player, :dimension_x, :dimension_y
  attr_accessor :player_color_map
  def initialize(input)
    @name = input.fetch(:name)
    @channel_name = input.fetch(:channel_name)
    @dimension_x = input.fetch(:x_dimension)
    @dimension_y = input.fetch(:y_dimension)
    @board = Board.new({x_dime: @dimension_x, y_dime: @dimension_y})
    @player_color_map = {}
    @players = []
  end

  def get_move(human_move)
    human_move_to_coordinates(human_move)
  end

  def game_over_message
    return "#{current_player.name} won!" if board.game_over == :winner
  end

  def create_game
    game = Game.new({name: game_name, channel_name: game_name, x_dimension: x_dimension, y_dimension: y_dimension})
    @@current_games << game
    game
  end

  def assign_player(player)
    @players << player
  end

  def set_player_to_color_map(player, color)
    @player_color_map[player] = player_color
  end

  def get_game_by_name(game_name)
    @@current_games.each do |game|
      if game.name == game_name
        return game
      end
    end
  end

  def play(current_player, cell_number)
    x, y = get_move(cell_number)
    board.set_cell(x, y, current_player.symbol)
    if board.game_over
      puts game_over_message
    end
  end

  private

  def human_move_to_coordinates(human_move)
    mapping = {}
    index_counter = 0
    @dimension_x.times do |x_index|
      @dimension_y.times do |y_index|
        mapping[index_counter] = [x_index, y_index]
      end
    end
    mapping[human_move]
  end
end