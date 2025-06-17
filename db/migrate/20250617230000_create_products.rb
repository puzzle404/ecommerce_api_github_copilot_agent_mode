class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, null: false, default: 0
      t.text :description
      t.references :administrator, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end