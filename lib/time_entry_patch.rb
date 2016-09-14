# Visto en el blog ese que dice que no hace falta require. Blog sobre como hacer plugins de redmine
require_dependency 'time_entry'

#module Estatisticas

	module TimeEntryPatch

	  def self.included(base) 
		base.class_eval do
		  # Sobreescribe este metodo de time_entry engadindo a ultima liña de validacion de datas.
		  # O que fai e validar que a data introducida ao incurrir as horas sexa igual a data de hoxe
		  # Aparte inclue a validacion de non facer mais de 11 horas ao dia
		  def validate_time_entry

			# Comprobacion original de horas
			#errors.add :hours, :invalid if hours && (hours < 0 || hours >= 1000)
      
      # Engadidos por min
      # A imputacion de horas debe estar entre os valores configurados para o plugin
      errors.add :hours, :invalid if hours && (hours < Setting.plugin_estatisticas['min_horas'].to_i || hours >= Setting.plugin_estatisticas['max_horas'].to_i)
			# Non se poden imputar horas con mais de X dias de distancia
      errors.add :spent_on, :invalid if (spent_on - Date.today).to_i.abs > Setting.plugin_estatisticas['distancia_dias'].to_i
      # Fin engadidos por min
      
      errors.add :project_id, :invalid if project.nil?
			errors.add :issue_id, :invalid if (issue_id && !issue) || (issue && project!=issue.project) || @invalid_issue_id
			errors.add :activity_id, :inclusion if activity_id_changed? && project && !project.activities.include?(activity)
		  
		  end
		end
	   end
	end
#end
