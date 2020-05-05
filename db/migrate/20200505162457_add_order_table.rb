class AddOrderTable < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      
      t.string :status
      t.integer :client_id
      t.timestamps
    end
  end
end
