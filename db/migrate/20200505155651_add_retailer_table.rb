class AddRetailerTable < ActiveRecord::Migration[5.0]
  def change
    create_table :retailers do |t|
      t.string :name
    end
  end
end
