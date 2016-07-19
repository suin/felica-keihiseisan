class CreateSuicaTerminals < ActiveRecord::Migration
  def change
    create_table :suica_terminals do |t|
      t.integer :code, null: false
      t.string :name, null: false
    end
    add_index :suica_terminals, :code, unique: true

    # add default data
    {
      3 => '精算機',
      4 => '携帯型端末',
      5 => '車載端末',
      7 => '券売機',
      8 => '券売機',
      9 => '入金機',
      18 => '券売機',
      20 => '券売機等',
      21 => '券売機等',
      22 => '改札機',
      23 => '簡易改札機',
      24 => '窓口端末',
      25 => '窓口端末',
      26 => '改札端末',
      27 => '携帯電話',
      28 => '乗継精算機',
      29 => '連絡改札機',
      31 => '簡易入金機',
      70 => 'VIEW ALTTE',
      72 => 'VIEW ALTTE',
      199 => '物販端末',
      200 => '自販機'
    }.each { |code, name|
      SuicaTerminal.create(code: code, name: name)
    }
  end
end
