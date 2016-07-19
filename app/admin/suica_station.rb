ActiveAdmin.register SuicaStation do
  permit_params :area_code, :line_code, :station_code, :company, :line, :station, :note
  menu parent: 'suica_manage', priority: 1
end
