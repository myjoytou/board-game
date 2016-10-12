class Player < ActiveRecord::Base
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
end