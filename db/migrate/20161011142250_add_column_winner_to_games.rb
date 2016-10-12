class AddColumnWinnerToGames < ActiveRecord::Migration
  def change
    add_column :games, :winner, :string
  end
end
