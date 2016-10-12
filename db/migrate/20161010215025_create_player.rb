class CreatePlayer < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :game, index: true
      t.string :name
      t.string :color
    end
    add_index :players, :name
  end
end
