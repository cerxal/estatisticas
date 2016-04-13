module EstatisticasHelper

  include QueriesHelper
  include Redmine::Export::PDF

  # Este e un exemplo, non se usa.
  # TODO: Exemplo de opcions para un combo collidas do modelo. User para mostrar a versions de PRO
  def contorno_options_for_select(selected)
    user_count_by_status = User.group('status').count.to_hash
    options_for_select([[l(:label_all), ''],
                        ["#{l(:status_active)} (#{user_count_by_status[1].to_i})", '1'],
                        ["#{l(:status_registered)} (#{user_count_by_status[2].to_i})", '2'],
                        ["#{l(:status_locked)} (#{user_count_by_status[3].to_i})", '3']], selected.to_s)
  end

  def version_to_csv(items, columns)
    # Pasamoslle os items da lista de versions e o nome das columnas

    Redmine::Export::CSV.generate do |csv|

      # Incluir cabeceiras 
      csv << columns.map {|c| c.to_s}

      # Incluir filas 
      items.each do |item|
        csv << [item.name, item.description, item.due_date, item.estimated_hours, item.spent_hours, sprintf("%.2f",item.completed_percent).gsub('.', l(:general_csv_decimal_separator))]
      end
    end

  end

  def versions_to_pdf(versions)

    pdf = Redmine::Export::PDF::ITCPDF.new(current_language)
    pdf.set_title('Texto de proba: Nome proxecto')
    pdf.alias_nb_pages
    pdf.footer_date = format_date(Date.today)
    pdf.add_page
    pdf.SetFontStyle('B',11)
    pdf.RDMMultiCell(190,5, 'Texto de proba')
    pdf.ln
    # Set resize image scale
    pdf.set_image_scale(1.6)
    pdf.SetFontStyle('',9)
    pdf.output


  end

end
