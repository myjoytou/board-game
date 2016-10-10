class GameController < WebSocketRails::BaseController
  def create_game
    raise "Game name required!" if params[:game_name].blank?
    raise "Game name already taken!" if check_game_name(params[:game_name])
    game_name = params[:game_name]
    x_dimension = params[:x_dimension]
    y_dimension = params[:y_dimension]
    player_name = params[:player_name]
    player_color = assign_color
    game = Game.create_game({name: game_name, channel_name: game_name, x_dimension: x_dimension, y_dimension: y_dimension})
    player = Player.new({color: player_color, name: player_name})
    game.set_player_to_color_map(player, player_color)
    game.assign_player(player)
  end

  def join_game

  end

  private

  def assign_color
    color = "%06x" % (rand * 0xffffff)
    while(!Player.assigned_colors.include?(color))
      color = "%06x" % (rand * 0xffffff)
    end
    color
  end

  def check_game_name(game_name)
    !Game.current_games.keys.include?(game_name.to_sym)
  end
end