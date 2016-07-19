class CreateSuicaStations < ActiveRecord::Migration
  def change
    create_table :suica_stations do |t|
      t.integer :area_code, null: false
      t.integer :line_code, null: false
      t.integer :station_code, null: false
      t.string :company, null: false
      t.string :line, null: false
      t.string :station, null: false
      t.string :note, null: false
    end
    add_index :suica_stations, [:area_code, :line_code, :station_code], unique: true
  end
end
