class CreateBoard < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.belongs_to :game, index: true
      t.string :x_dime
      t.string :y_dime
    end
  end
end
