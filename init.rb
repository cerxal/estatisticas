
require 'redmine'

# Añadimos el cambio en el modelo del TimeEntry
TimeEntry.send(:include, TimeEntryPatch)
Version.send(:include, VersionPatch)

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
  
  settings :default => {'tipo_version' => 'Tipo de versión',
						'min_horas' => 0,
						'max_horas' => 11,
						'distancia_dias' => 0}, 
           :partial => 'settings/estatisticas_settings'
           
           
  require_dependency 'hooks/controller_timelog_criterios_hook'

end
