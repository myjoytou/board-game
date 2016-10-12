class Player < ActiveRecord::Base
  validates_presence_of :name, :color
  validates_uniqueness_of :name
  belongs_to :game
  def self.get_assigned_colors
    Player.all.select(:color)
  end
  def self.create_player(params, game)
    player = Player.new
    player.game_id = game.id
    player.color = params[:color]
    player.name = params[:name]
    player.save!
    player
  end
  def assign_game(game)
    self.game_id = game.id
    self.save!
  end
end
