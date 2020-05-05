class AddInventoryTable < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :name
      t.float :cost
    end
  end
end
