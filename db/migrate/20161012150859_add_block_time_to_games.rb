class AddBlockTimeToGames < ActiveRecord::Migration
  def change
  	add_column :games, :block_time, :string, :default => '5'
  end
end
