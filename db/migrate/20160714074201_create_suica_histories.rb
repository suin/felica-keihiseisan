class CreateSuicaHistories < ActiveRecord::Migration
  def change
    create_table :suica_histories do |t|
      t.integer :card_id, null: false
      t.integer :serial_number, null: false
      t.string :data_type, null: false
      t.integer :terminal_code, null: false
      t.integer :processing_code, null: false
      t.date :date, null: false
      t.integer :balance, null: false
      t.integer :entered_line_code
      t.integer :entered_station_code
      t.integer :exited_line_code
      t.integer :exited_station_code
      t.integer :region
      t.boolean :is_expense, null: false, default: true
      t.string :block, limit: 32, null: false
      t.timestamps null: false
    end
    add_index :suica_histories, [:card_id, :serial_number, :date], unique: true
    add_foreign_key :suica_histories, :cards, on_update: :cascade, on_delete: :cascade
  end
end
