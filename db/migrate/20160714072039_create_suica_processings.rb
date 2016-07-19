class CreateSuicaProcessings < ActiveRecord::Migration
  def change
    create_table :suica_processings do |t|
      t.integer :code, null: false
      t.string :name, null: false
    end
    add_index :suica_processings, :code, unique: true

    # add default data
    {
      1 => '運賃支払(改札出場)',
      2 => 'チャージ',
      3 => '券購(磁気券購入)',
      4 => '精算',
      5 => '精算 (入場精算)',
      6 => '窓出 (改札窓口処理)',
      7 => '新規 (新規発行)',
      8 => '控除 (窓口控除)',
      13 => 'バス (PiTaPa系)',
      15 => 'バス (IruCa系)',
      17 => '再発 (再発行処理)',
      19 => '支払 (新幹線利用)',
      20 => '入A (入場時オートチャージ)',
      21 => '出A (出場時オートチャージ)',
      31 => '入金 (バスチャージ)',
      35 => '券購 (バス路面電車企画券購入)',
      70 => '物販',
      72 => '特典 (特典チャージ)',
      73 => '入金 (レジ入金)',
      74 => '物販取消',
      75 => '入物 (入場物販)',
      198 => '物現 (現金併用物販)',
      203 => '入物 (入場現金併用物販)',
      132 => '精算 (他社精算)',
      133 => '精算 (他社入場精算)'
    }.each { |code, name|
      SuicaProcessing.create(code: code, name: name)
    }
  end
end
