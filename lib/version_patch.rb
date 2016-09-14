# Visto en el blog ese que dice que no hace falta require. Blog sobre como hacer plugins de redmine
require_dependency 'version'

include CustomFieldsHelper

#module Estatisticas

	module VersionPatch

	  def self.included(base) 

		base.class_eval do
			# Añade el metodo contorno al modelo de la version, calculado a partir de la numeracion de la version
			# TODO: Añadir el patron de la version como un elemento configurable del plugin.
			def contorno
			  patronversion = "(^[0-9]+\.{0}\.[0-9]+\.[0-9]+$)"
			  return self.to_s.match(patronversion) ? "PRO" : "STG"
			end
      
      
      # Rerturn Schedule Performance Index
      def SPI

        #byebug
        if self.estimated_hours>0 and !self.start_date.nil? and !self.due_date.nil?
          hoxe_dias=(Date.parse(Time.now.to_s) - self.start_date).to_f
          total_dias=(self.due_date-self.start_date).to_f
          earned_value= (completed_percent * estimated_hours)/100 # Podria ser tambien las spent_hours
          planned_value=(hoxe_dias/total_dias)*estimated_hours
          return (earned_value/planned_value)
        else
          return 0
        end

      rescue
        return 0

      end

      # Rerturn Cost Performance Index
      def CPI
        if self.spent_hours>0 and self.estimated_hours>0
          earned_value= (self.completed_percent * self.estimated_hours)/100
          actual_cost=self.spent_hours
          return (earned_value/actual_cost)
        else
          return 0
        end

      rescue
        return 0
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
	
	end
#end
