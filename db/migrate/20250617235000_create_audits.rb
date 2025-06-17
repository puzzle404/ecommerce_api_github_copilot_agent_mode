class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits do |t|
      t.string :action, null: false
      t.string :auditable_type
      t.integer :auditable_id
      t.integer :user_id
      t.jsonb :data
      t.datetime :created_at, null: false
    end

    add_index :audits, [:auditable_type, :auditable_id]
    add_index :audits, :user_id
  end
end