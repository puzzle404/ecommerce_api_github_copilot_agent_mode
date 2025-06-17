class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.references :administrator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
