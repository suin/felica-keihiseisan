ActiveAdmin.register SuicaTerminal do
  permit_params :code, :name
  menu parent: 'suica_manage', priority: 2
end
