class AddApparelTable < ActiveRecord::Migration[5.0]
  def change
    create_table :apparels do |t|
      t.integer :client_id
      t.integer :inventory_id
    end
  end
end
