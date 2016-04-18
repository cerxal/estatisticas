require 'redmine'

# Aqui permitimos sobreescribir o modelo da Version
ActionDispatch::Callbacks.to_prepare do 
  require_dependency 'version'
  Version.send(:include, VersionPatch)
  
end

Redmine::Plugin.register :estatisticas do
  name 'Estatisticas plugin'
  author 'AMTEGA-Xunta de Galicia'
  description 'Mostra unha táboa de versións por proxecto'
  version '0.0.1'

  project_module :estatisticas do
    #permission :estatisticas, { :estatisticas => [:mostrar] }
    permission :ver_estatisticas, :estatisticas => :mostrar
    menu :project_menu, :estatisticas, { :controller => 'estatisticas', :action => 'mostrar' }, :caption => :label_menu_estatisticas, :after => :activity, :param => :project_id
  end
  
  settings :default => {'tipo_version' => 'Tipo de versión'}, 
           :partial => 'settings/estatisticas_settings'

end
