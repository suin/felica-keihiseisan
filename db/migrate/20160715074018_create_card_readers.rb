class CreateCardReaders < ActiveRecord::Migration
  def change
    create_table :card_readers do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.timestamps null: false
    end

    add_index :card_readers, :token, unique: true
  end
end
