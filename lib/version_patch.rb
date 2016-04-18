# Visto en el blog ese que dice que no hace falta require. Blog sobre como hacer plugins de redmine
#require_dependency 'version'

include CustomFieldsHelper

# Engade o campo contorno ao modelo de Version. 
module VersionPatch


  def self.included(base) # :nodoc:

    #base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      #unloadable # Send unloadable so it will not be unloaded in development
      #alias_method_chain :open_issues_count, :oicp
    end

  end
  
  module ClassMethods

    #def self.stg
    #  where(status: 'open')
    #end
    #scope :stg, -> { where 'NOT name REGEXP ?', patronversion }
    #scope :pro, -> { where 'name REGEXP ?', patronversion }
  end
  
  module InstanceMethods

    # Sobre escribe el open_issues_count
    #def open_issues_count_with_oicp
    #		return 79
    #end

    # Añade el metodo contorno al modelo de la version, calculado a partir de la numeracion de la version
    # TODO: Añadir el patron de la version como un elemento configurable del plugin.
    def contorno
      patronversion = "(^[0-9]+\.{0}\.[0-9]+\.[0-9]+$)"
      return self.to_s.match(patronversion) ? "PRO" : "STG"
    end
    
    def tipo_version
      # Añade el campo tipo_version al objecto Version. Permite mostrar el tipo de version para cada caso
      tp=nil

      self.visible_custom_field_values.each do | custom_value|
        if custom_value.custom_field.name==Setting.plugin_estatisticas['tipo_version']
          tp=custom_value.value
        end
      end

      return tp
    end

  end    

end

# Add module to Version
Version.send(:include, VersionPatch)
