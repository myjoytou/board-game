class Game < ActiveRecord::Base
  validates_presence_of :name, :channel_name, :dimension_x, :dimension_y
  validates_uniqueness_of :name
  has_many :players
  has_one :board
  serialize :params, JSON

  def self.get_current_games
    Game.where(status: 'active')
  end


  def self.create_new_game(params)
    game = Game.new
    game.name = params['game_name'].downcase
    game.channel_name = params['game_name']
    game.dimension_x = params['x_dimension']
    game.dimension_y = params['y_dimension']
    game.status = 'active'
    game.block_time = params['block_time']
    game.save!
    Board.create_board(params, game)
    game
  end

  def play(current_player, cell)
    solicit_move(current_player.color, cell)
    if self.board.game_over
      return game_over_message self.board
    end
  end

  private

  def game_over_message(board)
    return "#{Player.find_by_color(board.game.winner).name} won!" if board.game_over == :winner
  end

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
