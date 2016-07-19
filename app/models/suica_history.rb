class SuicaHistory < ActiveRecord::Base
  DEPOSIT = 500
  DATA_TYPES = %w(train bus sale_of_goods)
  EXPENSE_DATA_TYPES = %w(train bus)

  belongs_to :card
  belongs_to :terminal, class_name: :SuicaTerminal, foreign_key: :terminal_code, primary_key: :code
  belongs_to :processing, class_name: :SuicaProcessing, foreign_key: :processing_code, primary_key: :code

  def determine_expense!
    is_expense = false
    if EXPENSE_DATA_TYPES.include?(data_type)
      is_expense = true
    end

    if SuicaProcessing.charge?(processing_code)
      is_expense = false
    end

    write_attribute(:is_expense, is_expense)
  end

  def entered_station
    self.class.get_station(region, entered_line_code, entered_station_code)
  end

  def entered_station_name
    entered_station ? entered_station.station : nil
  end

  def exited_station
    self.class.get_station(region, exited_line_code, exited_station_code)
  end

  def exited_station_name
    exited_station ? exited_station.station : nil
  end

  def is_train?
    data_type == 'train'
  end

  def data_type_is_known?
    DATA_TYPES.include?(data_type)
  end

  def transfer
    if is_train?
      if SuicaProcessing.charge?(processing_code) ||
        SuicaProcessing.issue_new?(processing_code)
        []
      else
        [entered_station_name, exited_station_name]
      end
    else
      []
    end
  end

  def payment
    if SuicaProcessing.issue_new?(processing_code)
      return DEPOSIT
    end

    last_history = SuicaHistory
                     .where(card_id: card_id)
                     .where(serial_number: (serial_number - 2)..(serial_number - 1))
                     .select(:balance)
                     .order(serial_number: :desc)
                     .limit(1)
                     .first
    last_history ? last_history.balance - balance : nil
  end

  class << self
    def get_station(area_code, line_code, station_code)
      if area_code == 0 && line_code == 0 && station_code == 0
        nil
      else
        SuicaStation.find_by(
          area_code: area_code,
          line_code: line_code,
          station_code: station_code
        )
      end
    end

    def find_last_history(card_id)
      SuicaHistory
        .where(card_id: card_id)
        .order(serial_number: :desc)
        .limit(1)
        .first
    end
  end
end
