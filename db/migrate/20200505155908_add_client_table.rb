class AddClientTable < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
    end
  end
end
