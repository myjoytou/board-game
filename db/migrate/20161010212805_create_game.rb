class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :channel_name
      t.string :dimension_x
      t.string :dimension_y
    end
    add_index :games, :name
    add_index :games, :channel_name
  end
end
