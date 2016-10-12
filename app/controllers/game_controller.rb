class GameController < BaseController

  def create_game
    validate_data
    player_color = assign_color
    game = Game.create_new_game(data)
    log_msg("#{game}")
    Board.create_board(data, game)
    player = Player.create_player({color: player_color, name: data['player_name']}, game)
    trigger_success({game_details: game, player_details: player})
  end

  def join_game
    validate_join_data
    game = Game.find(data['game_id'])
    player = Player.find_by_name(data['player_name'])
    if player.blank?
      player_color = assign_color
      player = Player.create_player({color: player_color, name: data['player_name']}, game)
    end
    puts "============================== #{game.players.length}"
    if game.players.length >= 2
      WebsocketRails[game.channel_name.to_sym].trigger :start_game, {game_details: game, player_details: player, grid: game.board.cells}
    end

  end

  def play
    validate_play_data
    player = Player.find(data['player_id'])
    game = Game.find(data['game_id'])
    cell = game.board.cells.find(data['cell_id'])

    winner = game.play(player, cell)
    player_stats = []
    game.players.each do |pl|
      temp = {}
      temp['player_name'] = pl.name
      temp['count'] = pl.game.board.cells.where(color: pl.color)
      player_stats << temp
    end
    WebsocketRails[game.channel_name.to_sym].trigger :winner, {winner: winner}
    WebsocketRails[game.channel_name.to_sym].trigger :move_info, {status: 'success', grid: game.board.cells, player_stats: player_stats}
  end

  def get_active_games
    trigger_success({current_games: Game.get_current_games})
  end

  private

  def validate_play_data
    raise "Player id not present!" if data['player_id'].blank?
    raise "Cell not present!" if data['cell_id'].blank?
    raise "Game id not present!" if data['game_id'].blank?
  end

  def log_msg(stage)
    Rails.logger.info "Coming to #{stage}"
  end

  def validate_join_data
    raise "Game not provided!" if data['game_id'].blank?
    raise "Player name required" if data['player_name'].blank?
  end

  def validate_data
    raise "Game name required!" if data["game_name"].blank?
    raise "Game name already taken!" if check_game_name(data["game_name"])
    raise "X dimension not provided" if data["x_dimension"].blank?
    raise "Y dimensino not provided" if data["y_dimension"].blank?
    raise "Player name not provided" if data["player_name"].blank?
  end

  def assign_color
    color = "%06x" % (rand * 0xffffff)
    while(Player.get_assigned_colors.include?(color))
      color = "%06x" % (rand * 0xffffff)
    end
    color
  end

  def check_game_name(game_name)
    Game.get_current_games.map(&:name).include?(game_name)
  end
end
