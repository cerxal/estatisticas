require_dependency 'version'

# Engade o campo contorno ao modelo de Version. 
module VersionPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class 
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
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
    def contorno
      patronversion = "(^[0-9]+\.{0}\.[0-9]+\.[0-9]+$)"
      return self.to_s.match(patronversion) ? "PRO" : "STG"
    end

  end    

end

# Add module to Version
Version.send(:include, VersionPatch)
