class AddProductOrderTable < ActiveRecord::Migration[5.0]
  def change
    create_table :product_orders do |t|
      t.integer :order_id
      t.integer :product_id
    end
  end
end
