ActiveAdmin.register SuicaHistory do
  menu priority: 10

  filter :card
  filter :date
  filter :is_expense

  controller do
    actions :all, :except => [:new, :edit, :destroy]
  end

  index do
    column :id
    column :is_expense
    column :card, :sortable => :card_id
    column :data_type, :sortable => :data_type do |history|
      get_history_data_type(history)
    end

    column :date
    column :station do |history|
      get_transfer_route(history)
    end

    # column :balance, :sortable => :balance do |history|
    #   number_to_currency(history.balance)
    # end

    column :payment do |history|
      if history.payment == nil
        I18n.t('suica.history.payment_unknown')
      elsif history.payment < 0
        "(#{number_to_currency(history.payment * -1)})"
      else
        number_to_currency(history.payment)
      end
    end

    column :processing do |history|
      history.processing.name
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :card
      row :serial_number
      row :data_type do |history|
        get_history_data_type(history)
      end
      row :terminal_code
      row :terminal
      row :processing_code
      row :processing
      row :date
      row :balance
      row :entered_station_name
      row :entered_line_code
      row :entered_station_code
      row :exited_station_name
      row :exited_line_code
      row :exited_station_code
      row :region
      row :is_expense
      row :block
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  csv do
    column :id
    column :is_expense do |history|
      history.is_expense ? '○' : '×'
    end
    column :card do |history|
      history.card.display_name
    end
    column :data_type do |history|
      get_history_data_type(history)
    end
    column :date
    column :entered_at do |history|
      history.entered_station_name
    end
    column :exited_at do |history|
      history.exited_station_name
    end
    column :payment do |history|
      history.payment
    end
    column :processing do |history|
      history.processing.name
    end
  end
end
