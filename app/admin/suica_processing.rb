ActiveAdmin.register SuicaProcessing do
  permit_params :code, :name
  menu parent: 'suica_manage', priority: 3
end
