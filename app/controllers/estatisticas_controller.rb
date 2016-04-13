class EstatisticasController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :mostrar

  helper :sort
  include SortHelper

  helper :queries
  helper :projects
  helper :custom_fields
  include QueriesHelper
  include EstatisticasHelper

  def mostrar
      sort_init 'effective_date', 'desc'
      sort_update %w(name description effective_date)

      # Comprobacion dos parametros de filtro para crear o scope e enviar a vista
      # construye el scope en función de los parámetros que entran.
      # scope = @project.versions
      @versions=Version.where("project_id=?",@project.id)

      # Incluir as versions pechadas
      if !params[:pechadas]
        @versions = @versions.where("status in ('open','locked')")
      end

      # Incluir as versions que comenza por unha letra. Permite por exemplo filtrar todas as versions intermedias antes da final
      if params[:nome].present?
        @versions = @versions.where("name like :nome", nome: "#{params[:nome]}%")

      end

      # Contorno
      patronversion = "(^[0-9]+\.{0}\.[0-9]+\.[0-9]+$)"
      if params[:contorno].present?
	if params[:contorno]=='STG' 
       	  @versions = @versions.where("NOT name REGEXP ? ", patronversion) 
	else
       	  @versions = @versions.where("name REGEXP ? ", patronversion) 
	end
      end
      # Data dende
      if params[:data_dende].present?
	    dd = Date.parse(params[:data_dende]) rescue nil
        @versions = @versions.where("effective_date >= :data_dende", {data_dende: dd}) 
      end
      # Data ata
      if params[:data_ata].present?
	    da = Date.parse(params[:data_ata]) rescue nil
        @versions = @versions.where("effective_date <= :data_ata", {data_ata: da}) 
      end

      #logger.debug("ramiro: #{sort_clause.to_s}")

      #Para tener el byebug añadi el require 'bybug' al aplicacion.rb del core y al Gemfile. Habria que sacarlo
      @versions=@versions.order(sort_clause)

      # Nome das columnas da lista de versions pa mandar ao csv
      columns = []
      columns << t(:label_nome_version)
      columns << t(:label_desc_version)
      columns << t(:label_data_version) 
      columns << t(:label_total_tempo_estimado)
      columns << t(:label_total_tempo_gastado)
      columns << t(:label_tanto_porcento_completado)
      columns << t(:label_tipo_version)
      columns << t(:label_estado_version)
      columns << t(:label_contorno)

      respond_to do |format|
        format.html 
        format.csv  { send_data(version_to_csv(@versions, columns), :type => 'text/csv; header=present', :filename => 'version.csv') }
        format.pdf  { send_file_headers! :type => 'application/pdf', :filename => 'version.pdf' }
      end

  end

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
