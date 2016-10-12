class CreateCell < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.belongs_to :board, index: true
      t.string :cell_no
      t.string :color
    end
    add_index :cells, :cell_no
  end
end
