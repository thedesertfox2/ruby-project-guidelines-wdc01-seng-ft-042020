class AddProductTable < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :cost
      t.integer :product_type_id
    end
  end
end
