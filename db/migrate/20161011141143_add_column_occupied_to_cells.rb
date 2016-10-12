class AddColumnOccupiedToCells < ActiveRecord::Migration
  def change
    add_column :cells, :occupied, :boolean, :default => false
  end
end
