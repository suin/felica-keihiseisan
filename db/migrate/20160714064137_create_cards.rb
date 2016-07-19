class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :idm, limit: 16, null: false
      t.string :name, null: false, default: ''
      t.string :system_code, null: false
      t.string :system, null: false
      t.timestamps null: false
    end

    add_index :cards, :idm, unique: true
    add_foreign_key :cards, :admin_users, column: :user_id
  end
end
