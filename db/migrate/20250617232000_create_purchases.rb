class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.date :purchase_date, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end