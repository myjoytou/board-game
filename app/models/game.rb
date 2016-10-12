class Game < ActiveRecord::Base
  validates_presence_of :name, :channel_name, :dimension_x, :dimension_y
  validates_uniqueness_of :name
  has_many :players
  has_one :board
  serialize :params, JSON

  def self.get_current_games
    Game.where(status: 'active')
  end

  def get_move(human_move)
    human_move_to_coordinates(human_move)
  end

  def game_over_message(board)
    return "#{Player.find_by_color(board.game.winner).name} won!" if board.game_over == :winner
  end

  def self.create_new_game(params)
    game = Game.new
    game.name = params['game_name']
    game.channel_name = params['game_name']
    game.dimension_x = params['x_dimension']
    game.dimension_y = params['y_dimension']
    game.status = 'active'
    game.save!
    game
  end

  # def assign_player(player)
  #   map = PlayerToGameMap.new
  #   map.player = player.id
  #   map.game = self.id
  #   map.save!
  # end

  # def set_player_to_color_map(player, color)
  #   map = PlayerToColorMap.new
  #   map.player_id = player.id
  #   map.color = color
  #   map.save!
  # end

  def get_game_by_name(game_name)
    @@current_games.each do |game|
      if game.name == game_name
        return game
      end
    end
  end


  def play(current_player, cell)
    # x, y = get_move(cell_number)
    # board.set_cell(x, y, current_player.color)
    solicit_move(current_player.color, cell)
    if self.board.game_over
      return game_over_message self.board
    end
  end

  private

  def solicit_move(color, cell)
    cell.color = color
    cell.occupied = true
    cell.save!
  end

  def human_move_to_coordinates(human_move)
    mapping = {}
    index_counter = 0
    self.dimension_x.to_i.times do |x_index|
      self.dimension_y.to_i.times do |y_index|
        mapping[index_counter] = [x_index, y_index]
      end
    end
    puts "====================== the maping is #{mapping}"
    mapping[human_move]
  end
end