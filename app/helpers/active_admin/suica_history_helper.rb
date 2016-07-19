module ActiveAdmin::SuicaHistoryHelper
  def get_history_data_type(history)
    data_type = history.data_type_is_known? ? history.data_type : 'unknown'
    I18n.t("suica.history.data_type.#{data_type}")
  end

  def get_transfer_route(history)
    history.transfer.map { |x| x ? x : '?' }.join(' → ')
  end
end
